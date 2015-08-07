//
//  LoginViewController.h
//  SBS
//
//  Created by li Conner on 14-2-13.
//  Copyright (c) 2014年 Tellyes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "AppDelegate.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate,ZBarReaderDelegate>
@property (weak, nonatomic) IBOutlet UITextField *passwordLable;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UITextField *usernameLable;
@end
