//
//  ViewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-13.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import "ViewController.h"
#import "Define.h"
#import "FirstPageViewController.h"
#import "SecondPageViewController.h"
#import "GameStyleViewController.h"
#import "SetingViewController.h"
#import "UserInfoViewController.h"
#import "AccountNumberViewController.h"
#import "CommonProblemViewController.h"
#import "DBConnection.h"
#import "TCUtils.h"
#import "StatsMonthDAO.h"
#import "UserAgentLock.h"
#import "UserAgentLockDAO.h"
#import "NoLoginViewController.h"
#import "DateUtils.h"
#import "VPNHelpViewController.h"
#define PageCount 2
#define PageAllCount 2

@interface ViewController ()
-(void)initScrollview;
- (void)layoutScrollImages;
-(void)gameStyleBtnShow;
-(void)juedeNoLoginTimes;//每个月提示三次信息
- (void) renderDB;
- (void) loadDataFromDB;
- (void) displayAfterLoad:(StageStats*)oldMonthStats;
@end

@implementation ViewController
@synthesize scrollview;
@synthesize settingBtn;
@synthesize questionBtn;
@synthesize gameStyleBtn;

@synthesize firstPageViewController;
@synthesize secondPageViewController;

@synthesize gameStyleViewController;
@synthesize gameStyleImageView;

@synthesize userInfoViewController;
@synthesize setingViewController;
@synthesize totalStats;
@synthesize monthStats;
@synthesize noLoginViewController;
@synthesize pageControl;
-(void)dealloc
{
    self.pageControl=nil;
    self.noLoginViewController=nil;
    self.totalStats=nil;
    self.monthStats=nil;;
    
    self.scrollview=nil;
    
    self.settingBtn=nil;
    self.questionBtn=nil;
    self.gameStyleBtn=nil;
      
    self.firstPageViewController=nil;
    self.SecondPageViewController=nil;
    
    
    self.gameStyleViewController=nil;
    self.gameStyleImageView=nil;
    
    
    self.userInfoViewController=nil;
    self.setingViewController=nil;

    if ( twitterClient ) {
        [twitterClient cancel];
        [twitterClient release];
        twitterClient = nil;
    }


    
    [super dealloc];
}
- (void)viewWillAppear:(BOOL)animated
{
   // [self setLastUpdateDate];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ( justLoaded ) {
        [self performSelector:@selector(getAccessData) withObject:nil afterDelay:0.0];
        
        stepStats.bytesBefore = 0;
        

        justLoaded = NO;
    }
    else {
        AppDelegate* appDelegate = [AppDelegate getAppDelegate];
        if ( appDelegate.refreshDatasave ) {
            [self performSelector:@selector(getAccessData) withObject:nil afterDelay:0.0];
            appDelegate.refreshDatasave = NO;
        }
    }
    

    
  //  [self checkProfile];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pdVpnAndWifiOrSome];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self.navigationController setNavigationBarHidden:YES ];
    [self initScrollview];
    [self layoutScrollImages];
    [self gameStyleBtnShow];
    
    
	[pageControl setNumberOfPages: 2] ;
	[pageControl setCurrentPage: 0] ;
    
	[pageControl setOnColor: [UIColor colorWithWhite: 1.0f alpha: 1.0f]] ;
	[pageControl setOffColor: [UIColor colorWithWhite: 0.7f alpha: 1.0f]] ;
	[pageControl setIndicatorDiameter: 5.0f] ;
	[pageControl setIndicatorSpace: 7.0f] ;
    
    
    
    
    if(self.userInfoViewController==nil)
    {
        self.userInfoViewController=[[[UserInfoViewController alloc]init] autorelease];
        [self.view addSubview:self.userInfoViewController.view];
        if(iPhone5)
        {
            self.userInfoViewController.view.frame=CGRectMake(-16,18, 320, 61);
            
        }
        else
        {
            self.userInfoViewController.view.frame=CGRectMake(-16, 0, 320, 61);
            
        }
        //[self.view bringSubviewToFront:self.userInfoViewController.view];
        [self.userInfoViewController.kuangImageView setHidden:YES];
        [self.userInfoViewController.nameLineImageView setHidden:YES];
        self.userInfoViewController.view.transform=CGAffineTransformMakeScale(0.8, 0.8);
        
        
        
    }
    [self juedeNoLoginTimes];
    twitterClient = nil;
    [self renderDB];
    // [self getUserAgentLock];
    justLoaded = YES;
    
    //接收刷新通知
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadAndShowData) name:RefreshNotification object: nil];
    //
    //    //接收套餐数据修改通知
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadAndShowData) name:TCChangedNotification object: nil];
    
	// Do any additional setup after loading the view, typically from a nib.
}


