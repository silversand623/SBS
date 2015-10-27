//
//  QuestionTableViewController.m
//  SBS
//
//  Created by lyn on 15/7/2.
//  Copyright (c) 2015年 Tellyes. All rights reserved.
//

#import "QuestionTableViewController.h"
#import "SVProgressHUD.h"
#import "UIColor+WTRequestCenter.h"
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#define iOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)

@interface QuestionTableViewController ()
@property(strong,nonatomic)NSIndexPath *lastIndexPath;
@end

@implementation QuestionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentPage.text = self.sIndex;
    self.totalPage.text = self.sTotal;
    
    _optionArray = [[NSArray alloc] initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",nil];
    
    self.labelAnswer.text = self.questionExlain;
    
    //CGSize size = [self.labelAnswer sizeThatFits:CGSizeMake(self.labelAnswer.frame.size.width, MAXFLOAT)];
    CGFloat fHeight = [self getLabelHeight:self.questionExlain];
    
    self.labelAnswer.frame = CGRectMake(self.labelAnswer.frame.origin.x, self.labelAnswer.frame.origin.y, self.labelAnswer.frame.size.width, fHeight);
    [self.labelAnswer setHidden:YES];
    
    
    if (self.questionContent != nil) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.questionContent.count-1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    //self.labelQuestion.text = [NSString stringWithFormat:@"%@ ( )", self.questionTitle];
    _strQuestion = [NSString stringWithFormat:@"%@ ( )", self.questionTitle];
    
    // 设置UIScrollView的滚动范围（内容大小）
    _scrollView.contentSize = CGSizeMake(320, 480);
    // 隐藏水平滚动条
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = YES;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.questionContent != nil) {
        return self.questionContent.count+1;
        //return self.questionContent.count;
    } else
    {
        return 0;
    }
}

- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    //根据 NSIndexPath判定行是否可选。
    
    if (path.row != 0)
    {
        return path;
    }
    
    return nil;
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
    int nCount = -1;
    
    if (self.questionContent != nil) {
        nCount = indexPath.row;
        if (nCount == 0) {
            
            cell.textLabel.text = _strQuestion;
            cell.textLabel.numberOfLines=0;
            
        } else
        {
            NSString* item = [self.questionContent objectAtIndex:nCount-1];
            if (![item isEqualToString:@""]) {
                cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@. %@",self.optionArray[nCount-1],item];
                cell.textLabel.numberOfLines=0;
            }
        }
        //resize the height of label
        CGRect rect = cell.textLabel.frame;
        rect.size.height = [self getLabelHeight:cell.textLabel.text]+10;
        if (iOS8)
        {
            [cell.textLabel setFrame:CGRectMake(20, 0, rect.size.width, rect.size.height)];
        } else if (iOS7) {
            [cell.textLabel setFrame:rect];
        }
    }
    
    // 重用机制，如果选中的行正好要重用
    int oldRow = (_lastIndexPath != nil) ? [_lastIndexPath row] : -1;
    if (oldRow == indexPath.row) {
        cell.backgroundColor = [UIColor WTcolorWithHexString:@"#ced8e3"];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    int newRow = [indexPath row];
    int oldRow = (_lastIndexPath != nil) ? [_lastIndexPath row] : -1;
    if(newRow != oldRow)
    {
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.backgroundColor = [UIColor WTcolorWithHexString:@"#ced8e3"];
        
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:_lastIndexPath];
        oldCell.backgroundColor = [UIColor whiteColor];
        _lastIndexPath = indexPath;
    }
    NSString *sItem = self.optionArray[newRow-1];
    _strQuestion = [NSString stringWithFormat:@"%@ (%@)", self.questionTitle,sItem];
    
    NSIndexPath *path =  [NSIndexPath indexPathForItem:0 inSection:0];
    UITableViewCell *firstCell = [tableView cellForRowAtIndexPath:path];
    firstCell.textLabel.text = _strQuestion;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //[tableView reloadData];
}

//------------------TableView Cell Height------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.questionContent != nil) {
        if (indexPath.row == 0) {
            
            return [self getLabelHeight:_strQuestion];
        }else
        {
            NSString *content = [self.questionContent objectAtIndex:indexPath.row-1];
            return [self getLabelHeight:content];
        }
    }
    return 55;
}

-(CGFloat)getLabelHeight:(NSString *)sText {
    // 列寬
    CGFloat contentWidth = 280;
    // 用何種字體進行顯示
    UIFont *font = [UIFont systemFontOfSize:18];
    
    // 該行要顯示的內容
    // 計算出顯示完內容需要的最小尺寸
    CGSize size = [sText sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    return MAX(size.height, 45)+10;
}

- (IBAction)confirmAnswer:(UIButton *)sender {
    NSString *msg = nil;
    int oldRow = (_lastIndexPath != nil) ? [_lastIndexPath row] : -1;
    if (oldRow<0) {
        msg = @"请选择一个答案";
        [SVProgressHUD dismiss];
        
        [SVProgressHUD showErrorWithStatus:msg];
        return;
    }
    NSString *sItem = self.optionArray[oldRow-1];
    NSString *sTitle = [NSString stringWithFormat:@"%@ (%@)", self.questionTitle,sItem];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:sTitle];
    
    if ( [sItem isEqualToString:self.questionAnswer])
    {
        msg = @"回答正确!";
        //[SVProgressHUD dismiss];
        
        //[SVProgressHUD showSuccessWithStatus:msg];
        self.txtTip.text = msg;
        self.txtTip.textColor = [UIColor WTcolorWithHexString:@"#22ac38"];
        self.labelAnswer.textColor = [UIColor WTcolorWithHexString:@"#82624a"];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor WTcolorWithHexString:@"#22ac38"] range:NSMakeRange(sTitle.length-2,1)];
    } else
    {
        msg = [NSString stringWithFormat:@"回答错误!  正确答案为%@", self.questionAnswer];
        //[SVProgressHUD dismiss];
        
        //[SVProgressHUD showErrorWithStatus:msg];
        self.txtTip.text = msg;
        self.txtTip.textColor = [UIColor WTcolorWithHexString:@"#e83828"];
        self.labelAnswer.textColor = [UIColor WTcolorWithHexString:@"#82624a"];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor WTcolorWithHexString:@"#e83828"] range:NSMakeRange(sTitle.length-2,1)];
    }
    //self.labelQuestion.attributedText = str;
    NSIndexPath *path =  [NSIndexPath indexPathForItem:0 inSection:0];
    UITableViewCell *firstCell = [self.tableView cellForRowAtIndexPath:path];
    firstCell.textLabel.attributedText = str;
    [self.tableView reloadData];
    
    [self.labelAnswer setHidden:NO];
    CGFloat fHeight = [self getLabelHeight:self.labelAnswer.text];
    CGFloat fWidth = self.labelAnswer.frame.size.width;
    CGRect cgSize = CGRectMake(self.labelAnswer.frame.origin.x,self.labelAnswer.frame.origin.y, fWidth, fHeight);
    [self.labelAnswer setFrame:cgSize];
    
    _scrollView.contentSize = CGSizeMake(fWidth, self.labelAnswer.frame.origin.y+fHeight);
}
@end
