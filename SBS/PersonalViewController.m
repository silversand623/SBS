//
//  PersonalViewController.m
//  SBS
//
//  Created by lyn on 15/7/6.
//  Copyright (c) 2015年 Tellyes. All rights reserved.
//

#import "PersonalViewController.h"

@interface PersonalViewController ()

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)exitToLogin:(id)sender {
    
    
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeSwipe" object:nil];
}

@end
