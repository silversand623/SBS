//
//  ProductListViewController.m
//  SBS
//
//  Created by li Conner on 14-2-13.
//  Copyright (c) 2014年 Tellyes. All rights reserved.
//

#import "ProductListViewController.h"
#import "SkillListViewController.h"
#import "SkillListViewController.h"

@interface ProductListViewController ()
@property (nonatomic,strong)NSMutableArray* productList;
@end

@implementation ProductListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.productList = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton * postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [postButton setFrame:CGRectMake(0, 0, 30, 30)];
    [postButton setImage:[UIImage imageNamed:@"4s.png"] forState:UIControlStateNormal];
    [postButton setImage:[UIImage imageNamed:@"4s.png"] forState:UIControlStateHighlighted];
    [postButton setImage:[UIImage imageNamed:@"4s.png"] forState:UIControlStateDisabled];
    [postButton addTarget:self action:@selector(QRButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:postButton];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.productList addObject:@"Tirs1000"];
    [self.productList addObject:@"Tirs2000"];
    [self.productList addObject:@"Tirs3000"];
    [self.productList addObject:@"DXR"];
    [self.productList addObject:@"基础版急救人"];
    [self.productList addObject:@"整体护理"];
    [self.productList addObject:@"全科医师思维诊断系统"];
    [self.productList addObject:@"床旁监护仪"];
    [self.productList addObject:@"模拟听诊器"];
    
    //_productList = [[NSMutableArray alloc]initWithObjects:@"Tirs1000",@"Tirs2000",@"Tirs3000",@"DXR","基础版急救人",@"整体护理",@"全科医师思维诊断系统",@"床旁监护仪",@"模拟听诊器", nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CustomCellIdentifier = @"Cell";
    
//    DetailPicViewController *cell =(DetailPicViewController *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
//    
//    if (cell==nil)
//    {
//        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"DetailPicViewController" owner:self options:nil];
//        cell = [array objectAtIndex:0];
//    }
//    
//    switch (indexPath.row) {
//        case 0:
//            cell.myImage.image = [UIImage imageNamed:@"1s.png"];
//            break;
//        case 1:
//            cell.myImage.image = [UIImage imageNamed:@"2s.png"];
//            break;
//        case 2:
//            cell.myImage.image = [UIImage imageNamed:@"3s.png"];
//            break;
//        default:
//            break;
//    }
//    
//    return (UITableViewCell *)cell;
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SkillListViewController * controller = [[SkillListViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)QRButtonPressed:(id)sender {
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    reader.sourceType = UIImagePickerControllerSourceTypeCamera;
    ZBarImageScanner *scanner = reader.scanner;
    
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    [self presentViewController:reader animated:YES completion:nil];

}

- (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    [reader dismissViewControllerAnimated:YES completion:nil];
    SkillListViewController * controller = [[SkillListViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setTitle:@"产品列表"];
}
@end
