//
//  ViewController.m
//  StoryboardTutorial-UITableViews1
//
//  Created by xxd on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ExamViewController.h"
#import "StepViewCell.h"
#import "WTNetWork.h"
#import "UIKit+WTRequestCenter.h"
#import "UIImageView+WTRequestCenter.h"
#import "UIImage+WTRequestCenter.h"

@interface ExamViewController()
@property(strong,nonatomic)NSArray *list;
@property(strong,nonatomic)NSString *IP;
@property(strong,nonatomic)NSString *productName;
@end

@implementation ExamViewController



@synthesize states,datasource;
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.productName = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).modelName;
    // Do any additional setup after loading the view, typically from a nib.
    self.list = [[NSArray alloc]init];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"扫一扫" style:UIBarButtonItemStylePlain target:self action:@selector(backToScan)];
    
    [self getModelInfo];
}

-(void) backToScan{
    //跳转到父视图
    //[self.navigationController popViewControllerAnimated:YES];
    
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    ZBarImageScanner *scanner = reader.scanner;
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    [self presentViewController:reader animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.productName = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).modelName;
    [self getModelInfo];
}

- (void)imagePickerController: (UIImagePickerController*)reader didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results =  [info objectForKey: ZBarReaderControllerResults];
    
    NSString *name = [[NSString alloc] init];
    for(ZBarSymbol *symbol in results)
    {
        name = symbol.data;
        [reader dismissViewControllerAnimated:YES completion:^(){
            
            ((AppDelegate*)[[UIApplication sharedApplication] delegate]).modelName = name;
            self.productName = name;
            [self getModelInfo];
        }];
        break;
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ExamCell";
    StepViewCell *cell = (StepViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[StepViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary* dic = [self.list objectAtIndex:indexPath.row];
    cell.textLable1.text = [dic objectForKey:@"S_name"];
    
    return cell;
}

//------------------TableView Cell Height------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}


-(void) getModelInfo
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"ipconfig"]==nil) {
        return;
    }
    
    NSString *BaseUrl=[defaults objectForKey:@"ipconfig"];
    
    NSString* uniID =((AppDelegate*)[[UIApplication sharedApplication] delegate]).Uid;
    
    NSString *url = [NSString stringWithFormat:@"http://%@/handlers/ModelHandler.ashx?code=%@&uniquid=%@&iphone=1",BaseUrl,[_productName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[uniID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    [WTRequestCenter getWithURL:url parameters:nil option:WTRequestCenterCachePolicyNormal
                       finished:^(NSURLResponse *response, NSData *data) {
                           NSError *jsonError = nil;
                           NSDictionary* userDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                           if ([userDic objectForKey:@"M_Name" ] != nil)
                           {
                               ((AppDelegate*)[[UIApplication sharedApplication] delegate]).modelID = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"M_id"]];
                               self.list =[userDic objectForKey:@"SkillList" ];
                               [self.tableView reloadData];
                               
                           }else
                           {
                               [SVProgressHUD showErrorWithStatus:[userDic objectForKey:@"ResponseState"]];
                           }
                           
                       }failed:^(NSURLResponse *response, NSError *error) {
                           //[SVProgressHUD showErrorWithStatus:@"访问服务器失败。"];
                       }];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *destination = segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    NSDictionary* dic = [self.list objectAtIndex:indexPath.row];
    
    if ([destination respondsToSelector:@selector(setData:)]) {
        [destination setValue:[dic objectForKey:@"S_id"] forKey:@"data"];
    }
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).skillID = [dic objectForKey:@"S_id"];
}

@end
