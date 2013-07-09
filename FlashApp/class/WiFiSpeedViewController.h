//
//  WiFiSpeedViewController.h
//  FlashApp
//
//  Created by lidiansen on 12-12-20.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGLabel.h"
#import "ASIHTTPRequest.h"
#import "DetailStatsAppSpeed.h"
@class ShareWeiBoViewController;
@interface WiFiSpeedViewController : UIViewController<ASIHTTPRequestDelegate,ASIProgressDelegate>
{
    DetailStatsAppSpeed* chart;
    int countFlag;
    
    bool done;
    int received_;
}
@property(nonatomic,retain)NSTimer*timer;
@property(nonatomic,assign)NSAutoreleasePool *uploadPool;
@property(nonatomic,retain)NSURLConnection *connection;

@property(nonatomic,retain)IBOutlet UIImageView*wanggeImageView;
@property(nonatomic,retain)IBOutlet UIImageView*kuangImageView;
@property(nonatomic,retain)IBOutlet UIView *lineView;
@property(nonatomic,retain)NSMutableArray *timeArray;

@property(nonatomic,retain)NSMutableArray *speedArray;
@property(nonatomic,retain)    NSDate* lastBytesReceived;

@property(nonatomic,retain)IBOutlet UILabel *topMessageLabel;
@property(nonatomic,retain)IBOutlet UILabel *downMessageLabel;
@property(nonatomic,retain)IBOutlet CGLabel *currentSpeedLabel;
@property(nonatomic,retain)IBOutlet CGLabel *averageSpeedLabel;
@property(nonatomic,retain)IBOutlet CGLabel *currentUnitLabel;
@property(nonatomic,retain)IBOutlet CGLabel*averageUnitLabel;
@property(nonatomic,retain)IBOutlet UIButton*beginTestBtn;
@property(nonatomic,retain)IBOutlet UIButton*downBeginTestBtn;
@property(nonatomic,retain)IBOutlet UIView*topView;
@property(nonatomic,retain)IBOutlet UIView *downView;
@property(nonatomic,retain)ShareWeiBoViewController *shareWeiBoViewController;
@property(nonatomic,retain)IBOutlet UIButton *shareBtn;

-(IBAction)shareBtnPress:(id)sender;
-(IBAction)turnBack:(id)sender;
-(IBAction)beginTestBtnPress:(id)sender;
-(IBAction)downBeginTestBtnPress:(id)sender;
@end
