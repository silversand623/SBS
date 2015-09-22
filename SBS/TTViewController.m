//
//  TTViewController.m
//  UIScrollViewSlidingPages
//
//  Created by Thomas Thorpe on 27/03/2013.
//  Copyright (c) 2013 Thomas Thorpe. All rights reserved.
//

#import "TTViewController.h"
#import "TTScrollSlidingPagesController.h"
#import "TTSlidingPage.h"
#import "TTSlidingPageTitle.h"
#import "LoginViewController.h"
#import "OnlyTextTableViewController.h"
#import "Image+TextViewController.h"
#import "QuestionTableViewController.h"
#import "WTNetWork.h"
#import "UIKit+WTRequestCenter.h"
#import "SVProgressHUD.h"

@interface TTViewController ()
    @property (strong, nonatomic) TTScrollSlidingPagesController *slider;
@end

@implementation TTViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //initial setup of the TTScrollSlidingPagesController. 
    self.slider = [[TTScrollSlidingPagesController alloc] init];
    self.slider.titleScrollerInActiveTextColour = [UIColor grayColor];
    self.slider.titleScrollerBottomEdgeColour = [UIColor darkGrayColor];
    self.slider.titleScrollerBottomEdgeHeight = 2;
    self.slider.titleScrollerHeight = 40;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7){
        self.slider.hideStatusBarWhenScrolling = NO;//this property normally only makes sense on iOS7+. See the documentation in TTScrollSlidingPagesController.h. If you wanted to use it in iOS6 you'd have to make sure the status bar overlapped the TTScrollSlidingPagesController.
    }
    
    //set the datasource.
    self.slider.dataSource = self;
    self.slider.delegate = self;
    
    //add the slider's view to this view as a subview, and add the viewcontroller to this viewcontrollers child collection (so that it gets retained and stays in memory! And gets all relevant events in the view controller lifecycle)
    self.slider.view.frame = self.view.frame;
    [self.view addSubview:self.slider.view];
    [self addChildViewController:self.slider];
    
    

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TTSlidingPagesDataSource methods
-(int)numberOfPagesForSlidingPagesViewController:(TTScrollSlidingPagesController *)source{
    return self.detailList.count;
}

