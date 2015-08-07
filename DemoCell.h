//
//  DemoCell.h
//  Demo
//
//  Created by honcheng on 5/2/13.
//  Copyright (c) 2013 Hon Cheng Muh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCPaperFoldGalleryCellView.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+LK.h"

@protocol UIDemoCellDelegate <NSObject>
@optional
- (void)imageClicked:(int)pageIndex;
@end

@interface DemoCell : HCPaperFoldGalleryCellView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *skillText;
@property (nonatomic, strong) NSString* imagePath;
@property (nonatomic, assign) id <UIDemoCellDelegate> delegate;
@property (nonatomic, assign) int pageNumber;
@property (nonatomic, strong)NSString* questionTitle;
@property (nonatomic,strong)NSArray* questionContent;
@property(nonatomic,strong)NSString* questionAnswer;
@property(nonatomic,strong)NSString* questionExlain;
@end
