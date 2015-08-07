//
//  ChooseTimeViewController.m
//  SBS
//
//  Created by lyn on 15/6/26.
//  Copyright (c) 2015年 Tellyes. All rights reserved.
//

#import "ChooseTimeViewController.h"

@interface ChooseTimeViewController ()
@property(strong,nonatomic)NSIndexPath *lastIndexPath;
@end

@implementation ChooseTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self tableView] setEditing:NO animated:YES];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.nIndex > 0) {
        _lastIndexPath = [NSIndexPath indexPathForItem:self.nIndex-1 inSection:0];
        UITableViewCell *newCell = [self.tableView cellForRowAtIndexPath:_lastIndexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int newRow = [indexPath row];
    int oldRow = (_lastIndexPath != nil) ? [_lastIndexPath row] : -1;
    if(newRow != oldRow)
    {
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:_lastIndexPath];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        _lastIndexPath = indexPath;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *StatusArray = [[NSArray alloc] initWithObjects:@"二分钟",@"五分钟",@"十分钟",nil];
    NSString *strText = [StatusArray objectAtIndex:indexPath.row];
    [self.delegate passValue:strText fromPage:1 id:(indexPath.row+1)];
}

@end
