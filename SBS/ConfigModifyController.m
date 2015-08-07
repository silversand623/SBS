//
//  ConfigModifyController.m
//  SBS
//
//  Created by LiZhe on 14-9-22.
//  Copyright (c) 2014年 Tellyes. All rights reserved.
//

#import "ConfigModifyController.h"
#import "LoginViewController.h"
#import "SVProgressHUD.h"
#import "ASIHTTPRequest.h"

@interface ConfigModifyController ()
@property(nonatomic) sqlite3 *DB;
@property(nonatomic,strong) ASIHTTPRequest *request;
@property(nonatomic,strong) NSString *IP;
@property(nonatomic) BOOL isPasswordModify;
@end

@implementation ConfigModifyController

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
    self.isPasswordModify = NO;
    // Do any additional setup after loading the view from its nib.
    [self queryIPData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    
    [self.myScrollView setContentOffset:CGPointMake(0,0) animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)passwordButtonPress:(id)sender
{
    [self.myScrollView setContentOffset:CGPointMake(0,-50) animated:YES];
    [self closeKeyboard];
    
    NSString * newPasword = self.NewPassword.text;
    NSString * configPasword = self.ConfigNewPassword.text;
    if ([newPasword length] < 6) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"密码长度要多于6位" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (![newPasword isEqualToString:configPasword]) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"新密码不相同" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [SVProgressHUD showWithStatus:@"正在验证身份信息" maskType:SVProgressHUDMaskTypeGradient];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/handlers/TextLoginHandler.ashx?name=%@&psd=%@&iphone=1",self.IP,[self.UserName.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[self.LastPassword.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] ];
    
    self.request = [ASIHTTPRequest requestWithURL:url];
    [self.request setDelegate:self];
    [self.request startAsynchronous];
}

-(IBAction)ipconfigButtonPress:(id)sender
{
    [self closeKeyboard];
    
    int config1 = [self.IPConfig1.text intValue];
    int config2 = [self.IPConfig2.text intValue];
    int config3 = [self.IPConfig3.text intValue];
    int config4 = [self.IPConfig4.text intValue];
    if ( config1> 254 || config1 < 1 || config2>254 || config2<1 || config3>254 || config3<1 || config4>254 || config4<1) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"设置有误" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [self insertDataIntoIP];
    [SVProgressHUD showSuccessWithStatus:@"设置成功"];
    self.IP = [NSString stringWithFormat:@"%d.%d.%d.%d",config1,config2,config3,config4];
    [self.myScrollView setContentOffset:CGPointMake(0,-45) animated:YES];
}

-(IBAction)backButtonPress:(id)sender
{
    [self closeKeyboard];
    
    LoginViewController *controller = [[LoginViewController alloc] init];
    [self.navigationController presentViewController:controller animated:YES completion:nil];
     [self resignFirstResponder];
}

- (IBAction)otherButtonPressed:(id)sender
{
    [self closeKeyboard];

    [self.myScrollView setContentOffset:CGPointMake(0,-45) animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
        case 1:
        case 2:
        case 3:
            [self.myScrollView setContentOffset:CGPointMake(0,-45) animated:YES];
            break;
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
            [self.myScrollView setContentOffset:CGPointMake(0,100) animated:YES];
            break;
        default:
            break;
    }
}

-(NSString *) dataFilePath
{
    NSArray *path =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *document = [path objectAtIndex:0];
    
    return [document stringByAppendingPathComponent:@"SBSDB"];//'persion.sqlite'
}

-(void)queryIPData
{
    sqlite3 *database;
    if (sqlite3_open([[self dataFilePath] UTF8String], &database)!=SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"open database faid!");
        NSLog(@"数据库创建失败！");
    }
    
    NSString *quaryIP = @"SELECT * FROM IP WHERE FLAG='IP' ";//SELECT ROW,FIELD_DATA FROM FIELDS ORDER BY ROW
    sqlite3_stmt *stmtIP;
    if (sqlite3_prepare_v2(database, [quaryIP UTF8String], -1, &stmtIP, nil) == SQLITE_OK) {
        while (sqlite3_step(stmtIP)==SQLITE_ROW) {
            char *config1 = (char *)sqlite3_column_text(stmtIP, 1);
            self.IPConfig1.text = [[NSString alloc] initWithUTF8String:config1];
            char *config2 = (char *)sqlite3_column_text(stmtIP, 2);
            self.IPConfig2.text  = [[NSString alloc] initWithUTF8String:config2];
            char *config3 = (char *)sqlite3_column_text(stmtIP, 3);
            self.IPConfig3.text  = [[NSString alloc] initWithUTF8String:config3];
            char *config4 = (char *)sqlite3_column_text(stmtIP, 4);
            self.IPConfig4.text  = [[NSString alloc] initWithUTF8String:config4];
            char *portConfig = (char *)sqlite3_column_text(stmtIP, 5);
            self.PortConfig.text  = [[NSString alloc] initWithUTF8String:portConfig];
            
            self.IP = [NSString stringWithFormat:@"%@.%@.%@.%@:%@",self.IPConfig1.text,self.IPConfig2.text,self.IPConfig3.text,self.IPConfig4.text,self.PortConfig.text];
        }
    }

    sqlite3_close(database);
}
-(void)insertDataIntoIP
{
    sqlite3 *database;
    if (sqlite3_open([[self dataFilePath] UTF8String], &database)!=SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"open database faid!");
        NSLog(@"数据库创建失败！");
    }

    NSString *insert = [NSString stringWithFormat:@"INSERT OR REPLACE INTO IP('%@','%@','%@','%@','%@','%@','%@')VALUES('%d','%@','%@','%@','%@','%@','%@')   ",@"ID",@"IPCONFIG1",@"IPCONFIG2",@"IPCONFIG3",@"IPCONFIG4",@"PORTCONFIG",@"FLAG",1,self.IPConfig1.text,self.IPConfig2.text,self.IPConfig3.text,self.IPConfig4.text,self.PortConfig.text,@"IP"];
    char *errorMsg;
    //执行语句
    if (sqlite3_exec(database, [insert UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"%@",[[NSString alloc] initWithUTF8String:errorMsg]);
    }
    
    sqlite3_close(database);
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
    NSError *error =nil;
    NSDictionary *userDic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:&error];
    if ([[userDic objectForKey:@"ResponseState"] isEqualToString:@"1"])
    {
        if (self.isPasswordModify) {
            [SVProgressHUD showSuccessWithStatus:@"修改密码成功"];
            self.isPasswordModify = NO;
            return;
        }
        self.isPasswordModify = YES;
        [SVProgressHUD showWithStatus:@"正在修改密码" maskType:SVProgressHUDMaskTypeGradient];
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).Uid =[userDic objectForKey:@"uniquID"];
        NSString *uid = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).Uid;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/handlers/PassWordRest.ashx?newPsd=%@&uniquid=%@&iphone=1",self.IP,[self.NewPassword.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[uid stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] ];
        
        self.request = [ASIHTTPRequest requestWithURL:url];
        [self.request setDelegate:self];
        [self.request startAsynchronous];
    }else
    {
        if (!self.isPasswordModify) {
            [SVProgressHUD showErrorWithStatus:@"账号验证失败!"];
        }
        else{
            [SVProgressHUD showErrorWithStatus:@"修改密码失败!"];
            self.isPasswordModify = NO;
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"与服务器请求失败!"];
}

-(void)closeKeyboard
{
    [self.UserName resignFirstResponder];
    [self.LastPassword resignFirstResponder];
    [self.NewPassword resignFirstResponder];
    [self.ConfigNewPassword resignFirstResponder];
    [self.IPConfig1 resignFirstResponder];
    [self.IPConfig2 resignFirstResponder];
    [self.IPConfig3 resignFirstResponder];
    [self.IPConfig4 resignFirstResponder];
    [self.PortConfig resignFirstResponder];
}

@end
