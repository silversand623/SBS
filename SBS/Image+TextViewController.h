//
//  Image+TextViewController.h
//  SBS
//
//  Created by lyn on 15/7/2.
//  Copyright (c) 2015年 Tellyes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"

@class FSImageViewerViewController;


@interface Image_TextViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,MWPhotoBrowserDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *skillText;

@property (nonatomic, strong) NSString *imgPath;

@property (nonatomic, strong) NSString *videoPath;

@property (nonatomic, strong) NSString *firstImgPath;

@property(strong, nonatomic) FSImageViewerViewController *imageViewController;

@property (nonatomic, strong) NSMutableArray *photos;

@property (nonatomic, strong) NSMutableArray *thumbs;

@end
