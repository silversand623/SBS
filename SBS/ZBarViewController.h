//
//  ZBarViewController.h
//  SBS
//
//  Created by lyn on 14-3-7.
//  Copyright (c) 2014年 Tellyes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface ZBarViewController : UIViewController<ZBarReaderDelegate>
@property (strong, nonatomic) IBOutlet UIView* view;
@property(strong,nonatomic)IBOutlet UIButton *scanButton;
@end
