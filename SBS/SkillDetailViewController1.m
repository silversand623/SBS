//
//  SkillDetailViewController.m
//  SBS
//
//  Created by li Conner on 14-2-13.
//  Copyright (c) 2014年 Tellyes. All rights reserved.
//

#import "SkillDetailViewController.h"
#import "IntroControll.h"
#import "FSBasicImage.h"
#import "FSBasicImageSource.h"
#import "DRPaginatedScrollView.h"
#import <Masonry.h>

@interface SkillDetailViewController ()
@property (nonatomic)BOOL isBack;
@property(strong,nonatomic)NSString* productName;
@property (strong, nonatomic) DRPaginatedScrollView * paginatedScrollView;
@property(strong,nonatomic)HCPaperFoldGalleryView * galleryView;
@property(strong,nonatomic)UIBarButtonItem *previousItem;
@property(strong,nonatomic)UIBarButtonItem *nextItem;
@property(strong,nonatomic)NSString* name;
@end

@implementation SkillDetailViewController

- (id)initWithName:(NSString*)name {
    if (self = [super init])
    {
        //self.paginatedScrollView = [DRPaginatedScrollView new];
        HCPaperFoldGalleryView *galleryView = [[HCPaperFoldGalleryView alloc] initWithFrame:CGRectMake(0, 0, [self.view bounds].size.width, [self.view bounds].size.height) folds:5];
        [galleryView setDelegate:self];
        [galleryView setDatasource:self];
        [galleryView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        [self.view addSubview:galleryView];
        self.galleryView = galleryView;
        //self.galleryView.frame = CGRectMake(0, 44, 320, 436);
        //self.galleryView.frame = self.view.frame;
        [self.galleryView reloadData];
        self.name = name;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}


- (void)imageClicked:(int)pageIndex
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *sIP = [defaults objectForKey:@"ipconfig"];
    
    NSMutableArray* images = [[NSMutableArray alloc]init];
    NSDictionary* dic = [self.detailList objectAtIndex:pageIndex];
    NSString* imagePath = [dic objectForKey:@"ImagePaths"];
    NSArray* imagePath1 = [imagePath componentsSeparatedByString:@","];
    for (NSString* imagestring in imagePath1) {
        NSArray* imagePath2 = [imagestring componentsSeparatedByString:@"^"];
        NSString *imgUrl = [NSString stringWithFormat:@"http://%@%@", sIP ,[imagePath2 objectAtIndex:1]];
        FSBasicImage *photo = [[FSBasicImage alloc] initWithImageURL:[NSURL URLWithString: imgUrl] name:[imagePath2 objectAtIndex:2]];
        [images addObject:photo];
    }
    
    FSBasicImageSource *photoSource = [[FSBasicImageSource alloc] initWithImages:images];
    self.imageViewController = [[FSImageViewerViewController alloc] initWithImageSource:photoSource];
    self.imageViewController.sharingDisabled = YES;
    [self.navigationController pushViewController:_imageViewController animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    //[self.navigationController setNavigationBarHidden:NO];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    //[self.navigationController setNavigationBarHidden:YES];
}


- (void)leaveFeedback {
    MFMailComposeViewController * mailComposeViewController = [MFMailComposeViewController new];
    [mailComposeViewController setMailComposeDelegate:self];
    [mailComposeViewController setSubject:@"About DRPaginatedScrollView."];
    [mailComposeViewController setToRecipients:@[@"David Román <dromaguirre@gmail.com>"]];
    [self presentViewController:mailComposeViewController animated:YES completion:nil];
}
- (void)setupView {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //    [self.view addSubview:self.navigationBar];
    [self.view insertSubview:self.paginatedScrollView belowSubview:self.navigationController.navigationBar];
}

- (void)setupConstraints {
    //    [self.navigationController.navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(@0);
    //        make.left.equalTo(@0);
    //        make.right.equalTo(@0);
    //        make.height.equalTo(@64);
    //    }];
    
    //    [self.paginatedScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(@-500);
    //        make.left.equalTo(@0);
    //        make.right.equalTo(@0);
    //        make.bottom.equalTo(@0);
    //    }];
    self.paginatedScrollView.frame = self.view.frame;
    NSLog(NSStringFromCGRect(self.paginatedScrollView.frame));
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"ok");
}

#pragma mark PaperFoldGallery delegate

- (HCPaperFoldGalleryCellView*)paperFoldGalleryView:(HCPaperFoldGalleryView*)galleryView viewAtPageNumber:(int)pageNumber
{
    static NSString *identifier = @"identifier";
    __weak SkillDetailViewController * weakSelf = self;
    DemoCell *cell = (DemoCell*)[self.galleryView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[DemoCell alloc] initWithIdentifier:identifier];
        cell.delegate = weakSelf;
    }
    
    //[self SetNavigationItemStatus];
    
    if (pageNumber>=self.detailList.count) {
        return cell;
    }
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *sIP = [defaults objectForKey:@"ipconfig"];
    
    NSDictionary* dic = [weakSelf.detailList objectAtIndex:pageNumber];
    cell.skillText = [dic objectForKey:@"TextContext"];
    
    NSString* imagePath = [dic objectForKey:@"ImagePaths"];
    if ([imagePath isEqualToString:@""])
    {
        cell.imagePath = @"";
    }
    else
    {
        NSArray* imagePath1 = [imagePath componentsSeparatedByString:@","];
        if (imagePath1.count==0) {
            NSLog(@"OK");
        }
        NSString * string1 = [imagePath1 objectAtIndex:0];
        NSArray* imagePath2 = [string1 componentsSeparatedByString:@"^"];
        if (imagePath2.count==0) {
            NSLog(@"OK");
        }
        
        NSString* imageUrl = [imagePath2 objectAtIndex:1];
        
        cell.imagePath = [NSString stringWithFormat:@"http://%@%@", sIP ,imageUrl];
    }
    cell.questionTitle = [dic objectForKey:@"P_questionTittle"];
    cell.questionAnswer = [dic objectForKey:@"P_questionAnser"];
    cell.questionContent = [dic objectForKey:@"P_questionOptions"];
    
    NSString * exlain= [dic objectForKey:@"P_quesstionExlain"];
    cell.questionExlain = exlain;
    
    
    return cell;
}

#pragma mark PaperFoldGallery datasource

- (NSInteger)numbeOfItemsInPaperFoldGalleryView:(HCPaperFoldGalleryView*)galleryView
{
    __weak SkillDetailViewController * weakSelf = self;
    return weakSelf.detailList.count;
}
@end
