//
//  StartExamViewController.m
//  SBS
//
//  Created by lyn on 15/7/16.
//  Copyright (c) 2015年 Tellyes. All rights reserved.
//

#import "StartExamViewController.h"
#import "AppDelegate.h"
#import "WTNetWork.h"
#import "UIKit+WTRequestCenter.h"
#import "UIImageView+WTRequestCenter.h"
#import "UIImage+WTRequestCenter.h"
#import "SVProgressHUD.h"
#import "ExamDevicesTableViewController.h"
#import "CountDownViewController.h"

@interface StartExamViewController ()

@end

@implementation StartExamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeValue:) name:@"ChangeValue" object:nil];
    
    if (self.cameraID == 0 || self.timeID == 0) {
        [self.startBtn setUserInteractionEnabled:NO];
        [self.startBtn setBackgroundImage:[UIImage imageNamed:@"graybutton.png"] forState:UIControlStateNormal];
    } else
    {
        [self.startBtn setUserInteractionEnabled:YES];
        [self.startBtn setBackgroundImage:[UIImage imageNamed:@"bluebutton.png"] forState:UIControlStateNormal];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)ChangeValue:(NSNotification *)text{
    int nPage = [text.userInfo[@"Page"] integerValue];
    int nIndex = [text.userInfo[@"IndexID"] integerValue];
    
    if (nPage == 0) {
        self.cameraID = nIndex;
    } else if (nPage == 1)
    {
        self.timeID = nIndex;
    }
    
    if (self.cameraID == 0 || self.timeID == 0) {
        [self.startBtn setUserInteractionEnabled:NO];
        [self.startBtn setBackgroundImage:[UIImage imageNamed:@"graybutton.png"] forState:UIControlStateNormal];
    } else
    {
        [self.startBtn setUserInteractionEnabled:YES];
        [self.startBtn setBackgroundImage:[UIImage imageNamed:@"bluebutton.png"] forState:UIControlStateNormal];
    }
}

-(void) sendStartExam
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"ipconfig"]==nil) {
        return;
    }
    NSArray *StatusArray = [[NSArray alloc] initWithObjects:@"120",@"300",@"600",nil];
    
    NSString *BaseUrl=[defaults objectForKey:@"ipconfig"];
    
    NSString* uniID =((AppDelegate*)[[UIApplication sharedApplication] delegate]).Uid;
    NSString *modId = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).modelID;
    NSString *skillId = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).skillID;
    NSString *user = [defaults objectForKey:@"username"];
    
    if (self.cameraID == 0 || self.timeID == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择摄像头和考试时间"];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"http://%@/Handlers/StartExamHandler.ashx?uniquid=%@&name=%@&S_id=%@&M_id=%@&DeviceID=%d&ExamDuration=%@",BaseUrl,uniID,user,skillId,modId,self.cameraID,[StatusArray objectAtIndex:self.timeID-1]];
    [SVProgressHUD showWithStatus:@"正在准备开始考核" maskType:SVProgressHUDMaskTypeGradient];
    
    [WTRequestCenter getWithURL:url parameters:nil option:WTRequestCenterCachePolicyNormal
                       finished:^(NSURLResponse *response, NSData *data) {
                           [SVProgressHUD dismiss];
                           NSError *jsonError = nil;
                           id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                           NSString *sRet = [obj objectForKey:@"result"];
                           if (!jsonError) {
                               if ([sRet isEqualToString:@"1"]) {
                                   //1.storyboard中定义某个独立newViewController（无segue跳转关系）的 identifier
                                   static  NSString *controllerId =@"CountDown";
                                   //2.获取UIStoryboard对象
                                   UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SBS" bundle:nil];
                                   //3.从storyboard取得newViewCtroller对象，通过Identifier区分
                                   CountDownViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:controllerId];
                                   NSString *strID = [obj objectForKey:@"ExamID"];
                                   viewController.examId = [strID integerValue];
                                   viewController.durationTime = [[StatusArray objectAtIndex:self.timeID-1] integerValue];
                                   [self.navigationController pushViewController:viewController animated:YES];
                                   
                               } else if ([sRet isEqualToString:@"0"])
                               {
                                   [SVProgressHUD showErrorWithStatus:@"申请考试失败，数据库或网络异常"];
                               } else if ([sRet isEqualToString:@"-1"])
                               {
                                   [SVProgressHUD showErrorWithStatus:@"申请考试失败，设备被占用"];
                               }
                           }else
                           {
                               [SVProgressHUD showErrorWithStatus:[jsonError localizedDescription]];
                           }
                           
                       }failed:^(NSURLResponse *response, NSError *error) {
                           [SVProgressHUD dismiss];
                           [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                       }];
    
}


- (IBAction)startExam:(UIButton *)sender {
    [self sendStartExam];
}
@end
