//
//  TrafficOptimizationViewController.h
//  FlashApp
//
//  Created by lidiansen on 12-12-20.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGLabel.h"
#import "TwitterClient.h"
#import "LoadingView.h"
@class ShareWeiBoViewController;
@interface TrafficOptimizationViewController : UIViewController<UITabBarControllerDelegate,UITableViewDataSource,UIActionSheetDelegate>
{
    TwitterClient* twitterClient;
    long long jieshengCount;
    LoadingView* loadingView;
    long long appFlowCount;

}
@property(nonatomic,retain)UIViewController*controller;
@property(nonatomic,retain)NSMutableArray*cellArray;

@property(nonatomic,retain)IBOutlet CGLabel *messageLabel;

@property(nonatomic,retain)IBOutlet UIButton *relfleshBtn;
@property(nonatomic,retain)ShareWeiBoViewController*shareWeiBoViewController;
@property(nonatomic,retain)IBOutlet UIButton *youhuaBtn;
@property(nonatomic,retain)IBOutlet UIButton *shareBtn;
@property(nonatomic,retain)IBOutlet UITableView *myTableView;
@property(nonatomic,retain)NSMutableArray *dataArray;
-(IBAction)turnBack:(id)sender;
-(IBAction)youhuaBtnPress:(id)sender;
-(IBAction)shareBtnPress:(id)sender;
-(IBAction )relfleshBtnPress:(id )sender;
@end
