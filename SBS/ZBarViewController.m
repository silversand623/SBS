//
//  ZBarViewController.m
//  SBS
//
//  Created by lyn on 14-3-7.
//  Copyright (c) 2014年 Tellyes. All rights reserved.
//

#import "ZBarViewController.h"
#import "StepListViewController.h"

@implementation ZBarViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewDidLoad];
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    [self presentViewController:reader animated:YES completion:Nil];
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
    [reader dismissViewControllerAnimated:YES completion:nil];
    StepListViewController * controller = [[StepListViewController alloc] initWithName:name];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
