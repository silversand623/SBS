//
//  QuestionTableViewController.h
//  SBS
//
//  Created by lyn on 15/7/2.
//  Copyright (c) 2015年 Tellyes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *labelQuestion;
@property (weak, nonatomic) IBOutlet UILabel *labelAnswer;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSString* questionTitle;
@property (nonatomic,strong)NSArray* questionContent;
@property(nonatomic,strong)NSString* questionAnswer;
@property(nonatomic,strong)NSString* questionExlain;
@property (weak, nonatomic) IBOutlet UILabel *currentPage;
@property (weak, nonatomic) IBOutlet UILabel *totalPage;
@property (nonatomic, strong) NSString *sIndex;
@property (nonatomic, strong) NSString *sTotal;
@property (nonatomic,strong)NSArray* optionArray;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *txtTip;
- (IBAction)confirmAnswer:(UIButton *)sender;

@end
