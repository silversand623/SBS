//
//  CustonTabViewController.m
//  SBS
//
//  Created by lyn on 15/7/22.
//  Copyright (c) 2015年 Tellyes. All rights reserved.
//

#import "CustonTabViewController.h"
#import "UIColor+WTRequestCenter.h"

@interface CustonTabViewController ()

@end

@implementation CustonTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *items = self.tabBar.items;
    UITabBarItem *practiceItem = items[0];
    practiceItem.image = [[UIImage imageNamed:@"practice-1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    practiceItem.selectedImage = [[UIImage imageNamed:@"practice-2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //UITabBarItem *examItem = items[1];
    //examItem.image = [[UIImage imageNamed:@"examine-1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //examItem.selectedImage = [[UIImage imageNamed:@"examine-2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *personalItem = items[1];
    personalItem.image = [[UIImage imageNamed:@"personal-1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    personalItem.selectedImage = [[UIImage imageNamed:@"personal-2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor WTcolorWithHexString:@"#5d7da3"]} forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor WTcolorWithHexString:@"#454545"]} forState:UIControlStateNormal];
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

@end
