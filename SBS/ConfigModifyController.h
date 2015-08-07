//
//  ConfigModifyController.h
//  SBS
//
//  Created by LiZhe on 14-9-22.
//  Copyright (c) 2014年 Tellyes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface ConfigModifyController : UIViewController<UITextFieldDelegate>
@property(nonatomic,weak) IBOutlet UITextField * UserName;
@property(nonatomic,weak) IBOutlet UITextField * LastPassword;
@property(nonatomic,weak) IBOutlet UITextField * NewPassword;
@property(nonatomic,weak) IBOutlet UITextField * ConfigNewPassword;
@property(nonatomic,weak) IBOutlet UITextField * IPConfig1;
@property(nonatomic,weak) IBOutlet UITextField * IPConfig2;
@property(nonatomic,weak) IBOutlet UITextField * IPConfig3;
@property(nonatomic,weak) IBOutlet UITextField * IPConfig4;
@property(nonatomic,weak) IBOutlet UITextField * PortConfig;
@property(nonatomic,weak) IBOutlet UIScrollView *myScrollView;
@end
