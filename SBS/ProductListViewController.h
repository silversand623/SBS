//
//  ProductListViewController.h
//  SBS
//
//  Created by li Conner on 14-2-13.
//  Copyright (c) 2014年 Tellyes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
@interface ProductListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ZBarReaderDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end
