//
//  NetworkSpeedViewController.h
//  FlashApp
//
//  Created by lidiansen on 13-1-22.
//  Copyright (c) 2013年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "DetailStatsAppSpeed.h"
#import "CGLabel.h"
@class  ShareWeiBoViewController;
@interface NetworkSpeedViewController : UIViewController<ASIHTTPRequestDelegate,ASIProgressDelegate>
{
    NSOperationQueue*queue;
    DetailStatsAppSpeed* chart;
    DetailStatsAppSpeed*detailChart ;
    int countFlag;
    int connectTag;
    bool done;
    int received_;
}
@property(nonatomic,retain)NSTimer*timer;
@property(nonatomic,assign)NSAutoreleasePool *uploadPool;
@property(nonatomic,retain)NSURLConnection *connection;


@property(nonatomic,retain)NSString*urlStr;
@property(nonatomic,retain)UIViewController*controller;
@property(nonatomic,retain)IBOutlet CGLabel*cUnitLabel;
@property(nonatomic,retain)IBOutlet CGLabel*aUnitLabel;

@property(nonatomic,retain)IBOutlet UILabel*timeLable;
@property(nonatomic,retain)IBOutlet UIImageView*kuangImageView;
@property(nonatomic,retain)IBOutlet UIImageView*bgImageView;
@property(nonatomic,retain)IBOutlet CGLabel*idcName;
@property(nonatomic,retain)IBOutlet CGLabel*afterLabel;
@property(nonatomic,retain)IBOutlet CGLabel*beforeLabel;
@property(nonatomic,retain)IBOutlet CGLabel*currentLabel;


@property(nonatomic,retain)IBOutlet UIButton *shareBtn;
@property(nonatomic,retain)ShareWeiBoViewController *shareWeiBoViewController;


@property(nonatomic,retain)NSMutableArray *timeArray;

@property(nonatomic,retain)NSMutableArray *speedArray;
@property(nonatomic,retain)IBOutlet UIView*lineView;
@property(nonatomic,retain)IBOutlet UIView *afterView;
@property(nonatomic,retain)    NSDate* lastBytesReceived;

@property(nonatomic,retain)IBOutlet UIButton*beginTestBtn;
@property(nonatomic,retain)IBOutlet UIButton*downBeginTestBtn;
@property(nonatomic,retain)IBOutlet UIView*topView;
@property(nonatomic,retain)IBOutlet UIView *downView;
-(IBAction)turnBtnPress:(id)sender;
-(IBAction)beginTestBtnPress:(id)sender;
-(IBAction)downBeginTestBtnPress:(id)sender;
-(IBAction)shareBtnPress:(id)sender;
@end
