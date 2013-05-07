//
//  RecommendViewController.h
//  FlashApp
//
//  Created by lidiansen on 12-12-24.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
@class RecommendDetailViewController;
@interface RecommendViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate,UIGestureRecognizerDelegate>{
    NSString *currentCateID;
    NSTimer *scrollTimer;
    BOOL moring;
    int currentCount;
    int currentPageForPage;
    NSOperationQueue*queue;
    BOOL pdSanJiao;
}
@property(nonatomic,retain)IBOutlet UILabel *titleLabel;

@property(nonatomic,retain)NSMutableArray *requestArray;

@property(nonatomic,retain)IBOutlet UITableView *myTableView;

@property (retain, nonatomic) IBOutlet UIView *headView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *scrollActivity;
@property(nonatomic,retain)IBOutlet UIPageControl *pageControl;
@property(nonatomic,retain)IBOutlet UIScrollView *topScrollView;

@property (retain, nonatomic) IBOutlet UIView *sectionView;
@property(nonatomic,retain)IBOutlet UIButton *explainBtn;
@property(nonatomic,retain)IBOutlet UIButton *topAppBtn;
@property(nonatomic,retain)IBOutlet UIButton *topGameBtn;
@property(nonatomic,retain)IBOutlet UIButton *freeBtn;

@property (retain, nonatomic) IBOutlet UIImageView *xianMianRedDian;
@property (retain, nonatomic) IBOutlet UIImageView *gamesRedDian;

@property (nonatomic ,copy) void (^showNewsAppAnimation)(BOOL);


@property(nonatomic,retain)RecommendDetailViewController *recommendDetailViewController;
-(IBAction)topAppBtnPress:(id)sender;
-(IBAction)topGameBtnPress:(id)sender;
-(IBAction)explainBtnPress:(id)sender;
-(IBAction)turnBrnPress:(id)sender;


@end
