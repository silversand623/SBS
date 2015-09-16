//
//  ScanCodeController.m
//  SBS
//
//  Created by lyn on 15/9/16.
//  Copyright (c) 2015年 Tellyes. All rights reserved.
//

#import "ScanCodeController.h"
#import "AppDelegate.h"
#import "CustonTabViewController.h"

@interface ScanCodeController ()

@end

@implementation ScanCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeScan) name:@"closeSwipe" object:nil];
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


- (IBAction)scanCode:(UIButton *)sender {
    
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).modelName = @"TY000112345678NUI0300051ADC00";
    //全功能急救人140301
    static  NSString *controllerId =@"customTab";
    //2.获取UIStoryboard对象
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SBS" bundle:nil];
    //3.从storyboard取得newViewCtroller对象，通过Identifier区分
    CustonTabViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:controllerId];
    
    [self presentViewController:viewController animated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:NO];
     
    //[self dismissViewControllerAnimated:NO completion:nil];
}

- (void)closeScan
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
