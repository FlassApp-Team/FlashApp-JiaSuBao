//
//  DatastatsViewController.h
//  FlashApp
//
//  Created by lidiansen on 12-12-18.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//
#import "TwitPicClient.h"
#import "TwitterClient.h"
#import <UIKit/UIKit.h>
#import "StageStats.h"
#import "TwitterClient.h"
#import "CGLabel.h"
@class MonthSliderViewController;
@class ShareWeiBoViewController;
@class DataListViewController;
@interface DatastatsViewController : UIViewController<UIScrollViewDelegate>
{
    TwitterClient* twitterClient;
    int currentPage;
}



@property (nonatomic, retain) StageStats* currentStats;
@property (nonatomic, retain) StageStats* prevMonthStats;
@property (nonatomic, retain) StageStats* nextMonthStats;
@property (nonatomic, assign) long startTime;
@property (nonatomic, assign) long endTime;

//设置分享的时候提示第一个应用压缩了多少流量，因为节省流量有排序，所以要从节省流量页面把 节省最高的拿到，用于分享
@property (nonatomic ,retain) NSMutableArray *shareArray;


@property(nonatomic,retain)NSMutableArray *controllerArray;//存储列表
@property(nonatomic,retain)NSMutableArray *dataArray;//存储有多少列表数据

@property(nonatomic,retain)IBOutlet UIScrollView *scrollView;

@property(nonatomic,retain)IBOutlet UIButton *turnBtn;
@property(nonatomic,retain)IBOutlet UIButton *refleshBtn;
@property(nonatomic,retain)IBOutlet  CGLabel *savaLabel;
@property(nonatomic,retain)IBOutlet  CGLabel *jiasuLabel;
@property(nonatomic,assign)IBOutlet UIImageView *saveTriangle;
@property(nonatomic,assign)IBOutlet UIImageView *savePoint;

@property(nonatomic,retain)IBOutlet UIButton *shareBtn;
@property (nonatomic, retain) NSMutableArray* userAgentStats;
@property(nonatomic,retain)MonthSliderViewController*monthSliderViewController;
@property(nonatomic,retain) ShareWeiBoViewController*shareWeiBoViewController;

@property(nonatomic,retain)IBOutlet UIView *backView;
-(IBAction)turnBrnPress:(id)sender;
-(IBAction)refleshBtnPress:(id)sender;
-(IBAction)shareBtnPress:(id)sender;


@end
