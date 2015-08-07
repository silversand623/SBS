//
//  ExamDevicesTableViewController.m
//  SBS
//
//  Created by lyn on 15/7/15.
//  Copyright (c) 2015年 Tellyes. All rights reserved.
//

#import "ExamDevicesTableViewController.h"
#import "CameraViewController.h"
#import "ChooseTimeViewController.h"

@interface ExamDevicesTableViewController ()

@end

@implementation ExamDevicesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)passValue:(NSString *)value fromPage:(int)nPage id:(int)nIndex
{

    if (nPage == 0) {
        self.deviceName.text = value;
        self.cameraID = nIndex;
    } else if (nPage == 1)
    {
        self.examTime.text = value;
        self.timeID = nIndex;
    }
    
    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",nIndex],@"IndexID",[NSString stringWithFormat:@"%d",nPage],@"Page", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"ChangeValue" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"camera"])
    {
        CameraViewController *camera = (CameraViewController*)segue.destinationViewController;
        camera.delegate = self;
        camera.nIndex = self.cameraID;
    } else if ([segue.identifier isEqualToString:@"time"])
    {
        ChooseTimeViewController *time = (ChooseTimeViewController*)segue.destinationViewController;
        time.delegate = self;
        time.nIndex = self.timeID;
    }
    
}

@end
