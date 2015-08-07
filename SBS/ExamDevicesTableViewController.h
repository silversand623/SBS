//
//  ExamDevicesTableViewController.h
//  SBS
//
//  Created by lyn on 15/7/15.
//  Copyright (c) 2015年 Tellyes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StartExamViewController.h"

@protocol PassValueDelegate
- (void)passValue:(NSString *)value fromPage:(int)nPage id:(int)nIndex;
@end

@interface ExamDevicesTableViewController : UITableViewController<PassValueDelegate>
@property (weak, nonatomic) IBOutlet UILabel *deviceName;

@property (weak, nonatomic) IBOutlet UILabel *examTime;

@property int cameraID;

@property int timeID;

@end
