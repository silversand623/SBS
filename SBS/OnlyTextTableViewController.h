//
//  OnlyTextTableViewController.h
//  SBS
//
//  Created by lyn on 15/7/1.
//  Copyright (c) 2015年 Tellyes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"
#define SMALLFONT 17
#define BIGFONT 20
#define WIDTH 280


@interface OnlyTextTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,MWPhotoBrowserDelegate>
@property (nonatomic, strong) NSArray *skillText;
@property (nonatomic, strong) NSString *sIndex;
@property (nonatomic, strong) NSString *sTotal;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *currentPage;
@property (weak, nonatomic) IBOutlet UILabel *totalPage;
@property (nonatomic, strong) NSMutableArray *photos;
@end
