//
//  TaoCanViewController.h
//  FlashApp
//
//  Created by lidiansen on 12-12-19.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGLabel.h"
#import "TwitterClient.h"
#import "TCStatsAPPSpeed.h"
@class FlowJiaoZhunViewController;
@class JiaoZhunViewController;
@interface TaoCanViewController : UIViewController
{
    BOOL dirty;
    TCStatsAPPSpeed* chart;

}
@property(nonatomic,retain)NSMutableArray*chaDetailArray;
@property(nonatomic,retain)TCStatsAPPSpeed* chart;
@property(nonatomic,retain)IBOutlet UILabel*chartUnitLabel;
@property(nonatomic,retain)IBOutlet UIView*lineView;
@property(nonatomic,retain)IBOutlet UIImageView*kuangImageView;
@property(nonatomic,retain)IBOutlet UIImageView*wangGeImageView;

@property (nonatomic, retain) TwitterClient* client;
@property(nonatomic,retain)IBOutlet UILabel *unitLabel;
@property(nonatomic,retain)IBOutlet UIButton *turnBtn;
@property(nonatomic,retain)IBOutlet UIButton *jiaozhunBtn;
@property(nonatomic,retain)IBOutlet CGLabel *titleLabel;
@property(nonatomic,retain)IBOutlet CGLabel *shengyuLabel;
@property(nonatomic,retain)IBOutlet CGLabel*shengyuDetailLabel;
@property(nonatomic,retain)IBOutlet CGLabel*jingduLabel;
@property(nonatomic,retain)IBOutlet UILabel*jiaozhunTimeLabel;

@property(nonatomic,retain)IBOutlet UIImageView*jingduImageView;
@property(nonatomic,retain)IBOutlet UIImageView*jingduBgImageView;

@property(nonatomic,retain)FlowJiaoZhunViewController *flowJiaoZhunViewController;
@property(nonatomic,retain)JiaoZhunViewController *jiaoZhunViewController;
-(IBAction)turnBtnPress:(id)sender;
-(IBAction)jiaozhunBtnPress:(id)sender;
-(void)getDataTotalCount;
@end
