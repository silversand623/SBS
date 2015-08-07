//
//  ViewController.m
//  StoryboardTutorial-UITableViews1
//
//  Created by xxd on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PersonalInfoViewController.h"

#import "WTNetWork.h"
#import "UIKit+WTRequestCenter.h"
#import "UIImageView+WTRequestCenter.h"

@interface PersonalInfoViewController()
@end

@implementation PersonalInfoViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getUserInfo];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) getUserInfo
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"ipconfig"]==nil) {
        return;
    }
    
    NSString *BaseUrl=[defaults objectForKey:@"ipconfig"];
    NSString *user = [defaults objectForKey:@"username"];
    
    NSString* uniID =((AppDelegate*)[[UIApplication sharedApplication] delegate]).Uid;
    
    NSString *url = [NSString stringWithFormat:@"http://%@/handlers/TextGetUserInfoHandler.ashx?name=%@&uniquid=%@",BaseUrl,[user stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],uniID];
    
    
    [WTRequestCenter getWithURL:url parameters:nil option:WTRequestCenterCachePolicyNormal
                      finished:^(NSURLResponse *response, NSData *data) {
                            NSError *jsonError = nil;
                            id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                            if (!jsonError) {
                                [[self stuName] setText:[obj objectForKey:@"UserName"]];
                                [[self className] setText:[obj objectForKey:@"BanJiName"]];
                                [[self phone] setText:[obj objectForKey:@"Phone"]];
                                NSString *imageUrl = [NSString stringWithFormat:@"http://%@%@",BaseUrl,[obj objectForKey:@"PhotoPath"]];
                                [[self imgUser] setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"personal-1.png"] finished:^(NSURLResponse *response, NSData *data) {
                                    
                                    
                                    
                                } failed:^(NSURLResponse *response, NSError *error) {
                                    
                                }];
                            }else
                            {
                                
                            }
                            
                        }failed:^(NSURLResponse *response, NSError *error) {
                            NSLog(@"xx");
                        }];
    
}


-(int)dealError:(NSString *) result{
    int nCase = [result integerValue];
    switch (nCase) {
        case 1:
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"用户名密码错误" message:@"用户名输入错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            break;
        }
        case 2:
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"用户名密码错误" message:@"密码输入错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            break;
        }
        case 3:
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"考试信息" message:@"当前时间没有考试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            break;
        }
        case 4:
        {
            break;
        }
        default:
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"其它错误" message:@"其他内部错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            break;
        }
    }
    
    return nCase;
}


//页面将要进入前台，开启定时器
-(void)viewWillAppear:(BOOL)animated
{
    //开启定时器
    //[_myTimer setFireDate:[NSDate distantPast]];
    //_myTag = NO;
}

//页面消失，进入后台不显示该页面，关闭定时器
-(void)viewDidDisappear:(BOOL)animated
{
    //关闭定时器
    //[_myTimer setFireDate:[NSDate distantFuture]];
}


@end
