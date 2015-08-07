//
//  ViewController.h
//  StoryboardTutorial-UITableViews1
//
//  Created by xxd on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "SkillIntroViewController.h"
#import "ZBarSDK.h"

@interface SkillViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,ZBarReaderDelegate> {

}
@property(nonatomic,retain) NSMutableDictionary *states;
@property(nonatomic,retain) NSArray *datasource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
