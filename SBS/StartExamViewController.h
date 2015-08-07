//
//  StartExamViewController.h
//  SBS
//
//  Created by lyn on 15/7/16.
//  Copyright (c) 2015年 Tellyes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartExamViewController : UIViewController

@property int cameraID;

@property int timeID;

@property (weak, nonatomic) IBOutlet UIButton *startBtn;

- (IBAction)startExam:(UIButton *)sender;
@end
