//
//  MonthSliderViewController.h
//  FlashApp
//
//  Created by lidiansen on 12-12-18.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StageStats.h"

@interface MonthSliderViewController : UIViewController<UIScrollViewDelegate>
{
    int currentPage;
}
@property(nonatomic,retain)UIScrollView *superScrollView;
@property(nonatomic,retain)IBOutlet UIScrollView *scrollview;
//@property(nonatomic,retain)IBOutlet UIButton *leftBtn;
@property(nonatomic,retain)NSMutableArray *monthArray;
@property (nonatomic, assign) long startTime;
@property (nonatomic, assign) long endTime;
@property (nonatomic, retain) StageStats* currentStats;
- (void)loadScrollViewWithPage:(int)page  _StageStats:(StageStats*) StatsTime;

@end
