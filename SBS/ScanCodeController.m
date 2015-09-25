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
#import "UIBarButtonItem+DefaultBackButton.h"
#define SIMULATOR 1

@interface ScanCodeController ()

@end

@implementation ScanCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeScan) name:@"closeSwipe" object:nil];
    
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backButtonWith:@"登录"
                                                                      Width:75
                                                                        tintColor:[UIColor whiteColor]
                                                                        target:self
                                                                        andAction:@selector(closeScan)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)scanCode:(UIButton *)sender {
    
#ifdef SIMULATOR
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).modelName = @"TY000100004435M5638762B297E00";
    //((AppDelegate*)[[UIApplication sharedApplication] delegate]).modelName = @"TY000112345678NUI0300051ADC00";
    //全功能急救人140301
    static  NSString *controllerId =@"customTab";
    //2.获取UIStoryboard对象
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SBS" bundle:nil];
    //3.从storyboard取得newViewCtroller对象，通过Identifier区分
    CustonTabViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:controllerId];
    
    [self presentViewController:viewController animated:YES completion:nil];
#endif

#ifndef SIMULATOR
     ZBarReaderViewController *reader = [ZBarReaderViewController new];
     reader.readerDelegate = self;
     ZBarImageScanner *scanner = reader.scanner;
     [scanner setSymbology: ZBAR_I25
     config: ZBAR_CFG_ENABLE
     to: 0];
     [self presentViewController:reader animated:YES completion:nil];
#endif
}

- (void)closeScan
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController: (UIImagePickerController*)reader didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results =  [info objectForKey: ZBarReaderControllerResults];
    
    NSString *name = [[NSString alloc] init];
    for(ZBarSymbol *symbol in results)
    {
        name = symbol.data;
        break;
    }
    [reader dismissViewControllerAnimated:YES completion:^(){
        
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).modelName = name;
        //全功能急救人140301
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SBS" bundle:nil];
        
        [self presentViewController:[storyboard instantiateInitialViewController] animated:YES completion:nil];
    }];
    
}

@end
