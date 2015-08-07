//
//  UserInfoViewController.m
//  SBS
//
//  Created by lyn on 15/6/25.
//  Copyright (c) 2015年 Tellyes. All rights reserved.
//
#import "AppDelegate.h"
#import "UserInfoViewController.h"

#import "WTNetWork.h"
#import "UIKit+WTRequestCenter.h"
#import "UIImageView+WTRequestCenter.h"
#import "SVProgressHUD.h"

@interface UserInfoViewController ()

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(clickRightButton)];
    [[self navigationItem] setRightBarButtonItem:rightButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dimissAlert:(UIAlertView *)alert
{
    if(alert)
    {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
}

- (void)showAlert:(NSString*)title message:(NSString*)msg elasptedTime:(double)dTime{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil
                                          cancelButtonTitle:nil otherButtonTitles:nil];
    
    [alert show];
    [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:dTime];
}

-(void)clickRightButton {
    NSString *newPwd = [[self txtPwd] text];
    NSString *repeatPwd = [[self txtRepeatPwd] text];
    NSString *oldPwd = [[self txtOldPwd] text];
    if ([newPwd isEqualToString:repeatPwd] && ![newPwd  isEqual: @""] && ![oldPwd isEqual:@""]) {
        [self changePwd];
    } else
    {
        [self showAlert:@"用户密码输入错误" message:@"用户密码不能为空或输入不一致" elasptedTime:2.0];
        
    }
}

-(void) changePwd
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"ipconfig"]==nil) {
        return;
    }
    [SVProgressHUD showWithStatus:@"正在修改密码" maskType:SVProgressHUDMaskTypeGradient];
    NSString *BaseUrl=[defaults objectForKey:@"ipconfig"];
    NSString *user = [defaults objectForKey:@"username"];
    
    NSString* uniID =((AppDelegate*)[[UIApplication sharedApplication] delegate]).Uid;
    
    NSString* pwd = [[self txtPwd] text];
    
    NSString* oldPwd = [[self txtOldPwd] text];
    
    NSString *url = [NSString stringWithFormat:@"http://%@/handlers/PassWordRest.ashx?name=%@&oldPsd=%@&newPsd=%@&uniquid=%@",BaseUrl,[user stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],oldPwd,pwd,uniID];
    
    
    [WTRequestCenter getWithURL:url parameters:nil option:WTRequestCenterCachePolicyNormal
                       finished:^(NSURLResponse *response, NSData *data) {
                           NSError *jsonError = nil;
                           [SVProgressHUD dismiss];
                           id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                           if (!jsonError) {
                               NSString* strResult = [obj objectForKey:@"ResponseState"];
                               if ([strResult isEqualToString:@"1"]) {
                                   [SVProgressHUD showSuccessWithStatus:@"用户修改密码成功"];
                                   [self.navigationController popViewControllerAnimated:YES];
                               } else if ([strResult isEqualToString:@"-1"])
                               {
                                   [SVProgressHUD showErrorWithStatus:@"用户输入原始密码不正确"];
                               } else
                               {
                                   [SVProgressHUD showErrorWithStatus:@"修改密码失败，请重新输入"];
                               }
                               
                           }else
                           {
                               //ResponseState
                               [SVProgressHUD showErrorWithStatus:[jsonError localizedDescription]];
                           }
                           
                       }failed:^(NSURLResponse *response, NSError *error) {
                           [SVProgressHUD dismiss];
                           [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                       }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
