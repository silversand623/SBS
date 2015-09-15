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
#import "ImageVideoCell.h"

@interface Image_TextViewController ()

@end

@implementation Image_TextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentPage.text = self.sIndex;
    self.totalPage.text = self.sTotal;
    
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
                    //MWPhoto *video = [MWPhoto videoWithURL:[NSURL URLWithString:videoUrl]];
                    //[images addObject:video];
                    
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
    browser.autoPlayOnAppear = YES;
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
    
    ImageVideoCell *cell = (ImageVideoCell *)[self.tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.viewDetail.delegate = self;
    
    if (cell == nil) {
        cell = [[ImageVideoCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:TableSampleIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    if (self.skillText != nil) {
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSString *sIP = [defaults objectForKey:@"ipconfig"];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 7.0f;
        paragraphStyle.firstLineHeadIndent = 20.0f;
        
        NSDictionary *ats = @{
                              NSFontAttributeName : [UIFont systemFontOfSize:17],
                              NSParagraphStyleAttributeName : paragraphStyle,
                              };
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@""];
        
        NSUInteger row = [indexPath row];
        NSDictionary * item = [self.skillText objectAtIndex:row];
        
        NSDictionary *atsTitle = @{
                NSFontAttributeName : [UIFont systemFontOfSize:BIGFONT],
                //NSForegroundColorAttributeName : [UIColor blueColor],
                };
        NSString *strTitle = [item objectForKey:@"smallTitle"];
        NSString *strTemp = [NSString stringWithFormat:@"%@\n",strTitle];
        NSAttributedString *attrTemp = [[NSAttributedString alloc] initWithString:strTemp attributes:atsTitle];
        if (strTitle == nil || [strTitle isEqualToString:@""])
        {
            
        } else
        {
            [attrString appendAttributedString:attrTemp];
        }
        
        NSArray* items =[item objectForKey:@"items"];
        for(int i = 0; i< items.count; i++)
        {
            NSString *str = [items objectAtIndex:i];
            NSArray* strs = [str componentsSeparatedByString:@"^"];
            if (strs.count > 1) {
                NSString *videoUrl = [strs objectAtIndex:1];
                NSArray *strVideo = [videoUrl componentsSeparatedByString:@"￥"];
                videoUrl = [NSString stringWithFormat:@"http://%@%@", sIP ,[strVideo objectAtIndex:0]];
                NSTextAttachment *attachment=[[NSTextAttachment alloc] initWithData:nil ofType:nil];
                UIImage *img=[UIImage imageNamed:@"video.png"];
                attachment.image=img;
                attachment.bounds=CGRectMake(0, 0, 30, 30);
                attachment.accessibilityHint = videoUrl;//save video address
                NSAttributedString *text=[NSAttributedString attributedStringWithAttachment:attachment];
                [attrString appendAttributedString:text];
                strTemp = [NSString stringWithFormat:@"\n"];
                attrTemp = [[NSAttributedString alloc] initWithString:strTemp attributes:ats];
                [attrString appendAttributedString:attrTemp];
            }
            strTemp = [NSString stringWithFormat:@"%@\n",[strs objectAtIndex:0]];
            attrTemp = [[NSAttributedString alloc] initWithString:strTemp attributes:ats];
            [attrString appendAttributedString:attrTemp];
        }
        
        cell.viewDetail.attributedText = attrString;
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImageVideoCell *cell = (ImageVideoCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    int nWidth = 320-40;
    
    nWidth = [[UIScreen mainScreen] bounds].size.width -40;
    
    CGRect bounds = cell.viewDetail.bounds;
    // 计算 text view 的高度
    CGSize maxSize = CGSizeMake(bounds.size.width, CGFLOAT_MAX);
    CGSize newSize = [cell.viewDetail sizeThatFits:maxSize];
    bounds.size = newSize;
    cell.viewDetail.bounds = bounds;
    
    int nHeight = 0;
    nHeight = MAX(newSize.height, 40)+10;

    return nHeight;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange
{
    NSLog(@"%@", textAttachment.accessibilityHint);
    NSMutableArray* images = [[NSMutableArray alloc]init];
    MWPhoto *video = [MWPhoto videoWithURL:[NSURL URLWithString:textAttachment.accessibilityHint]];
    [images addObject:video];
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
    //[browser setCurrentPhotoIndex:0];
    
    //[self.navigationController setHidesBarsOnTap:NO];
    [self.navigationController pushViewController:browser animated:YES];
    return NO;
}


@end
