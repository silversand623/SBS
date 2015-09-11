//
//  OnlyTextTableViewController.h
//  SBS
//
//  Created by lyn on 15/7/1.
//  Copyright (c) 2015年 Tellyes. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SMALLFONT 15
#define BIGFONT 20
#define WIDTH 280


@interface OnlyTextTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *skillText;
@property (nonatomic, strong) NSString *sIndex;
@property (nonatomic, strong) NSString *sTotal;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *currentPage;
@property (weak, nonatomic) IBOutlet UILabel *totalPage;
@end
