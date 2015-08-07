//
//  StepListViewController.m
//  SBS
//
//  Created by li Conner on 14-3-4.
//  Copyright (c) 2014年 Tellyes. All rights reserved.
//

#import "StepListViewController.h"
#import "StepViewCell.h"
#import "SkillDetailViewController.h"
#import <sqlite3.h>

@interface StepListViewController ()
@property(strong,nonatomic)NSString *productName;
@property(strong,nonatomic)NSArray *list;
@property(strong,nonatomic)ASIHTTPRequest *request;
@property(strong,nonatomic)NSString *IP;
@end

@implementation StepListViewController

-(id)initWithName:(NSString *)name
{
    if (self = [super init]) {
        //_productName = [[NSString alloc] initWithString:name];
        _productName = [[NSString alloc] initWithString:name];
    }
    return self;
}
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
} */

-(void)viewWillAppear:(BOOL)animated
{
    NSString* uid =((AppDelegate*)[[UIApplication sharedApplication] delegate]).Uid;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/handlers/ModelHandler.ashx?code=%@&uniquid=%@&iphone=1",self.IP,[_productName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[uid stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];

    self.request = [ASIHTTPRequest requestWithURL:url];
    
    [self.request setDelegate:self];
    
    [self.request startAsynchronous];
    [self.navigationItem setTitle:@"技能展示"];
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
//    [self.navigationController setNavigationBarHidden:YES];
    [self.request clearDelegatesAndCancel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.list = [[NSArray alloc]init];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.myTableView setBackgroundColor:[UIColor clearColor]];
    [self.myTableView setSeparatorColor:[UIColor clearColor]];
    [self.myTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    static NSString *CustomCellIdentifier = @"StepCell";
    
    StepViewCell *cell =(StepViewCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    
    if (cell==nil)
    {
        cell = [[StepViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CustomCellIdentifier];
        //cell.delegate = self;
    }
    NSDictionary* dic = [self.list objectAtIndex:indexPath.row];
    cell.numLable.text =[NSString stringWithFormat: @"%d", indexPath.row+1];
    cell.textLable1.text = [dic objectForKey:@"S_name"];
    return (UITableViewCell *)cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = [self.list objectAtIndex:indexPath.row];
    //SkillIntroViewController * controller = [[SkillIntroViewController alloc] initWithName:self.productName];
    //controller.data = [dic objectForKey:@"S_id"];
    //[self.navigationController pushViewController:controller animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSError *error =nil;
    NSDictionary *userDic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:&error];
    if ([userDic objectForKey:@"M_Name" ] != nil)
    {
        self.list =[userDic objectForKey:@"SkillList" ];
        [self.myTableView reloadData];
        
    }else
    {
        [SVProgressHUD showErrorWithStatus:[userDic objectForKey:@"ResponseState"]];
    }
    
    NSLog(@"%@\n",[userDic objectForKey:@"ResponseState"]);
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Failed!!!!!");
    [SVProgressHUD showErrorWithStatus:@"访问服务器失败。"];
}

@end
