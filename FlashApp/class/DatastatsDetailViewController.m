//
//  DatastatsDetailViewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-18.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import "DatastatsDetailViewController.h"
#import "ShareWeiBoViewController.h"
#import "DateUtils.h"
#import "StatsDetailDAO.h"
#import "StringUtil.h"
#import "UserAgentLockDAO.h"
#import "TCUtils.h"
#import "DataListViewController.h"
#import "StatsDayDAO.h"
#import "StatsMonthDAO.h"
@interface DatastatsDetailViewController ()
- (void) loadData;
- (void) showLockStatus;
-(void)averageUse;
- (void) getUserAgentLock;
- (void) disableUserAgentNetwork:(int)isLock lockMinutes:(int)minutes;
@end

@implementation DatastatsDetailViewController
@synthesize turnBtn;
@synthesize titleLabel;
@synthesize MessageLabel;
@synthesize countLabel;
@synthesize youLikeLabel;
@synthesize jieshengLabel;
//@synthesize button1,button2,button3,button4;
@synthesize shareBtn;
@synthesize shareWeiBoViewController;
@synthesize lockOrUnlockBtn;
@synthesize wangGeImageView;
@synthesize statsDetail;
@synthesize unitLabel;
@synthesize agentLock;
@synthesize renderLine;
@synthesize currentStats;
@synthesize chartUnitLabel;
@synthesize bgView;
@synthesize bgImageView;
@synthesize kuangImageView;
//@synthesize label1,label2,label3,label4;
@synthesize startTime;
@synthesize endTime;
@synthesize dataListController;
-(void)dealloc
{
    self.dataListController=nil;
    self.bgView=nil;
    self.bgImageView=nil;
    self.currentStats=nil;
    self.chartUnitLabel=nil;
    self.renderLine=nil;
    self.wangGeImageView=nil;
    self.shareBtn=nil;
    self.turnBtn=nil;
    self.titleLabel=nil;
    self.MessageLabel=nil;
    self.countLabel=nil;
    self.youLikeLabel=nil;
    self.jieshengLabel=nil;
    self.unitLabel=nil;
    self.agentLock=nil;
    self.kuangImageView=nil;
    //    self.button1=nil;
    //    self.button2=nil;
    //    self.button3=nil;
    //    self.button4=nil;
    //
    //    self.label1=nil;
    //    self.label2=nil;
    //    self.label3=nil;
    //    self.label4=nil;
    
    if ( client ) {
        [client cancel];
        [client release];
        client = nil;
    }
    [chart release];
    self.shareWeiBoViewController=nil;
    self.lockOrUnlockBtn=nil;
    
    self.statsDetail=nil;
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)showFirstLockMessage
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    int firstLock=[userDefaults integerForKey:@"firstLock"];
    if(firstLock!=0)
    {
        //bgView=[UIView alloc]initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
        [self.bgView removeFromSuperview];
    }
    else
    {
        UserAgentLock*agentL = [UserAgentLockDAO getUserAgentLock:[self.statsDetail.uaStr trim]];

        if ( agentL && agentL.isLock )
        {
            UIImage *image1=[UIImage imageNamed:@"detail_first2.png"];
            image1=[image1 stretchableImageWithLeftCapWidth:0 topCapHeight:215.0];
            self.bgImageView.image=image1;
        }
        else
        {
            UIImage *image1=[UIImage imageNamed:@"detail_first.png"];
            image1=[image1 stretchableImageWithLeftCapWidth:0 topCapHeight:215.0];
            self.bgImageView.image=image1;
        }
        [self.bgView setHidden:NO];
    }
    

}
-(void)viewWillAppear:(BOOL)animated
{
    [self showFirstLockMessage];
       self.titleLabel.text=self.statsDetail.userAgent;
//    CGSize mbDataFrame = [titleLabel.text sizeWithFont:titleLabel.font constrainedToSize:CGSizeMake(320, 999) lineBreakMode:UILineBreakModeWordWrap];
//    titleLabel.frame =CGRectMake(titleLabel.frame.origin.x,titleLabel.frame.origin.y,mbDataFrame.width,titleLabel.frame.size.height);
    [self loadData];
    [self showLockStatus];
    [self averageUse];
    [super viewWillAppear:YES];
}
-(void)averageUse
{
    time_t now;
    time(&now);
    int currentDay = [[DateUtils stringWithDateFormat:now format:@"dd"] intValue];
    int jiesunDay=[[UserSettings  currentUserSettings].ctDay intValue];
    int cha=currentDay-jiesunDay;
    if(cha==0)
        cha=1;
    float count=self.statsDetail.after/cha;
    NSArray*countsss=[NSString bytesAndUnitString:count decimal:2];

 
    NSString*str=[countsss objectAtIndex:0];
   
    str=[NSString stringWithFormat:@"日均使用%@%@",str,[countsss objectAtIndex:1]];
        
  
    self.MessageLabel.text=str;
    
    NSArray*array=[NSString bytesAndUnitString:(self.statsDetail.before - self.statsDetail.after) decimal:2];    
    self. countLabel.text=[array objectAtIndex:0];
    self.unitLabel.text=[array objectAtIndex:1];
    [AppDelegate setLabelFrame:self.countLabel label2:self.unitLabel];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *image2=[UIImage imageNamed:@"white_box.png"];
    image2=[image2 stretchableImageWithLeftCapWidth:image2.size.width/2 topCapHeight:image2.size.height/2];
    self.kuangImageView.image=image2;
    
    UIImage *image=[UIImage imageNamed:@"wangge.png"];
    self.wangGeImageView.backgroundColor=[UIColor colorWithPatternImage:image] ;
    self.wangGeImageView.opaque=NO;
    
    UITapGestureRecognizer *tapgester=[[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHandle)] autorelease];
    [self.bgView addGestureRecognizer:tapgester];

    
    loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(95, 150, 130, 100)];
    loadingView.message = NSLocalizedString(@"set.accountView.loading.message", nil);
    loadingView.hidden = YES;
    [self.view addSubview:loadingView];
    [loadingView release];
    

    
    UIImage* img=[UIImage imageNamed:@"unlock_btn_bg.png"];
    img=[img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:0];
    [self.lockOrUnlockBtn setBackgroundImage:img forState:UIControlStateNormal];
    
    [AppDelegate labelShadow:self.lockOrUnlockBtn.titleLabel];

    chart = [[DetailStatsAppLineChart alloc] init];
    chart.userAgent = self.statsDetail.userAgent;
    chart.linColor=[UIColor colorWithRed:0.0/255 green:191.0/255 blue:232.0/255 alpha:1.0];
    chart.arColor=[UIColor colorWithRed:191.0/255 green:239.0/255 blue:249.0/255 alpha:1.0];

   // [AppDelegate ]
     // Do any additional setup after loading the view from its nib.
}
-(void)tapHandle
{
    [self.bgView removeFromSuperview];
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:1 forKey:@"firstLock"];
}
-(IBAction)turnBtn:(id)sender
{
    DataListViewController*dataController=(DataListViewController*)self.dataListController;
    [dataController reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)shareBtnPress:(id)sender
{
    if(self.shareWeiBoViewController!=nil)
    {
        [self.shareWeiBoViewController.view removeFromSuperview];
    }
    self.shareWeiBoViewController=[[[ShareWeiBoViewController alloc ]init] autorelease];
    [self.view addSubview:self.shareWeiBoViewController.view];
    self.shareWeiBoViewController.backView.frame=CGRectMake(self.shareWeiBoViewController.backView.frame.origin.x, self.shareBtn.frame.size.height+self.shareBtn.frame.origin.y-10, self.shareWeiBoViewController.backView.frame.size.width, self.shareWeiBoViewController.backView.frame.size.height);
    
}
-(void)loadData
{
    self.agentLock = [UserAgentLockDAO getUserAgentLock:[self.statsDetail.uaStr trim]];
   // NSLog(@"FFFFFFFFFFFFFFFFFFFFF%@",[UserAgentLockDAO getAllLockedApps]);

    [self getUserAgentLock];
    
//
//    time_t today = [DateUtils getLastTimeOfToday];
//    time_t now;
//    time(&now);
//    time_t peroid[2];
//    [TCUtils getPeriodOfTcMonth:peroid time:now];
//   long startTime=peroid[0];
//
//    long endTime = (self.currentStats.endTime > today ? today : self.currentStats.endTime);
    
//    long startTime=1356969600;
//    long endTime=1359647999
    NSArray*userAgentData = [StatsDayDAO getUserAgentData:self.statsDetail.userAgent start:startTime end:endTime];

   // NSArray*userAgentData = [StatsDayDAO getUserAgentData:self.statsDetail.userAgent start:peroid[0] end:peroid[1]];

    NSLog(@"rrrrrrrrrrrrrrrr%@",self.agentLock.userAgent);

    NSMutableArray* arr = (NSMutableArray*) userAgentData;
    if ( [userAgentData count] > 0 ) {
        StatsDetail* firstStats = [userAgentData objectAtIndex:0];
        StatsDetail* lastStats = [userAgentData lastObject];
        if ( firstStats.accessDay != startTime ) {
            StatsDetail* startStats = [[StatsDetail alloc] init];
            startStats.accessDay = startTime;
            startStats.before = 0;
            startStats.after = 0;
            [arr insertObject:startStats atIndex:0];
            [startStats release];
        }
        
        if ( lastStats.accessDay != endTime ) {
            StatsDetail* endStats = [[StatsDetail alloc] init];
            endStats.accessDay = endTime;
            endStats.before = 0;
            endStats.after = 0;
            [arr addObject:endStats];
            [endStats release];
        }
    }
    
    StatsDetail* prevStats = [StatsDetailDAO getLastStatsDetailBefore:startTime userAgent:self.statsDetail.userAgent];
    StatsDetail* nextStats = [StatsDetailDAO getFirstStatsDetailAfter:endTime userAgent:self.statsDetail.userAgent];
    
    prevMonthTimes[0] = 0;
    prevMonthTimes[1] = 0;
    nextMonthTimes[0] = 0;
    nextMonthTimes[1] = 0;
    

    
    if ( prevStats && prevStats.before > 0 ) {
        [TCUtils getPeriodOfTcMonth:prevMonthTimes time:prevStats.accessDay];
    }
    else {
    }
    
    if ( nextStats && nextStats.before > 0) {
        [TCUtils getPeriodOfTcMonth:nextMonthTimes time:nextStats.accessDay];
        time_t today = [DateUtils getLastTimeOfToday];
        if ( nextMonthTimes[1] > today ) {
            nextMonthTimes[1] = today;
        }
    }
    else {
    }

    
    
    chart.userAgentData = userAgentData;
    
    
    long long maxBytes = 0;
    for ( StatsDetail* stats in userAgentData ) {
        maxBytes = MAX( maxBytes, stats.before );
    }
    
    NSArray* arr1 = [NSString bytesAndUnitString:maxBytes];
    //NSString* byteUnit = [ retain];
    self.chartUnitLabel.text = [arr1 objectAtIndex:1];
    NSLog(@"ussssssssss%d",self.statsDetail.uaStr.length);

    [chart renderInView:self.renderLine withTheme:nil];
}

- (void) getUserAgentLock
{
    if ( client ) return;

    NSString* url = [NSString stringWithFormat:@"%@/%@.json?misc=%@",
                     API_BASE, API_SETTING_UA_IS_ENABLED,
                     [[self.statsDetail.uaStr trim] encodeAsURIComponent]];
    client = [[TwitterClient alloc] initWithTarget:self action:@selector(didGetUserAgentLock:obj:)];
    url = [TwitterClient composeURLVerifyCode:url];
    [client get:url];
}


- (void) didGetUserAgentLock:(TwitterClient*)tc obj:(NSObject*)obj
{
    client = nil;
    
    //if ( tc.hasError ) {
    //    [AppDelegate showAlert:tc.errorMessage];
    //    return;
    //}
    
    if ( !obj && ![obj isKindOfClass:[NSDictionary class]] ) {
        return;
    }
    
    NSDictionary* dic = (NSDictionary*) obj;
   // NSLog(@"lock app%@",dic);
    int lock = [[dic objectForKey:@"lk"] intValue];
    long timeLength = [[dic objectForKey:@"lkt"] intValue];
    
    if ( !agentLock ) {
        agentLock = [[UserAgentLock alloc] init];
        agentLock.userAgent = [self.statsDetail.uaStr trim];
        agentLock.appName=self.statsDetail.userAgent;
    }
    
    agentLock.isLock = lock;
    if ( lock ) {
        time_t now;
        time( &now );
        if ( timeLength == 0 ) {
            agentLock.timeLengh = 0;
        }
        else {
            agentLock.timeLengh = timeLength * 60;
        }
    }
    [self showLockStatus];
    [UserAgentLockDAO updateUserAgentLock:agentLock];
}



#pragma mark - disable/enable network connect

-(IBAction)lockOrUnlockBtnPress:(id)sender
{
    
    
    if ( agentLock && agentLock.isLock )
    {
        [self disableUserAgentNetwork:0 lockMinutes:0];

    }
    else
    {
        UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"选择暂停网络连接的时间" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"2小时",@"8小时",@"当月",@"永久(手动开启)", nil];
        [sheet showInView:sysdelegate.window.rootViewController.view];
        [sheet release];
    }

    
//    
//    UserAgentLockStatus status = [agentLock lockStatus];
//    if ( status == LOCK_STATUS_YES ) {
//        //解锁
//        [self disableUserAgentNetwork:0 lockMinutes:0];
//    }
//    else {
//        //加锁
//        UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"选择暂停网络连接的时间" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"2小时",@"8小时",@"当月",@"永久(手动开启)", nil];
//        [sheet showInView:sysdelegate.window.rootViewController.view];
//        [sheet release];
//    }
}
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    time_t now;
    time_t end;
    time( &now );
    int minutes = -1;
    
    if ( buttonIndex == 0 ) {
        end = now + 2 * 3600;
        minutes = 120;
    }
    else if ( buttonIndex == 1 ) {
        end = now + 8 * 3600;
        minutes = 480;
    }
    else if ( buttonIndex == 2 ) {
        time_t period[2];
        [TCUtils getPeriodOfTcMonth:period time:now];
        end = period[1];
        minutes = (period[1] - now) / 60;
        if ( minutes == 0 ) minutes = 1;
    }
    else if ( buttonIndex == 3 ) {
        minutes = 0;
    }
    else {
        end = 0;
    }
    
    if ( minutes != -1 ) {
        [self disableUserAgentNetwork:1 lockMinutes:minutes];
    }
}