- (void)viewWillDisappear:(BOOL)animated
{
   // [dialogView close];
    [super viewWillDisappear:animated];
}
- (void) getAccessData:(BOOL)dropdownRefresh
{
    //读已用流量
    [TCUtils readIfData:-1];
    
    if ( twitterClient ) {
        if ( dropdownRefresh ) {
            [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.3f];
        }
        return;
    }
    
    AppDelegate* app = [AppDelegate getAppDelegate];
    if ( [app.networkReachablity currentReachabilityStatus] == NotReachable ) {
        if ( dropdownRefresh ) {
            [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.3f];
        }
        return;
    }
    
    if ( ![[AppDelegate getAppDelegate].refreshingLock tryLock] ) {
        if ( dropdownRefresh ) {
            [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.3f];
        }
        return;
    }
    

    //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //self.navigationItem.rightBarButtonItem.enabled = NO;
    
    time_t lastDayLong = [AppDelegate getLastAccessLogTime];
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(didGetAccessData:obj:)];
    twitterClient.context = [NSArray arrayWithObjects:[NSNumber numberWithLong:lastDayLong], [NSNumber numberWithBool:dropdownRefresh],nil];
    [twitterClient getAccessData];

}
- (void) getAccessData
{
    [self getAccessData:NO];
}



- (void) didGetAccessData:(TwitterClient*)client obj:(NSObject*)obj
{
    twitterClient = nil;
    
    //self.navigationItem.rightBarButtonItem.enabled = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
   // [self hiddenMessage:MT_REFRESH];
    
    if ( client.hasError ) {
        [[AppDelegate getAppDelegate].refreshingLock unlock];
        //[self doneLoadingTableViewData];
        [AppDelegate showAlert:client.errorMessage];
        return;
    }
    
    [[AppDelegate getAppDelegate].refreshingLock unlock];
    NSArray* array = client.context;
    time_t t = [(NSNumber*)[array objectAtIndex:0] longValue];
    BOOL ddRefresh = [(NSNumber*) [array objectAtIndex:1] boolValue];
    
    StageStats* mstats = [monthStats retain];
    
    //处理返回的数据
    BOOL hasData = [TwitterClient procecssAccessData:obj time:t];
    if ( hasData ) {
        //从数据库中加载数据
        [self loadDataFromDB];
        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshNotification object:nil];
    }
    
    //读已用流量
    UserSettings* user = [AppDelegate getAppDelegate].user;
    if ( user.ifLastTime == 0 ) {
        [TCUtils readIfData:self.monthStats.bytesAfter];
    }
    
    //显示数据
    [self displayAfterLoad:mstats];
    [mstats release];
    

}

#pragma mark - loadData


- (void) showMessage:(NSString*)message
{
//    if ( refreshing ) return;
//    refreshing = YES;
//    [self.tableView reloadData];
}


