//
//  LoadMoreViewController.h
//  FlashApp
//
//  Created by lidiansen on 13-3-5.
//  Copyright (c) 2013年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StageStats.h"
#import "StatsDetail.h"
@interface LoadMoreViewController : UIViewController
@property(nonatomic,retain)IBOutlet UITableView*myTableView;
@property(nonatomic,retain)IBOutlet UILabel *titleLabel;
@property (nonatomic, assign) long startTime;
@property (nonatomic, assign) long endTime;
@property(nonatomic,assign)int flag;
@property(nonatomic,retain)StageStats* currentStats;
@property(nonatomic,retain)StatsDetail *statsDetail;

@property(nonatomic,retain)NSMutableArray *jiasuAgentArray;
@property(nonatomic,retain)NSMutableArray *jieshengAgentArray;


-(IBAction)turnBtnPress:(id)sender;
@end