- (void) disableUserAgentNetwork:(int)isLock lockMinutes:(int)minutes
{
    UserSettings* user = [AppDelegate getAppDelegate].user;
    NSString* url = [NSString stringWithFormat:@"%@/%@.json?misc=%@&lock=%d&locktime=%d&host=%@&port=%d",
                     API_BASE, API_SETTING_DISABLEUA,
                     [[self.statsDetail.uaStr trim] encodeAsURIComponent], isLock, minutes, user.proxyServer, user.proxyPort];
    url = [TwitterClient composeURLVerifyCode:url];
    
    NSHTTPURLResponse* response;
    NSError* error;
    
    loadingView.hidden = NO;
    NSObject* obj = [TwitterClient sendSynchronousRequest:url response:&response error:&error];
    [self performSelector:@selector(hiddenLoadingView) withObject:nil afterDelay:0.3f];
    
    if ( response.statusCode == 200 ) {
        if ( !obj && ![obj isKindOfClass:[NSDictionary class]] ) {
            [AppDelegate showAlert:@"抱歉，操作失败"];
        }
        
        NSDictionary* dic = (NSDictionary*) obj;
        NSNumber* number = (NSNumber*) [dic objectForKey:@"code"];
        int code = [number intValue];
        if ( code == 200 ) {
            time_t now;
            
            time( &now );
            // NSLog(@"DDDDDDDDDDDDDDDDD%@",[self dateInFormat:now format:@"%d.%m.%Y %H:%M:%S"]);
            
            if ( isLock ) {
                if ( !agentLock ) {
                    agentLock = [[UserAgentLock alloc] init];
                    agentLock.userAgent = [self.statsDetail.uaStr trim];
                    agentLock.appName=self.statsDetail.userAgent;
                }
                agentLock.isLock = 1;
                agentLock.lockTime = now;
                agentLock.timeLengh = minutes * 60;
                [AppDelegate showAlert:@"已经暂时停止了该应用的网络链接。"];
            }
            else {
                if ( agentLock ) {
                    agentLock.isLock = 0;
                    agentLock.resumeTime = now;
                }
                [AppDelegate showAlert:@"已经恢复了该应用的网络链接。"];
            }
            if ( agentLock ) {
                [UserAgentLockDAO updateUserAgentLock:agentLock];
                [self showLockStatus];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshAppLockedNotification object:nil];
        }
        else {
            [AppDelegate showAlert:@"抱歉，操作失败"];
        }
    }
    else {
        [AppDelegate showAlert:@"抱歉，操作失败"];
    }
}
- (void) showLockStatus
{
//    if ( !self.statsDetail.uaStr || [self.statsDetail.uaStr length] == 0 ) button.hidden = YES;
    
    //显示是否被暂停网络链接
    //UserAgentLockStatus status = [agentLock lockStatus];
    [self showFirstLockMessage];
    if ( agentLock && agentLock.isLock )
    {
        [lockOrUnlockBtn setImage:[UIImage imageNamed:@"suoed.png"] forState:UIControlStateNormal];
        [lockOrUnlockBtn setTitle:@"解锁" forState:UIControlStateNormal];
    }
    else
    {
        [lockOrUnlockBtn setImage:[UIImage imageNamed:@"suowangicon.png"] forState:UIControlStateNormal];
        [lockOrUnlockBtn setTitle:@"锁网" forState:UIControlStateNormal];
    }
//    if ( status == LOCK_STATUS_YES ) {
//     
//
//    }
//    else if ( status == LOCK_STATUS_EXPIRED ) {
//        [lockOrUnlockBtn setImage:[UIImage imageNamed:@"suowangicon.png"] forState:UIControlStateNormal];
//        [lockOrUnlockBtn setTitle:@"锁网" forState:UIControlStateNormal];
//    }
//    else {
//        [lockOrUnlockBtn setImage:[UIImage imageNamed:@"suowangicon.png"] forState:UIControlStateNormal];
//        [lockOrUnlockBtn setTitle:@"锁网" forState:UIControlStateNormal];
//
//    }
}


- (void) hiddenLoadingView
{
    loadingView.hidden = YES;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
