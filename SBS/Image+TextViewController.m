//
//  Image+TextViewController.m
//  SBS
//
//  Created by lyn on 15/7/2.
//  Copyright (c) 2015年 Tellyes. All rights reserved.
//

#import "Image+TextViewController.h"
#import "UIImageView+LK.h"
#import "OnlyTextTableViewController.h"
#import "FSBasicImage.h"
#import "FSBasicImageSource.h"
#import "WTNetWork.h"
#import "UIKit+WTRequestCenter.h"
#import "SVProgressHUD.h"

@interface Image_TextViewController ()

@end

@implementation Image_TextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.firstImgPath != nil)
    {
        //[SVProgressHUD showWithStatus:@"正在加载图片" maskType:SVProgressHUDMaskTypeGradient];
        
        [WTRequestCenter getWithURL:self.firstImgPath parameters:nil option:WTRequestCenterCachePolicyCacheElseWeb
                           finished:^(NSURLResponse *response, NSData *data) {
                               //[SVProgressHUD dismiss];
                               UIImage *temp = [UIImage imageWithData:data];
                               if (temp != nil) {
                                   //[SVProgressHUD showSuccessWithStatus:@"图片加载成功"];
                                   self.imageView.image = temp;
                                   self.imageView.onTouchTapBlock = ^(UIImageView * view)
                                   {
                                       [self imageClicked];
                                       
                                   };
                               }else
                               {
                                   //[SVProgressHUD showErrorWithStatus:@"图片加载失败"];
                               }
                               
                           }failed:^(NSURLResponse *response, NSError *error) {
                               //[SVProgressHUD dismiss];
                               //[SVProgressHUD showErrorWithStatus:@"图片加载失败"];
                           }];
    }
    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    //[self.navigationController setHidesBarsOnTap:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

- (void)imageClicked
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *sIP = [defaults objectForKey:@"ipconfig"];
    NSMutableArray* images = [[NSMutableArray alloc]init];
    
    if (self.skillText != nil) {
        for (int j=0; j<self.skillText.count;j++) {
            NSDictionary * item = [self.skillText objectAtIndex:j];
            NSArray* items =[item objectForKey:@"items"];
            for(int i = 0; i< items.count; i++)
            {
                NSString *str = [items objectAtIndex:i];
                NSArray* strs = [str componentsSeparatedByString:@"^"];
                if (strs.count > 1) {
                    NSString *videoUrl = [strs objectAtIndex:1];
                    NSArray *strVideo = [videoUrl componentsSeparatedByString:@"￥"];
                    videoUrl = [NSString stringWithFormat:@"http://%@%@", sIP ,[strVideo objectAtIndex:0]];
                    MWPhoto *video = [MWPhoto videoWithURL:[NSURL URLWithString:videoUrl]];
                    [images addObject:video];
                    
                }
            }
        }
        
    }
    
    NSArray* imagePath1 = [self.imgPath componentsSeparatedByString:@","];
    for (NSString* imagestring in imagePath1) {
        NSArray* imagePath2 = [imagestring componentsSeparatedByString:@"^"];
        NSString *imgUrl = [NSString stringWithFormat:@"http://%@%@", sIP ,[imagePath2 objectAtIndex:1]];
        // Browser
        MWPhoto *photo;
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:imgUrl]];
        photo.caption = [imagePath2 objectAtIndex:2];
        [images addObject:photo];
        
    }
    
    self.photos = images;
    
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    browser.displayNavArrows = NO;
    //browser.displaySelectionButtons = displaySelectionButtons;
    //browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = YES;
    //browser.enableGrid = YES;
    //browser.startOnGrid = YES;
    browser.enableSwipeToDismiss = NO;
    browser.autoPlayOnAppear = NO;
    [browser setCurrentPhotoIndex:0];
    
    //[self.navigationController setHidesBarsOnTap:NO];
    [self.navigationController pushViewController:browser animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.skillText != nil) {
        return self.skillText.count;
    } else
    {
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *TableSampleIdentifier = @"Image_Text";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:TableSampleIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    if (self.skillText != nil) {
        NSUInteger row = [indexPath row];
        NSDictionary * item = [self.skillText objectAtIndex:row];
        NSArray* items =[item objectForKey:@"items"];
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for(int i = 0; i< items.count; i++)
        {
            NSString *str = [items objectAtIndex:i];
            NSArray* strs = [str componentsSeparatedByString:@"^"];
            [arr addObject:[strs objectAtIndex:0]];
        }
        NSString *string = [arr componentsJoinedByString:@"\n"];
        cell.detailTextLabel.text = string;
        cell.detailTextLabel.numberOfLines = 0;
        cell.textLabel.text =[item objectForKey:@"smallTitle"];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 7.0f;
        paragraphStyle.firstLineHeadIndent = 20.0f;
        
        NSDictionary *ats = @{
                              NSFontAttributeName : [UIFont systemFontOfSize:SMALLFONT],
                              NSParagraphStyleAttributeName : paragraphStyle,
                              };
        if (string.length > 30) {
            cell.detailTextLabel.attributedText = [[NSAttributedString alloc] initWithString:string attributes:ats];//textview 设置行间距
        }else
        {
            cell.detailTextLabel.font = [UIFont systemFontOfSize:SMALLFONT];
            cell.detailTextLabel.text = string;
        }
        
        
        ats = @{
                NSFontAttributeName : [UIFont systemFontOfSize:BIGFONT],
                NSForegroundColorAttributeName : [UIColor blueColor],
                };
        
        cell.textLabel.attributedText = [[NSAttributedString alloc] initWithString:cell.textLabel.text attributes:ats];
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    int nWidth = 320-40;
    NSString* deviceType = [UIDevice getDeviceType];
    NSRange searchRange = [deviceType rangeOfString:@"iPhone 5"];
    if (searchRange.location != NSNotFound) {
        nWidth = 320-40;
    }
    
    searchRange = [deviceType rangeOfString:@"iPhone 6"];
    if (searchRange.location != NSNotFound) {
        nWidth = 375-40;
    }
    
    searchRange = [deviceType rangeOfString:@"iPhone 6 Plus"];
    if (searchRange.location != NSNotFound) {
        nWidth = 414-40;
    }
    
    CGRect detailFrame = [cell.detailTextLabel.attributedText boundingRectWithSize:CGSizeMake(nWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
    
    NSString *strText = cell.textLabel.text;
    int nHeight = 0;
    if (strText == nil || [strText isEqualToString:@""]) {
        nHeight = MAX(detailFrame.size.height, 40)+40;
    } else
    {
        CGRect itemFrame = [cell.textLabel.attributedText boundingRectWithSize:CGSizeMake(nWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
        nHeight = detailFrame.size.height + itemFrame.size.height+40;
    }

    return nHeight;
}

@end
