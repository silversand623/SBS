//
//  SkillListViewController.m
//  SBS
//
//  Created by li Conner on 14-2-13.
//  Copyright (c) 2014年 Tellyes. All rights reserved.
//

#import "SkillListViewController.h"
#import "SkillDetailViewController.h"

@interface SkillListViewController ()
@property(nonatomic,strong)NSMutableArray* skillList;
@end

@implementation SkillListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.skillList = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.skillList addObject:@"技能1"];
    [self.skillList addObject:@"技能2"];
    [self.skillList addObject:@"技能3"];
    [self.skillList addObject:@"技能4"];
    [self.skillList addObject:@"技能5"];
    [self.skillList addObject:@"技能6"];
    [self.skillList addObject:@"技能7"];
    [self.skillList addObject:@"技能8"];
    [self.skillList addObject:@"技能9"];
    [self.skillList addObject:@"技能10"];
    [self.skillList addObject:@"技能11"];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.skillList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CustomCellIdentifier = @"Cell";
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CustomCellIdentifier];
    }
    cell.textLabel.text = [self.skillList objectAtIndex:indexPath.row];
    
    return cell;
}
- (IBAction)back:(id)sender {
        [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SkillDetailViewController * controller = [[SkillDetailViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setTitle:@"技能列表"];
}
@end
