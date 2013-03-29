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
@property(nonatomic,retain)NSMutableArray *requestArray;
@property(nonatomic,retain)IBOutlet UITableView *myTableView;
@property(nonatomic,retain)IBOutlet UIImageView *btnBgImageView;
@property(nonatomic,retain)IBOutlet UIButton *explainBtn;
@property(nonatomic,retain)IBOutlet UIButton *topAppBtn;
@property(nonatomic,retain)IBOutlet UIButton *topGameBtn;

@property(nonatomic,retain)IBOutlet UILabel *titleLabel;

@property (retain, nonatomic) IBOutlet UIImageView *scrollShowImage;
@property (retain, nonatomic) IBOutlet UIButton *scrollShowBtn;

@property(nonatomic,retain)RecommendDetailViewController *recommendDetailViewController;
-(IBAction)topAppBtnPress:(id)sender;
-(IBAction)topGameBtnPress:(id)sender;
-(IBAction)explainBtnPress:(id)sender;
-(IBAction)turnBrnPress:(id)sender;


@end
