//
//  DemoCell.m
//  Demo
//
//  Created by honcheng on 5/2/13.
//  Copyright (c) 2013 Hon Cheng Muh. All rights reserved.
//

#import "DemoCell.h"
#import "WTNetWork.h"
#import "UIKit+WTRequestCenter.h"
#import "UIImageView+WTRequestCenter.h"

@interface DemoCell ()
@property(nonatomic,retain)UITableView * tableView;
@property(nonatomic,strong)UIImageView * imageView;

@property(nonatomic,strong)UILabel* questionTitleLable;
@property(nonatomic,strong)UITableView* questionContentTable;
@property(nonatomic,strong)UILabel* answerLable;
@property(nonatomic,strong)UILabel* questionExplainLable;
@end

@implementation DemoCell

- (id)init
{
    self = [super init];
    if (self) {

        self.questionContent = [[NSArray alloc]init];
        self.userInteractionEnabled = YES;
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 300, 320, 296)];
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.dataSource =self;
        self.tableView.delegate = self;
        self.tableView.tag = 1;
        [self addSubview:self.tableView];
        
        self.questionTitleLable = [[UILabel alloc]init];

        self.questionTitleLable.frame = CGRectMake(0, 0, 320, 100);
        self.questionTitleLable.numberOfLines = 3;
        [self addSubview:self.questionTitleLable];
        
        self.questionContentTable = [[UITableView alloc]initWithFrame:CGRectMake(0, self.questionTitleLable.frame.origin.y + self.questionTitleLable.frame.size.height, 320, 200)];
        
        self.questionContentTable.tag = 2;
        self.questionContentTable.backgroundColor = [UIColor whiteColor];
        self.questionContentTable.dataSource =self;
        self.questionContentTable.delegate = self;
        [self addSubview:self.questionContentTable];
        
        self.questionExplainLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 300, 320, 150)];
        self.questionExplainLable.numberOfLines  = 5;
        [self addSubview:self.questionExplainLable];
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.imageView.userInteractionEnabled = YES;
        __weak DemoCell * weakSelf = self;
        self.imageView.onTouchTapBlock = ^(UIImageView * view)
        {
            
            if (weakSelf.delegate!=nil) {
                [weakSelf.delegate imageClicked:weakSelf.pageNumber];
            }
        };
        
        [self addSubview:self.imageView];
    }
    return self;
}


