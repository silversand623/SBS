//
//  CameraViewController.m
//  SBS
//
//  Created by lyn on 15/6/26.
//  Copyright (c) 2015年 Tellyes. All rights reserved.
//

#import "CameraViewController.h"

#import "RMMapper.h"
#import "CameraInfo.h"
#import "AppDelegate.h"
#import "WTNetWork.h"
#import "UIKit+WTRequestCenter.h"
#import "UIImageView+WTRequestCenter.h"
#import "UIImage+WTRequestCenter.h"
#import "SVProgressHUD.h"

@interface CameraViewController ()
@property(strong,nonatomic)NSMutableArray *list;
@property(strong,nonatomic)NSIndexPath *lastIndexPath;
@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.list = [[NSMutableArray alloc]init];
    [self getCamerasInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CameraCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    CameraInfo *ciInfo = (CameraInfo*)self.list[indexPath.row];
    NSString *msg = [NSString stringWithFormat:@"ID:%@ 位置:%@ 设备:%@",ciInfo.ID,ciInfo.videoAddress,ciInfo.videoFirm];
    [cell.textLabel setText:msg];
    
    // 重用机制，如果选中的行正好要重用
    int oldRow = (_lastIndexPath != nil) ? [_lastIndexPath row] : -1;
    if (oldRow == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int newRow = [indexPath row];
    int oldRow = (_lastIndexPath != nil) ? [_lastIndexPath row] : -1;
    if(newRow != oldRow)
    {
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:_lastIndexPath];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        _lastIndexPath = indexPath;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _imgCamera.image = nil;
    
    NSString *deviceId = [self.list[indexPath.row] ID];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"ipconfig"]==nil) {
        return;
    }
    
    NSString *BaseUrl=[defaults objectForKey:@"ipconfig"];
    
    NSString *userName = [defaults objectForKey:@"username"];
    
    NSString* uniID =((AppDelegate*)[[UIApplication sharedApplication] delegate]).Uid;
    
    NSString *url = [NSString stringWithFormat:@"http://%@/Handlers/CapturePictureHandler.ashx?uniquid=%@&name=%@&DeviceID=%@",BaseUrl,uniID,userName,deviceId];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *strText = cell.textLabel.text;
    [SVProgressHUD showWithStatus:@"正在加载摄像头截取图片信息" maskType:SVProgressHUDMaskTypeGradient];
    
    [WTRequestCenter getWithURL:url parameters:nil option:WTRequestCenterCachePolicyNormal
                       finished:^(NSURLResponse *response, NSData *data) {
                           [SVProgressHUD dismiss];
                           UIImage *temp = [UIImage imageWithData:data];
                           CameraInfo *ciInfo = (CameraInfo*)self.list[indexPath.row];
                           self.nIndex = [ciInfo.ID intValue];
                           [self.delegate passValue:strText fromPage:0 id:[ciInfo.ID intValue]];
                           if (temp != nil) {
                               _imgCamera.image = temp;
            
                           }else
                           {
                               [SVProgressHUD showErrorWithStatus:@"加载摄像头图片失败"];
                           }
                           
                       }failed:^(NSURLResponse *response, NSError *error) {
                           [SVProgressHUD dismiss];
                           [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                       }];
    
}

-(void) getCamerasInfo
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"ipconfig"]==nil) {
        return;
    }
    
    NSString *BaseUrl=[defaults objectForKey:@"ipconfig"];
    
    NSString* uniID =((AppDelegate*)[[UIApplication sharedApplication] delegate]).Uid;
    
    NSString *url = [NSString stringWithFormat:@"http://%@/Handlers/FindCameraHandler.ashx?uniquid=%@",BaseUrl,uniID];
    [SVProgressHUD showWithStatus:@"正在加载摄像头信息" maskType:SVProgressHUDMaskTypeGradient];
    
    [WTRequestCenter getWithURL:url parameters:nil option:WTRequestCenterCachePolicyNormal
                       finished:^(NSURLResponse *response, NSData *data) {
                           [SVProgressHUD dismiss];
                           NSError *jsonError = nil;
                           id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                           id objList = [obj objectForKey:@"deviceList"];
                           if (!jsonError) {
                               _list = [RMMapper mutableArrayOfClass:[CameraInfo class]
                                                                 fromArrayOfDictionary:objList];
                               
                               BOOL bTag = NO;
                               int nID = 0;
                               if (self.nIndex > 0) {
                                
                                   for (int i = 0; i < self.list.count; i++) {
                                       CameraInfo *ciInfo = (CameraInfo*)self.list[i];
                                       if (self.nIndex == [ciInfo.ID intValue]) {
                                           bTag = YES;
                                           nID = i;
                                           break;
                                       }
                                   }
                                   if (bTag) {
                                       _lastIndexPath = [NSIndexPath indexPathForItem:nID inSection:0];
                                    }
                                   
                               }
                               [[self tableView] reloadData];
                           }else
                           {
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
