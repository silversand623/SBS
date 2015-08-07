//
//  UserInfoViewController.h
//  SBS
//
//  Created by lyn on 15/6/25.
//  Copyright (c) 2015年 Tellyes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *txtPwd;
@property (strong, nonatomic) IBOutlet UITextField *txtRepeatPwd;
@property (weak, nonatomic) IBOutlet UITextField *txtOldPwd;

@end
