//
//  SkillDetailViewController.h
//  SBS
//
//  Created by li Conner on 14-2-13.
//  Copyright (c) 2014年 Tellyes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StepListViewController.h"
#import <MessageUI/MessageUI.h>

@class FSImageViewerViewController;
@interface SkillDetailViewController : UIViewController<ASIHTTPRequestDelegate,MFMailComposeViewControllerDelegate,HCPaperFoldGalleryViewDelegate,HCPaperFoldGalleryViewDatasource>

- (id)initWithName:(NSString*)name;

@property(strong, nonatomic) FSImageViewerViewController *imageViewController;
@property(strong,nonatomic) NSArray * detailList;
@end
