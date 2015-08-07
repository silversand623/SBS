//
//  CountDownViewController.h
//  SBS
//
//  Created by lyn on 15/7/16.
//  Copyright (c) 2015年 Tellyes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTCounterLabel.h"

@interface CountDownViewController : UIViewController<TTCounterLabelDelegate>
@property (weak, nonatomic) IBOutlet TTCounterLabel *myTimer;
@property int examId;
@property int durationTime;
@property (nonatomic, unsafe_unretained) UIBackgroundTaskIdentifier backgroundTaskIdentifier;
@end
