//
//  DataListViewController.h
//  FlashApp
//
//  Created by lidiansen on 13-1-6.
//  Copyright (c) 2013年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StageStats.h"
#import "TwitterClient.h"
@class DatastatsViewController;
#define saveFlag 101;
#define jiasuFlag 102;
@interface DataListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    TwitterClient* twitterClient;
    long long jiasuCount;
    int tableCellCount;
}
@property (nonatomic, assign) long startTime;
@property (nonatomic, assign) long endTime;
@property(nonatomic,retain)IBOutlet UIView*dataView;
@property(nonatomic,retain)IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) UIViewController* viewcontroller;

@property(nonatomic,retain)IBOutlet UIButton *monthSaveBtn;
@property(nonatomic,retain)IBOutlet UIButton *jiaSuBtn;
@property(nonatomic,retain) UIButton *currentBtn;


@property(nonatomic,retain)StageStats* currentStats;
@property(nonatomic,retain)NSMutableArray *jiasuAgentArray;
@property(nonatomic,retain)NSMutableArray *jieshengAgentArray;

@property(nonatomic,retain)NSMutableArray *userAgentArray;
@property(nonatomic,retain)IBOutlet UILabel *saveCountLabel;
@property(nonatomic,retain)IBOutlet UILabel *unitLabel;
@property(nonatomic,retain)IBOutlet UITableView *myTableView;
//@property()
@property(nonatomic,retain)IBOutlet UIView *bgView;

@property (nonatomic ,retain) NSMutableDictionary *JieShengDic;

-(void)reloadData;
- (void) getAccessData;
-(IBAction)jiaSuBtnPress:(id)sender;
-(IBAction)monthSaveBtnPress:(id)sender;


@end


@protocol DataListViewControllerDelegate <NSObject>

-(void)getStageWithArray:(NSArray *)arr atPage:(int)page;

@end
