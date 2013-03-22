//
//  ViewController.h
//  FlashApp
//
//  Created by lidiansen on 12-12-13.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDPageControl.h"
#import "TwitterClient.h"
#import "StageStats.h"

@class FirstPageViewController;
@class SecondPageViewController;
@class GameStyleViewController;
@class SetingViewController;
@class UserInfoViewController;
@class NoLoginViewController;
@protocol ViewControllerDelegate <NSObject>
@optional
typedef enum {
    MT_REFRESH,
    MT_WIFI,
    MT_PROFILE,
    MT_PROXY_SLOW
} MessageType;
-(void)selectFinish:(NSString*)str title:(NSString*)title;

@end
@interface ViewController : UIViewController<UIScrollViewDelegate,ViewControllerDelegate>
{
    BOOL islogin;
    BOOL justLoaded;
    StageStats* stepStats;
    TwitterClient* twitterClient;
}
@property (nonatomic, retain) StageStats* totalStats;
@property (nonatomic, retain) StageStats* monthStats;




@property (nonatomic, assign) IBOutlet DDPageControl *pageControl;

@property(nonatomic,retain)IBOutlet UIScrollView *scrollview;
@property(nonatomic,retain)IBOutlet  UIButton* settingBtn;
@property(nonatomic,retain)IBOutlet UIButton *questionBtn;
@property(nonatomic,retain)IBOutlet UIButton *gameStyleBtn;
@property(nonatomic,retain)IBOutlet UIImageView *gameStyleImageView;
\

@property(nonatomic,retain)NoLoginViewController*noLoginViewController;
@property(nonatomic,retain)FirstPageViewController *firstPageViewController;
@property(nonatomic,retain)SecondPageViewController *secondPageViewController;
@property(nonatomic,retain)GameStyleViewController *gameStyleViewController;
@property(nonatomic,retain)UserInfoViewController *userInfoViewController;
@property(nonatomic,retain)SetingViewController*setingViewController;
-(IBAction)settingBtnPress:(id)sender;
-(IBAction)questionBtnPress:(id)sender;
-(IBAction)gameStyleBtnPress:(id)sender;
-(IBAction)refreshBtnPress:(id)sender;
@end
