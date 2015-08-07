//
//  OnlyTextTableViewController.m
//  SBS
//
//  Created by lyn on 15/7/1.
//  Copyright (c) 2015年 Tellyes. All rights reserved.
//

#import "OnlyTextTableViewController.h"
#import "UIKit+WTRequestCenter.h"

@interface OnlyTextTableViewController ()

@end


@implementation OnlyTextTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.skillText != nil) {
        return self.skillText.count;
    } else
    {
        return 0;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *TableSampleIdentifier = @"OnlyText";
    
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
        NSLog(@"Device is 5");
    }
    
    searchRange = [deviceType rangeOfString:@"iPhone 6"];
    if (searchRange.location != NSNotFound) {
        nWidth = 375-40;
        NSLog(@"Device is 6");
    }
    
    searchRange = [deviceType rangeOfString:@"iPhone 6 Plus"];
    if (searchRange.location != NSNotFound) {
        nWidth = 414-40;
        NSLog(@"Device is 6 plus");
    }
    
    CGRect detailFrame = [cell.detailTextLabel.attributedText boundingRectWithSize:CGSizeMake(nWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
    
    
    NSString *strText = cell.textLabel.text;
    int nHeight = 0;
    if (strText == nil || [strText isEqualToString:@""]) {
        nHeight = MAX(CGRectIntegral(detailFrame).size.height, 40)+40;
    } else
    {
        CGRect itemFrame = [cell.textLabel.attributedText boundingRectWithSize:CGSizeMake(nWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
        
        nHeight = CGRectIntegral(detailFrame).size.height + CGRectIntegral(itemFrame).size.height+40;
    }
    //NSLog(@"in text text is %@",cell.detailTextLabel.text);
    return nHeight;
}

@end