-(TTSlidingPage *)pageForSlidingPagesViewController:(TTScrollSlidingPagesController*)source atIndex:(int)index{
    
    NSDictionary* dic = [self.detailList objectAtIndex:index];
    NSString *sPageType = [[dic objectForKey:@"PageType"] substringToIndex:1];
    int nCase = [sPageType intValue];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *BaseUrl=[defaults objectForKey:@"ipconfig"];
    TTSlidingPage *slidePage=nil;
    switch (nCase) {
        case 1:
        case 3:
            {
                //1.storyboard中定义某个独立newViewController（无segue跳转关系）的 identifier
                static  NSString *controllerId =@"OnlyText";
                //2.获取UIStoryboard对象
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SBS" bundle:nil];
                //3.从storyboard取得newViewCtroller对象，通过Identifier区分
                OnlyTextTableViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:controllerId];
                viewController.skillText = [dic objectForKey:@"TextContext"];
                viewController.sIndex=[NSString stringWithFormat:@"%d",index+1];
                viewController.sTotal = [NSString stringWithFormat:@"/%d",self.detailList.count];
                slidePage = [[TTSlidingPage alloc] initWithContentViewController:viewController];
            }
            break;
        case 2:
        case 5:
        {
            //1.storyboard中定义某个独立newViewController（无segue跳转关系）的 identifier
            static  NSString *controllerId =@"Image_Text";
            //2.获取UIStoryboard对象
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SBS" bundle:nil];
            //3.从storyboard取得newViewCtroller对象，通过Identifier区分
            Image_TextViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:controllerId];
            viewController.skillText = [dic objectForKey:@"TextContext"];
            viewController.sIndex=[NSString stringWithFormat:@"%d",index+1];
            viewController.sTotal = [NSString stringWithFormat:@"/%d",self.detailList.count];
            
            NSString* imagePath = [dic objectForKey:@"ImagePaths"];
            NSString* firstPath = nil;
            if ([imagePath isEqualToString:@""])
            {
                firstPath = @"";
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
                
                firstPath = [NSString stringWithFormat:@"http://%@%@", BaseUrl ,imageUrl];
            }
            
            viewController.firstImgPath = firstPath;
            viewController.imgPath = imagePath;
            
            slidePage = [[TTSlidingPage alloc] initWithContentViewController:viewController];
            
        }
            break;
        case 4:
        {
            //1.storyboard中定义某个独立newViewController（无segue跳转关系）的 identifier
            static  NSString *controllerId =@"Question";
            //2.获取UIStoryboard对象
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SBS" bundle:nil];
            //3.从storyboard取得newViewCtroller对象，通过Identifier区分
            QuestionTableViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:controllerId];
            
            viewController.questionTitle = [dic objectForKey:@"P_questionTittle"];
            viewController.questionAnswer = [dic objectForKey:@"P_questionAnser"];
            viewController.questionContent = [dic objectForKey:@"P_questionOptions"];
            
            viewController.questionExlain = [dic objectForKey:@"P_quesstionExlain"];
            
            viewController.sIndex=[NSString stringWithFormat:@"%d",index+1];
            viewController.sTotal = [NSString stringWithFormat:@"/%d",self.detailList.count];
            
            slidePage = [[TTSlidingPage alloc] initWithContentViewController:viewController];
            
        }
            break;
        default:
        {
            //1.storyboard中定义某个独立newViewController（无segue跳转关系）的 identifier
            static  NSString *controllerId =@"Question";
            //2.获取UIStoryboard对象
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SBS" bundle:nil];
            //3.从storyboard取得newViewCtroller对象，通过Identifier区分
            QuestionTableViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:controllerId];
            
            viewController.questionTitle = [dic objectForKey:@"P_questionTittle"];
            viewController.questionAnswer = [dic objectForKey:@"P_questionAnser"];
            viewController.questionContent = [dic objectForKey:@"P_questionOptions"];
            
            viewController.questionExlain = [dic objectForKey:@"P_quesstionExlain"];
            
            viewController.sIndex=[NSString stringWithFormat:@"%d",index+1];
            viewController.sTotal = [NSString stringWithFormat:@"/%d",self.detailList.count];
            
            slidePage = [[TTSlidingPage alloc] initWithContentViewController:viewController];
            
        }
            break;
    }
    
    
    return slidePage;
}

-(TTSlidingPageTitle *)titleForSlidingPagesViewController:(TTScrollSlidingPagesController *)source atIndex:(int)index{
    TTSlidingPageTitle *title;
    title = [[TTSlidingPageTitle alloc] initWithHeaderText:[NSString stringWithFormat:@"第(%d/%d)页", index+1,self.detailList.count]];
    
    return title;
}


#pragma mark - delegate
-(void)didScrollToViewAtIndex:(NSUInteger)index
{
    if (index == (self.detailList.count-1)) {
        UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishWork)];
        self.navigationItem.rightBarButtonItem = backItem;
    }else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }

}

- (void)finishWork
{
    [self addFinishLog];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (![[self.navigationController viewControllers] containsObject:self])
    {
        //NSLog(@"用户点击了返回按钮");
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}

-(void) addFinishLog
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"ipconfig"]==nil) {
        return;
    }
    NSString* uniID =((AppDelegate*)[[UIApplication sharedApplication] delegate]).Uid;
    
    NSString* logId =((AppDelegate*)[[UIApplication sharedApplication] delegate]).logID;
    
    NSString *BaseUrl=[defaults objectForKey:@"ipconfig"];
    
    NSString *url = [NSString stringWithFormat:@"http://%@/handlers/LogUpdateHandler.ashx?log_id=%@&uniquid=%@",BaseUrl,logId,[uniID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    [WTRequestCenter getWithURL:url parameters:nil option:WTRequestCenterCachePolicyNormal
                       finished:^(NSURLResponse *response, NSData *data) {
                           //[SVProgressHUD dismiss];
                           NSError *jsonError = nil;
                           NSDictionary *userDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                           if (!jsonError) {
                               if ([[userDic objectForKey:@"result"] isEqualToString:@"1"])
                               {
                                   
                                   
                               } else
                               {
                                   //[SVProgressHUD showErrorWithStatus:[userDic objectForKey:@"Reason"]];
                               }
                           } else
                           {
                               //[SVProgressHUD showErrorWithStatus:[jsonError localizedDescription]];
                           }
                           
                           
                       }failed:^(NSURLResponse *response, NSError *error) {
                           //[SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                       }];
    
}

@end