-(void)juedeNoLoginTimes//每个月提示三次信息
{
    UserSettings* user = [AppDelegate getAppDelegate].user;
    NSString *sLastDate =user.nologinTime;//从UserDefaults获取上次访问的日期字符串
    NSDateFormatter *dateFormatter=[[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *lastDate;
    NSDate *nowDate = [[[NSDate alloc] init] autorelease];
    NSString *sNowDate = [dateFormatter stringFromDate:nowDate];//把当前日期格式化成字符串
    int minutes;
    if (sLastDate != nil)
    {
        lastDate = [dateFormatter dateFromString:sLastDate];//获得上次访问的日期
        
        NSTimeInterval time = [lastDate timeIntervalSinceNow];//将上次访问的日期与当前日期作比较得到两个日期的相隔秒数，返回的是NSTimeInterval，NSTimeInterval并不是对象，而是基本型，其实是double类型
        
        int iTime = (int)time * -1;
        
        minutes = iTime / 60/60/24;//把间隔的秒数折算成分钟数
    }
    if (minutes >= 30)
    {
        [UserSettings saveNologinCount:0];
        [UserSettings saveNologinTime:sNowDate];//访问成功后，保存当前的访问时间
        
    }
    
    else
    {
        if(user.nologinCount<3)
        {
            if ( user.username && user.username.length > 0 )
            {
            }
            else
            {
                if(self.noLoginViewController!=nil)
                {
                    [self.noLoginViewController.view removeFromSuperview];
                    self.noLoginViewController=nil;
                }
                if(iPhone5)
                {
                    self.noLoginViewController=[[[NoLoginViewController alloc]initWithNibName:@"NoLoginViewController_iphone5" bundle:nil] autorelease];

                }
                else
                {
                    self.noLoginViewController=[[[NoLoginViewController alloc]initWithNibName:@"NoLoginViewController" bundle:nil] autorelease];

                }
                [self.view addSubview:self.noLoginViewController.view];
            }
            user.nologinCount+=1;
            [UserSettings saveNologinCount:user.nologinCount];

        }
    }
 
}
- (void) loadDataFromDB
{
    [DBConnection beginTransaction];
    //得到节省流量的总数
    self.totalStats = [StatsMonthDAO statForPeriod:0 endTime:0];
    
    if ( totalStats ) {
        //得到本月节省的流量
        time_t now;
        time( &now );
        //now = now - 10L * 24 * 3600;
        
        time_t peroid[2];
        [TCUtils getPeriodOfTcMonth:peroid time:now];
        self.monthStats = [StatsMonthDAO statForPeriod:peroid[0] endTime:peroid[1]];
    }
    
    [DBConnection commitTransaction];
}

- (void) renderDB
{
    [self loadDataFromDB];
    
    StageStats* oldStats = [self.monthStats retain];
    [self displayAfterLoad:oldStats];
    [oldStats release];
}
- (void) displayAfterLoad:(StageStats*)oldMonthStats
{
    //[self viewShowData];add jianfei han 
    
    if ( !oldMonthStats || oldMonthStats.bytesBefore == 0 ) {
     
        stepStats.bytesBefore = 0;
 
    }
    

}

-(void)initScrollview
{
    self.scrollview.scrollEnabled = YES;
	self.scrollview.pagingEnabled = YES;
    self.scrollview.opaque=NO;
    self.scrollview.backgroundColor=[UIColor clearColor];
    self.scrollview.showsHorizontalScrollIndicator=NO;
    self.scrollview.bounces=YES;
    self.scrollview.delegate=self;
    

    if(iPhone5)
    {
        self.firstPageViewController=[[[FirstPageViewController alloc]initWithNibName:@"FirstPageViewController_iphone5" bundle:nil]autorelease];
        self.secondPageViewController=[[[SecondPageViewController alloc]initWithNibName:@"SecondPageViewController_iphone5" bundle:nil]autorelease];

    }
    else
    {
        self.firstPageViewController=[[[FirstPageViewController alloc]init]autorelease];
        self.secondPageViewController=[[[SecondPageViewController alloc]init] autorelease];

    }
    self.firstPageViewController.view.tag=201;
    [self.scrollview addSubview:self.firstPageViewController.view];



    
    self.secondPageViewController.view.tag=202;
    [self.scrollview addSubview:self.secondPageViewController.view];
    
    
    self.scrollview.decelerationRate=0.1;
}
-(void)gameStyleBtnShow
{
    NSString* str=[[NSUserDefaults standardUserDefaults] objectForKey:Model];
    NSString *imageStr=nil;
    NSString*titleStr=nil;
    if([str length]!=0)
    {
        if([str isEqualToString:DefaultModel])
        {
            imageStr=[NSString stringWithFormat:@"%@",@"gamestyledefaultlogo.png"];
            titleStr=[NSString stringWithFormat:@"%@",@"   默认模式"];
        }
        else if([str isEqualToString:GameModel])
        {
            imageStr=[NSString stringWithFormat:@"%@",@"gamestylegamelogo.png"];
            titleStr=[NSString stringWithFormat:@"%@",@"   游戏模式"];
            
        }
        else if([str isEqualToString:BuyModel])
        {
            imageStr=[NSString stringWithFormat:@"%@",@"gamestylebuylogo.png"];
            titleStr=[NSString stringWithFormat:@"%@",@"   购物模式"];
            
        }
        else if([str isEqualToString:SleepModle])
        {
            imageStr=[NSString stringWithFormat:@"%@",@"gamestylesleeplogo.png"];
            titleStr=[NSString stringWithFormat:@"%@",@"   睡眠模式"];
            
        }
    }
    else
    {
        imageStr=[NSString stringWithFormat:@"%@",@"gamestyledefaultlogo.png"];
        titleStr=[NSString stringWithFormat:@"%@",@"   默认模式"];
        
    }
    [self.gameStyleBtn setTitle:titleStr forState:UIControlStateNormal];
    [self.gameStyleImageView setImage:[UIImage imageNamed:imageStr]];
}
- (void)layoutScrollImages
{
    UIView  *view = nil;
    NSArray *subviews = [self.scrollview subviews];
    CGFloat curXLoc = 0;
    for (view in subviews)
    {
        if([view isKindOfClass:[UIView class]]&&(view.tag >=201))
        {
            CGRect frame =view.frame;
            frame.origin = CGPointMake(curXLoc, 0);
            view.frame = frame;
            // NSLog(@"view,fram%@",view);
            
            curXLoc +=(self.scrollview.frame.size.width);
        }
    }
    //NSLog(@"scrollview subs: %@",subviews);
    [self.scrollview setContentSize:CGSizeMake((PageCount * self.scrollview.bounds.size.width),self.scrollview.bounds.size.height)];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView               //"触摸滑动事件
{
    CGFloat pageWidth = self.scrollview.frame.size.width;
    int page = floor((self.scrollview.contentOffset.x - pageWidth / 2) / pageWidth) + 1;//获得当前的页号
    self.pageControl.currentPage=page;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollEnd" object:nil];//滑动停止 恢复按钮状态，解决（如果快速滑动，按钮有些时间会响应有问题。）

}
//#pragma -mark update lock app
//- (void) getUserAgentLock
//{
//    if ( twitterClient ) return;
//    
//    NSString* url = [NSString stringWithFormat:@"%@/%@.json?",
//                     API_BASE, API_SETTING_UA_ALL_ENABLED];
//    
//    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(didGetUserAgentLock:obj:)];
//    url = [TwitterClient composeURLVerifyCode:url];
//    [twitterClient get:url];
//}
//
//
//- (void) didGetUserAgentLock:(TwitterClient*)tc obj:(NSObject*)obj
//{
//    twitterClient = nil;
//    
//    //if ( tc.hasError ) {
//    //    [AppDelegate showAlert:tc.errorMessage];
//    //    return;
//    //}
//    
//    if ( !obj && ![obj isKindOfClass:[NSDictionary class]] ) {
//        return;
//    }
//    
//    NSDictionary* allLockDic = (NSDictionary*) obj;
//    NSArray *array=[allLockDic allKeys];
//    NSLog(@"lock app%@",allLockDic);
//    
//    for(int i=0;i<[array count];i++)
//    {
//        NSDictionary *lockDic=[allLockDic objectForKey:[array objectAtIndex:i]];
//        int lock = [[lockDic objectForKey:@"lk"] intValue];
//        long timeLength = [[lockDic objectForKey:@"lkt"] intValue];
//        UserAgentLock* agentLock = [[UserAgentLock alloc] init];
//        agentLock.isLock = lock;
//        agentLock.userAgent=[array objectAtIndex:i];
//        if ( lock )
//        {
//            time_t now;
//            time( &now );
//            if ( timeLength == 0 ) {
//                agentLock.timeLengh = 0;
//            }
//            else {
//                agentLock.timeLengh = timeLength * 60;
//            }
//        }
//        [UserAgentLockDAO updateUserAgentLock:agentLock];
//        
//    }
//}
//
-(void)detailBtnPress
{

    AccountNumberViewController*accountNumberViewController=[[[AccountNumberViewController alloc]init] autorelease];
    [self.navigationController pushViewController:accountNumberViewController animated:YES];
}
-(IBAction)settingBtnPress:(id)sender
{
    SetingViewController *setController=[[[SetingViewController alloc]init] autorelease];
    [self.navigationController pushViewController:setController animated:YES];

}
-(IBAction)questionBtnPress:(id)sender
{
    CommonProblemViewController*commonProblemViewController=[[[CommonProblemViewController alloc]init] autorelease];
    [self.navigationController pushViewController:commonProblemViewController animated:YES];
}
-(IBAction)gameStyleBtnPress:(id)sender
{
//    if(self.gameStyleViewController!=nil)
//    {
//        [self.gameStyleViewController.view removeFromSuperview];
//        self.gameStyleViewController=nil;
//    }
//
//    self.gameStyleViewController=[[[GameStyleViewController alloc]init] autorelease];
//
//    self.gameStyleViewController.delegate=self;
//    [sysdelegate.window.rootViewController.view addSubview:self.gameStyleViewController.view];
}
-(IBAction)refreshBtnPress:(id)sender
{
    ConnectionType type = [UIDevice connectionType];
    if(type==NONE)
    {
        [AppDelegate showAlert:@"提示信息" message:@"网络连接异常,请连接网络"];
        return;
    }
    
    [self pdVpnAndWifiOrSome];
    
    
    [[AppDelegate getAppDelegate ]timerTask];
    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshNotification object:nil];

}

/*
 *判断在wifi下 或者在 3G下 VPN 是否开启关闭
 *
 */
-(void)pdVpnAndWifiOrSome
{
    ConnectionType type = [UIDevice connectionType];
    if (type==WIFI && [AppDelegate pdVpnIsOpenOrClose]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请您关闭VPN" message:@"系统检测到您正在WIFI环境下，请您关闭VPN，获得更好的网络体验！" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:@"如何 关闭 VPN", nil];
        alertView.tag = 1111;
        [alertView show];
        [alertView release];
    }
    
    if (type ==CELL_2G  && ![AppDelegate pdVpnIsOpenOrClose] ) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请您开启VPN" message:@"系统检测到您正在2G/3G环境下，请您开启VPN，获得更好的网络体验！" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:@"如何 开启 VPN", nil];
        alertView.tag = 1112;
        [alertView show];
        [alertView release];
    }

}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        VPNHelpViewController *vpnHelp = [[VPNHelpViewController alloc] init];
        [self.navigationController pushViewController:vpnHelp animated:YES];
        [vpnHelp release];
    }
}

-(void)selectFinish:(NSString*)str title:(NSString*)title
{
    UIImage *image=[UIImage imageNamed:str];
    self.gameStyleImageView.frame=CGRectMake(self.gameStyleImageView.frame.origin.x, self.gameStyleImageView.frame.origin.y, image.size.width/2, image.size.height/2);
    self.gameStyleImageView.image=image;
    [self.gameStyleBtn setTitle:title forState:UIControlStateNormal];
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
