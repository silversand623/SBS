//
//  LoginViewController.m
//  SBS
//
//  Created by li Conner on 14-2-13.
//  Copyright (c) 2014年 Tellyes. All rights reserved.
//

#import "LoginViewController.h"
#import "StepListViewController.h"
#import "ZBarViewController.h"
#import "SVProgressHUD.h"
#import "WTNetWork.h"
#import "UIKit+WTRequestCenter.h"
#import "UIImageView+WTRequestCenter.h"
#define SIMULATOR 1

@interface LoginViewController ()
@property(nonatomic,strong) NSString *IP;
@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:SVProgressHUDDidReceiveTouchEventNotification
                                               object:nil];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *user = [defaults objectForKey:@"username"];
    self.usernameLable.text = user;
}

- (void)handleNotification:(NSNotification *)notif
{
    [SVProgressHUD dismiss];
}

- (IBAction)otherButtonPressed:(id)sender
{
    [self.usernameLable resignFirstResponder];
    [self.passwordLable resignFirstResponder];
    //[self.myScrollView setContentOffset:CGPointMake(0,0) animated:YES];
    
}
- (IBAction)configButtonPressed:(id)sender
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"设置IP" message:@"请输入IP地址" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil ] ;
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    UITextField *tf=[alert textFieldAtIndex:0];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    tf.text=[defaults objectForKey:@"ipconfig"];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        UITextField *tf=[alertView textFieldAtIndex:0];
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        [defaults setObject:tf.text forKey:@"ipconfig"];
        [defaults synchronize];
        
    }
}

- (IBAction)loginButtonPressed:(id)sender
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    self.IP = [defaults objectForKey:@"ipconfig"];
    [SVProgressHUD showWithStatus:@"正在登陆" maskType:SVProgressHUDMaskTypeGradient];
    if (self.usernameLable.text.length == 0 || self.passwordLable.text.length == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"请输入用户名密码！" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [SVProgressHUD dismiss];
        return;
    }
    else
    {
        NSString *userName = [self.usernameLable.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //NSString* passWord = self.passwordLable.text;
        
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        [defaults setObject:self.IP forKey:@"ipconfig"];
        
        [defaults setObject:userName forKey:@"username"];
        [self userLogin];
    }
}

-(void) userLogin
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"ipconfig"]==nil) {
        return;
    }
    
    NSString* passWord = self.passwordLable.text;
    
    NSString *BaseUrl=[defaults objectForKey:@"ipconfig"];
    NSString *user = [defaults objectForKey:@"username"];
    
    NSString *url = [NSString stringWithFormat:@"http://%@/handlers/TextLoginHandler.ashx?name=%@&psd=%@",BaseUrl,user,passWord];
    
    
    [WTRequestCenter getWithURL:url parameters:nil option:WTRequestCenterCachePolicyNormal
                       finished:^(NSURLResponse *response, NSData *data) {
                           [SVProgressHUD dismiss];
                           NSError *jsonError = nil;
                           NSDictionary *userDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                           if (!jsonError) {
                               if ([[userDic objectForKey:@"ResponseState"] isEqualToString:@"passed"])
                               {
                                   ((AppDelegate*)[[UIApplication sharedApplication] delegate]).Uid =[userDic objectForKey:@"uniquID"];
                                   NSLog(@"%@\n",[userDic objectForKey:@"uniquID"]);
                                   ////////
#ifndef SIMULATOR
                                   ZBarReaderViewController *reader = [ZBarReaderViewController new];
                                   reader.readerDelegate = self;
                                   ZBarImageScanner *scanner = reader.scanner;
                                   [scanner setSymbology: ZBAR_I25
                                                  config: ZBAR_CFG_ENABLE
                                                      to: 0];
                                   [self presentViewController:reader animated:YES completion:nil];
#endif
                                   
#ifdef SIMULATOR
                                   ((AppDelegate*)[[UIApplication sharedApplication] delegate]).modelName = @"TY000112345678NUI0300051ADC00";
                                   //全功能急救人140301
                                   UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SBS" bundle:nil];
                                   
                                   [self presentViewController:[storyboard instantiateInitialViewController] animated:YES completion:nil];

#endif
                                   
                               } else
                               {
                                   [SVProgressHUD showErrorWithStatus:[userDic objectForKey:@"Reason"]];
                               }
                           } else
                           {
                               [SVProgressHUD showErrorWithStatus:[jsonError localizedDescription]];
                           }
                           
                           
                       }failed:^(NSURLResponse *response, NSError *error) {
                           [SVProgressHUD dismiss];
                           [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                       }];
    
}

- (void)imagePickerController: (UIImagePickerController*)reader didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results =  [info objectForKey: ZBarReaderControllerResults];
    
    NSString *name = [[NSString alloc] init];
    for(ZBarSymbol *symbol in results)
    {
        name = symbol.data;
        break;
    }
    [reader dismissViewControllerAnimated:YES completion:^(){
        
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).modelName = name;
        //全功能急救人140301
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SBS" bundle:nil];
        
        [self presentViewController:[storyboard instantiateInitialViewController] animated:YES completion:nil];
    }];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.passwordLable.text = nil;
    //[self.myScrollView setContentOffset:CGPointMake(0,0) animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    //[self.myScrollView setContentOffset:CGPointMake(0,0) animated:YES];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //[self.myScrollView setContentOffset:CGPointMake(0,200) animated:YES];
}

@end