- (id)initWithIdentifier:(NSString *)identifier
{
    self = [super initWithIdentifier:identifier];
    if (self)
    {
        
        self.questionContent = [[NSArray alloc]init];
        self.userInteractionEnabled = YES;
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 300, 320, 296)];
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.dataSource =self;
        self.tableView.delegate = self;
        self.tableView.tag = 1;
        [self addSubview:self.tableView];
        
        self.questionTitleLable = [[UILabel alloc]init];
        
        self.questionTitleLable.frame = CGRectMake(0, 0, 320, 100);
        self.questionTitleLable.numberOfLines = 3;
        [self addSubview:self.questionTitleLable];
        
        self.questionContentTable = [[UITableView alloc]initWithFrame:CGRectMake(0, self.questionTitleLable.frame.origin.y + self.questionTitleLable.frame.size.height, 320, 200)];
        
        self.questionContentTable.tag = 2;
        self.questionContentTable.backgroundColor = [UIColor whiteColor];
        self.questionContentTable.dataSource =self;
        self.questionContentTable.delegate = self;
        [self addSubview:self.questionContentTable];
        
        self.questionExplainLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 300, 320, 150)];
        self.questionExplainLable.numberOfLines  = 5;
        [self addSubview:self.questionExplainLable];
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.imageView.userInteractionEnabled = YES;
        __weak DemoCell * weakSelf = self;
        self.imageView.onTouchTapBlock = ^(UIImageView * view)
        {
            
            if (weakSelf.delegate!=nil)
            {
                [weakSelf.delegate imageClicked:weakSelf.pageNumber];
            }
        };
        
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (![self.questionTitle isEqualToString:@""]) {
        self.questionContentTable.hidden = NO;
        self.questionExplainLable.hidden = NO;
        self.questionTitleLable.hidden = NO;
        self.answerLable.hidden = NO;
        if (Nil != self.questionTitle) {
            self.questionTitleLable.text = [[NSString alloc] initWithFormat:@"%@ \r\n %@",@" 选择题：",self.questionTitle ];
        }
        
        [self.questionContentTable reloadData];
    }
    else if ([self.imagePath isEqualToString:@""])
    {
        [self.tableView setFrame:CGRectMake(0, 0, 320, 640)];
        [self.imageView setFrame:CGRectMake(0, 0, 0, 0)];
        self.questionContentTable.hidden = YES;
        self.questionExplainLable.hidden = YES;
        self.questionTitleLable.hidden = YES;
        self.answerLable.hidden = YES;
    }
    else
    {
        [self.tableView setFrame:CGRectMake(0, 184, 320, 296)];
        [self.imageView setFrame:CGRectMake(0, 0, 320, 184)];
        self.questionContentTable.hidden = YES;
        self.questionExplainLable.hidden = YES;
        self.questionTitleLable.hidden = YES;
        self.answerLable.hidden = YES;
    }
    __weak UIImageView *weakImageView = self.imageView;
    
    /*//weakImageView.imageURL = self.imagePath;
    [weakImageView setImageWithURL:self.imagePath placeholderImage:nil finished:^(NSURLResponse *response, NSData *data) {
        
    } failed:^(NSURLResponse *response, NSError *error) {
        
    }];*/
    if (self.imagePath != nil)
    {
    [WTRequestCenter getWithURL:self.imagePath parameters:nil option:WTRequestCenterCachePolicyCacheElseWeb
                       finished:^(NSURLResponse *response, NSData *data) {
                           UIImage *temp = [UIImage imageWithData:data];
                           if (temp != nil) {
                               weakImageView.image = temp;
                           }
                           
                       }failed:^(NSURLResponse *response, NSError *error) {
                           NSLog(@"xx");
                       }];
    }
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 2)
    {
        return self.questionContent.count;
    }
    else
    {
        return self.skillText.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 2)
    {
        static NSString *TableSampleIdentifier = @"questionCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 TableSampleIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:TableSampleIdentifier];
        }
        cell.textLabel.numberOfLines = 10;
        NSString* item = [self.questionContent objectAtIndex:indexPath.row];
        NSString* num = [[NSString alloc] init];
        switch (indexPath.row) {
            case 0:
                num = @"A";
                break;
            case 1:
                num = @"B";
                break;
            case 2:
                num = @"C";
                break;
            case 3:
                num = @"D";
                break;
            case 4:
                num = @"E";
                break;
            case 5:
                num = @"F";
                break;
            case 6:
                num = @"G";
                break;
            default:
                break;
        }
        cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@.%@",num,item];
        return cell;
    }
    else
    {
        static NSString *TableSampleIdentifier = @"Cell";
        
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:
                                 TableSampleIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleSubtitle
                    reuseIdentifier:TableSampleIdentifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        
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
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 2) {
        NSString *content = [self.questionContent objectAtIndex:indexPath.row];
        if (content.length == 0 || content == nil) {
            return 0;
        }
        NSLog(@"<===== %@",content);
//        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:content];
//        NSRange range = NSMakeRange(0, attStr.length);
//        NSDictionary *dic = [attStr attributesAtIndex:0 effectiveRange:&range];
//        CGSize size =[tableView cellForRowAtIndexPath:indexPath].bounds.size;
//        CGSize textSize = [content boundingRectWithSize:size   options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:dic context:Nil].size;
//        CGFloat height = textSize.height;
//        NSLog(@"%@ %d %f",content,indexPath.row,height);
        
//        CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(tableView.frame.size.width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
//        NSLog(@"%f",size.height);
//        return size.height;
        return ((content.length / 14) + 1) * 30;
//        return 155;
    }
    else
    {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        NSString* aString =cell.detailTextLabel.text;
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
        CGSize titleSize = [aString boundingRectWithSize:[[UIScreen mainScreen] bounds].size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        int n= titleSize.height;
        return 200+n;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 2) {
        self.questionExplainLable.text = self.questionExlain;
        self.questionExplainLable.hidden = NO;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"ok");
}

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view {
    NSLog(@"用户触摸了scroll上的视图%@，是否开始滚动scroll", view);
    //返回yes - 将触摸事件传递给相应的subView; 返回no - 直接滚动scrollView，不传递触摸事件到subView
    return YES;// NO;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, [UIColor colorWithWhite:0.894 alpha:1.000].CGColor);
    CGContextFillRect(contextRef, CGRectMake(rect.size.width-1, 0, 1, rect.size.height));
}

@end
