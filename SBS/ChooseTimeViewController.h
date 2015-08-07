//
//  ChooseTimeViewController.h
//  SBS
//
//  Created by lyn on 15/6/26.
//  Copyright (c) 2015年 Tellyes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExamDevicesTableViewController.h"

@interface ChooseTimeViewController : UITableViewController
@property (nonatomic,retain) NSObject<PassValueDelegate> *delegate;
@property int nIndex;
@end
