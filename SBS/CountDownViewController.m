//
//  CountDownViewController.m
//  SBS
//
//  Created by lyn on 15/7/16.
//  Copyright (c) 2015年 Tellyes. All rights reserved.
//

#import "CountDownViewController.h"
#import "AppDelegate.h"
#import "WTNetWork.h"
#import "UIKit+WTRequestCenter.h"
#import "UIImageView+WTRequestCenter.h"
#import "UIImage+WTRequestCenter.h"
#import "SVProgressHUD.h"
#define FONTSIZE 38

@interface CountDownViewController ()

@end

@implementation CountDownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithTitle:@"<返回" style:UIBarButtonItemStylePlain target:self action:@selector(doBack)];
    self.navigationItem.leftBarButtonItem = backItem;
    [self customiseAppearance];
    
    [_myTimer setStartValue:_durationTime*1000];
    [_myTimer start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customiseAppearance {
    [_myTimer setBoldFont:[UIFont fontWithName:@"HelveticaNeue" size:FONTSIZE]];
    [_myTimer setRegularFont:[UIFont fontWithName:@"HelveticaNeue" size:FONTSIZE]];
    
    // The font property of the label is used as the font for H,M,S and MS
    [_myTimer setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:28]];
    
    // Default label properties
    //_counterLabel.textColor = [UIColor darkGrayColor];
    [_myTimer setDisplayMode:kDisplayModeSeconds];
    _myTimer.countDirection = kCountDirectionDown;
    _myTimer.countdownDelegate = self;
    // After making any changes we need to call update appearance
    [_myTimer setTextAlignment:NSTextAlignmentCenter];
    [_myTimer updateApperance];
}

- (void)countdownDidEndForSource:(TTCounterLabel *)source {
    if (_myTimer.isRunning) {
        [_myTimer stop];
        
    }
    [self sendEndExam];
    [SVProgressHUD showSuccessWithStatus:@"考试时间到，马上结束考试"];
}

-(void)doBack
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"结束考核提示信息" message:@"当前考核还未结束，请确认是否退出考核" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil ] ;
    [alert show];
}

 
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        
        [self sendEndExam];
    }
}

-(void) sendEndExam
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"ipconfig"]==nil) {
        return;
    }
    
    NSString *BaseUrl=[defaults objectForKey:@"ipconfig"];
    
    NSString* uniID =((AppDelegate*)[[UIApplication sharedApplication] delegate]).Uid;
    NSString *user = [defaults objectForKey:@"username"];
    
    NSString *url = [NSString stringWithFormat:@"http://%@/Handlers/EndExamHandler.ashx?uniquid=%@&name=%@&ExamID=%d",BaseUrl,uniID,user,self.examId];
    [SVProgressHUD showWithStatus:@"正在结束考核" maskType:SVProgressHUDMaskTypeGradient];
    
    [WTRequestCenter getWithURL:url parameters:nil option:WTRequestCenterCachePolicyNormal
                       finished:^(NSURLResponse *response, NSData *data) {
                           [SVProgressHUD dismiss];
                           NSError *jsonError = nil;
                           id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                           NSString *sRet = [obj objectForKey:@"result"];
                           if (!jsonError) {
                               if ([sRet isEqualToString:@"1"]) {
                                   
                                   //[self.navigationController popToRootViewControllerAnimated:YES];
                               }else
                               {
                                   //[SVProgressHUD showErrorWithStatus:@"结束考试失败，数据库或网络异常"];
                               }
                           }else
                           {
                               //[SVProgressHUD showErrorWithStatus:[jsonError localizedDescription]];
                           }
                           
                           [self.navigationController popToRootViewControllerAnimated:YES];
                           
                       }failed:^(NSURLResponse *response, NSError *error) {
                           [SVProgressHUD dismiss];
                           [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                       }];
    
}

@end
