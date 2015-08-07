//
//  StepListViewController.h
//  SBS
//
//  Created by li Conner on 14-3-4.
//  Copyright (c) 2014年 Tellyes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "SkillIntroViewController.h"

@interface StepListViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>
-(id)initWithName:(NSString *)name;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end
