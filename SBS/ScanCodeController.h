//
//  ScanCodeController.h
//  SBS
//
//  Created by lyn on 15/9/16.
//  Copyright (c) 2015年 Tellyes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface ScanCodeController : UIViewController<ZBarReaderDelegate>

- (IBAction)scanCode:(UIButton *)sender;
@end
