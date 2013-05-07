//
//  DatastatsDetailViewController.h
//  FlashApp
//
//  Created by lidiansen on 12-12-18.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatsDetail.h"
#import "TwitterClient.h"
#import "UserAgentLock.h"
#import "CGLabel.h"
#import "LoadingView.h"
#import "DetailStatsAppLineChart.h"
#import "StageStats.h"
@class ShareWeiBoViewController;
@interface DatastatsDetailViewController : UIViewController<UIActionSheetDelegate>
{
    TwitterClient* client;
    LoadingView* loadingView;
    DetailStatsAppLineChart* chart;
    
    time_t prevMonthTimes[2];
    time_t nextMonthTimes[2];

}
@property (nonatomic, assign) long startTime;
@property (nonatomic, assign) long endTime;
@property(nonatomic,retain)StageStats* currentStats;
@property(nonatomic,retain)StatsDetail *statsDetail;
@property (nonatomic, retain) UIViewController* dataListController;

@property(nonatomic,retain)IBOutlet UIImageView*kuangImageView;
@property(nonatomic,retain)IBOutlet UIView*bgView;
@property(nonatomic,retain)IBOutlet UIImageView*bgImageView;
@property(nonatomic,retain)IBOutlet UILabel*chartUnitLabel;
@property(nonatomic,retain)IBOutlet UIView*renderLine;


@property (nonatomic, retain) UserAgentLock* agentLock;

@property(nonatomic,retain)IBOutlet UIImageView *wangGeImageView;

@property(nonatomic,retain)IBOutlet UIButton *shareBtn;
@property(nonatomic,retain)IBOutlet UIButton*lockOrUnlockBtn;

@property(nonatomic,retain)IBOutlet UIButton *turnBtn;
@property(nonatomic,retain)IBOutlet CGLabel *titleLabel;
@property(nonatomic,retain)IBOutlet CGLabel*MessageLabel;
@property(nonatomic,retain)IBOutlet UILabel*countLabel;
@property(nonatomic,retain)IBOutlet UILabel*unitLabel;
@property(nonatomic,retain)IBOutlet CGLabel*jieshengLabel;
@property(nonatomic,retain)IBOutlet UILabel *youLikeLabel;

@property (retain, nonatomic) IBOutlet UIView *suoWangView;

//@property(nonatomic,retain)IBOutlet UILabel *label1;
//@property(nonatomic,retain)IBOutlet UILabel *label2;
//@property(nonatomic,retain)IBOutlet UILabel *label3;
//@property(nonatomic,retain)IBOutlet UILabel *label4;
//
//@property(nonatomic,retain)IBOutlet UIButton*button1;
//@property(nonatomic,retain)IBOutlet UIButton*button2;
//@property(nonatomic,retain)IBOutlet UIButton*button3;
//@property(nonatomic,retain)IBOutlet UIButton*button4;
@property(nonatomic,retain)ShareWeiBoViewController*shareWeiBoViewController;
-(IBAction)turnBtn:(id)sender;
-(IBAction)shareBtnPress:(id)sender;
-(IBAction)lockOrUnlockBtnPress:(id)sender;
@end
