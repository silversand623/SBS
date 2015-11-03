//
//  SkillIntroViewController.m
//  SBS
//
//  Created by LiZhe on 14-5-16.
//  Copyright (c) 2014年 Tellyes. All rights reserved.
//

#import "SkillIntroViewController.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+LK.h"
#import <sqlite3.h>
#import "WTNetWork.h"
#import "UIKit+WTRequestCenter.h"
#import "UIImageView+WTRequestCenter.h"
#import "TTViewController.h"
#import "UIImageView+LK.h"
#import "SVProgressHUD.h"

@interface SkillIntroViewController ()
@property(nonatomic,strong) NSArray * detailInfo;
@property(nonatomic,strong)NSString *IP;
@property(nonatomic,strong)NSString *name;
@end

@implementation SkillIntroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.detailInfo = [[NSArray alloc]init];
    [self getSkillInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:SVProgressHUDDidReceiveTouchEventNotification
                                               object:nil];
    
    UISwipeGestureRecognizer *recognizer;
      
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:recognizer];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{

    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        if (self.detailInfo == nil) {
            [SVProgressHUD showErrorWithStatus:@"当前技能没有内容，请返回。"];
        } else
        {
            [self imageClicked];
        }
    }

}

- (void)handleNotification:(NSNotification *)notif
{
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) getSkillInfo
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"ipconfig"]==nil) {
        return;
    }
    
    NSString *BaseUrl=[defaults objectForKey:@"ipconfig"];    
    
    NSString* uniID =((AppDelegate*)[[UIApplication sharedApplication] delegate]).Uid;
    
    NSString *url = [NSString stringWithFormat:@"http://%@/handlers/TextGetDetailHandler.ashx?s_id=%@&uniquid=%@&iphone=1",BaseUrl,self.data,[uniID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    [WTRequestCenter getWithURL:url parameters:nil option:WTRequestCenterCachePolicyNormal
                       finished:^(NSURLResponse *response, NSData *data) {
                           NSError *jsonError = nil;
                           self.detailInfo = nil;
                           self.detailInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                           
                           if (!jsonError) {
                               if (self.detailInfo.count != 0)
                               {
                                   [self addStartLog];
                                   
                                   NSDictionary * dic = [self.detailInfo objectAtIndex:0];
                                   NSString * imageUrl =[NSString stringWithFormat:@"http://%@%@",BaseUrl,[dic objectForKey:@"HeadPicPath"]];
                                   __weak UIImageView *weakImageView = self.InfoPic;
                                   [SVProgressHUD showWithStatus:@"正在加载图片" maskType:SVProgressHUDMaskTypeGradient];
                                   
                                   [weakImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"loading.png"] finished:^(NSURLResponse *response, NSData *data) {
                                       [SVProgressHUD dismiss];
                                       NSString * strPic = [dic objectForKey:@"HeadPicPath"];
                                       if (![strPic isEqualToString:@""]) {
                                           [SVProgressHUD showSuccessWithStatus:@"图片加载成功"];
                                       }
                                       
                                       self.InfoPic.onTouchTapBlock = ^(UIImageView * view)
                                       {
                                           [self imageClicked];
                                           
                                       };
                                       
                                   } failed:^(NSURLResponse *response, NSError *error) {
                                       [SVProgressHUD dismiss];
                                       [SVProgressHUD showErrorWithStatus:@"图片加载失败"];
                                   }];
                                   
                               }
                           }else
                           {
                               
                           }
                           
                       }failed:^(NSURLResponse *response, NSError *error) {
                           NSLog(@"xx");
                       }];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    //[self.navigationController setHidesBarsOnTap:NO];
}

- (void)imageClicked{
    TTViewController * controller = [[TTViewController alloc] init];
    controller.detailList = self.detailInfo;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"返回技能列表"
                                             style:UIBarButtonItemStylePlain
                                             target:self
                                             action:nil];
    //[self.navigationController setHidesBarsOnTap:YES];
    [self.navigationController pushViewController:controller animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    
}

-(void) addStartLog
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"ipconfig"]==nil) {
        return;
    }
    NSString* uniID =((AppDelegate*)[[UIApplication sharedApplication] delegate]).Uid;
    
    NSString *BaseUrl=[defaults objectForKey:@"ipconfig"];
    NSString *modId = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).modelID;
    NSString *skillId = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).skillID;
    NSString *user = [defaults objectForKey:@"username"];
    
    NSString *url = [NSString stringWithFormat:@"http://%@/handlers/LogAddHandler.ashx?M_id=%@&S_id=%@&name=%@&uniquid=%@",BaseUrl,modId,skillId,user,[uniID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    [WTRequestCenter getWithURL:url parameters:nil option:WTRequestCenterCachePolicyNormal
                       finished:^(NSURLResponse *response, NSData *data) {
                           //[SVProgressHUD dismiss];
                           NSError *jsonError = nil;
                           NSDictionary *userDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                           if (!jsonError) {
                               if ([[userDic objectForKey:@"result"] isEqualToString:@"-1"])
                               {
                                   //[SVProgressHUD showErrorWithStatus:[userDic objectForKey:@"Reason"]];
                                   
                               } else
                               {
                                   ((AppDelegate*)[[UIApplication sharedApplication] delegate]).logID = [userDic objectForKey:@"result"];
                               }
                           } else
                           {
                               //[SVProgressHUD showErrorWithStatus:[jsonError localizedDescription]];
                           }
                           
                           
                       }failed:^(NSURLResponse *response, NSError *error) {
                           //[SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                       }];
    
}

@end
