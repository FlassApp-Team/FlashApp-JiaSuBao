//
//  LockNetWorkViewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-20.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//
#define AGENT_BUTTON_TAG 100
#import "LockNetWorkViewController.h"
#import "ShareWeiBoViewController.h"
#import "TCUtils.h"
#import "UserAgentLockDAO.h"
#import "StatsDetailDAO.h"
#import "UserAgentLock.h"
#import "StringUtil.h"
#import "DateUtils.h"
#import "StatsDetail.h"
#import "StageStats.h"
#import "StatsMonthDAO.h"

@interface LockNetWorkViewController ()
- (void) getUserAgentLock;
-(void)initAgentName:(UILabel*)label index:(int)index;
-(void)initDetail:(UILabel*)label index:(int)index;
- (void) disableUserAgentNetwork:(int)isLock lockMinutes:(int)minutes usStrIndex:(int)uaStrIndex;
- (void) unlockButtonClick;
- (void) unlockAllApps;
-(void)loadtableViewWithjiesuo;
-(void)loadtableViewWithjiasuo;
@end

@implementation LockNetWorkViewController
@synthesize myTableView;
@synthesize refleshBtn;
@synthesize shareWeiBoViewController;
@synthesize shareBtn;
@synthesize startTime;
@synthesize endTime;
@synthesize allLockDic;
@synthesize AppCountLabel;
@synthesize AppCountLabel_1;
@synthesize datasArray;
@synthesize allLockArr;
@synthesize kesuoBtn;

-(void)dealloc
{
    self.AppCountLabel=nil;
    self.AppCountLabel_1 = nil;
    self.allLockDic=nil;
    self.shareBtn=nil;
    self.shareWeiBoViewController=nil;
    self.refleshBtn=nil;
    self.myTableView=nil;
    self.datasArray = nil;
    self.allLockArr = nil;
    self.kesuoBtn = nil;
    if ( twitterClient ) {
        [twitterClient cancel];
        [twitterClient release];
        twitterClient = nil;
    }
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

-(void)viewWillDisappear:(BOOL)animated
{
    if ( twitterClient ) {
        [twitterClient cancel];
        [twitterClient release];
        twitterClient = nil;
    }
    [super viewWillDisappear:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    pdsw = YES;
    
    datasArray = [[NSMutableArray alloc] init];
    
    allLockArr = [[NSMutableArray alloc] init];
    
    UIImage* img=[UIImage imageNamed:@"unlock_btn_bg"];
    img=[img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:0];
    [self.oneUnlockBtn setBackgroundImage:img forState:UIControlStateNormal];
    
    UIImage* img1=[UIImage imageNamed:@"opaque_small.png"];
    img1=[img1 stretchableImageWithLeftCapWidth:7 topCapHeight:8];
    
    [self.refleshBtn setBackgroundImage:img1 forState:UIControlStateNormal];
    
    twitterClient = nil;
    time_t now;
    time(&now);
    time_t peroid[2];
    [TCUtils getPeriodOfTcMonth:peroid time:now];
    startTime=peroid[0];
    endTime=peroid[1];
    
    [self jiesuoBtn:nil];
}

-(IBAction)jiesuoBtn:(id)sender
{
    //    self.AppCountLabel.text=[NSString stringWithFormat:@"当前已锁网应用:  个"];
    
    self.AppCountLabel.hidden = YES;
    
    self.myTableView.hidden =YES;
    self.jiesuoView.hidden =NO;
    self.jiasuoView.hidden = YES;
    self.dianImage.frame = CGRectMake(78, 161, 12, 6);
    self.savePoint.frame = CGRectMake(25, 139, 16, 16);
    pdsw = YES;
    
    //更新数据
    [self getUserAgentLock];
    
}

-(IBAction)jiasuoBtn:(id)sender
{
    //    self.AppCountLabel_1.text = [NSString stringWithFormat:@"当前可锁网应用:  个"];
    
    self.AppCountLabel_1.hidden = YES;
    
    self.myTableView.hidden =YES;
    self.jiesuoView.hidden = YES;
    self.jiasuoView.hidden = NO;
    self.dianImage.frame = CGRectMake(235, 161, 12, 6);
    self.savePoint.frame = CGRectMake(174, 139, 16, 16);
    pdsw = NO;
    
    [datasArray removeAllObjects];
    
    //更新数据
    [self getAccessData];
}

-(void)getCanLockNum
{
    //从数据库中加载数据加载 月份用了的所有数据
    StageStats *currentStats = [StatsMonthDAO statForPeriod:startTime endTime:endTime];
    
    //如果有数据，就去查询它的详细数据
    if ( currentStats.bytesBefore > 0 ) {
        NSArray* arr = [StatsMonthDAO userAgentStatsForPeriod:startTime endTime:endTime orderby:nil];
        NSArray* tempArr = [arr sortedArrayUsingSelector:@selector(compareByPercent:)];
        
        for (int i=0;i<[tempArr count]; i++)
        {
            
            StatsDetail* topStats = [tempArr objectAtIndex:i];
            UserAgentLock *agentLock=  [UserAgentLockDAO getUserAgentLock:[topStats.uaStr trim]];
            
            if(!agentLock.isLock)
            {
                if(![[topStats.uaStr trim] isEqualToString:@"Mozilla"])
                {
                    canLock ++;
                }
            }
            
        }
    }
    [self.kesuoBtn setTitle:[NSString stringWithFormat:@"可锁应用(%d)",canLock] forState:UIControlStateNormal];
}

-(void)changeLockNum
{
    [self.kesuoBtn setTitle:[NSString stringWithFormat:@"可锁应用(%d)",canLock] forState:UIControlStateNormal];
}

-(void)paixuWithTime:(NSDictionary *)dictionary
{
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableArray *arr1 = [NSMutableArray array];
    NSArray *keys = [dictionary allKeys] ;
    for (NSString *str in keys) {
        UserAgentLock *ua =[dictionary objectForKey:str];
        if (ua.timeLengh != 0) {
            [arr addObject:ua];
        }else{
            [arr1 addObject:ua];
        }
    }
    [arr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        UserAgentLock *us1 = obj1;
        
        UserAgentLock *us2 = obj2;
        
        if (us1.timeLengh > us2.timeLengh) {
            
            return (NSComparisonResult)NSOrderedDescending;
            
        }
        
        return (NSComparisonResult)NSOrderedSame;
    }];
    if (arr && arr1 ) {
        [allLockArr setArray:arr];
        [allLockArr addObjectsFromArray:arr1];
    }
}

-(void)loadtableViewWithjiesuo
{
    self.allLockDic = [UserAgentLockDAO getAllLockedApps];
    
    [self paixuWithTime:allLockDic];
    
    int count=[self.allLockDic count];
    self.AppCountLabel.text=[NSString stringWithFormat:@"当前已锁网应用: %d 个",count];
    
    self.AppCountLabel.hidden = NO;
    
    self.myTableView.hidden = NO;
    
    [self.myTableView reloadData];
}


-(void)loadtableViewWithjiasuo
{
    self.AppCountLabel_1.text = [NSString stringWithFormat:@"当前可锁网应用: %d 个",[datasArray count]];
    [self.myTableView reloadData];
    
    self.AppCountLabel_1.hidden = NO;
    
    self.myTableView.hidden = NO;
}

#pragma mark - 查询已锁应用
- (void) getUserAgentLock
{
    if ( twitterClient ) return;
    [[AppDelegate getAppDelegate] showLockView:@"正在更新数据..."];
    NSString* url = [NSString stringWithFormat:@"%@/%@.json?appid=%d",
                     API_BASE, API_SETTING_UA_ALL_ENABLED,2];
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(didGetUserAgentLock:obj:)];
    url = [TwitterClient composeURLVerifyCode:url];
    [twitterClient get:url];
}

- (void) didGetUserAgentLock:(TwitterClient*)tc obj:(NSObject*)obj
{
    twitterClient = nil;
    [[AppDelegate getAppDelegate] hideLockView];
    
    if ( !obj && ![obj isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary*dic=(NSDictionary*) obj;
    
    NSArray *array=[dic allKeys];
    
    for(int i=0;i<[array count];i++)
    {
        NSDictionary *lockDic=[dic objectForKey:[array objectAtIndex:i]];
        
        int lock = [[lockDic objectForKey:@"lk"] intValue];
        long timeLength = [[lockDic objectForKey:@"lkt"] intValue];
        NSString*agName=[[lockDic objectForKey:@"nm"] trim];//需要等待服务器重启后的信息 2013-02-26
        UserAgentLock* agentLock = [[[UserAgentLock alloc] init] autorelease];
        agentLock.isLock = lock;
        agentLock.userAgent=[[array objectAtIndex:i] trim] ;
        agentLock.appName=agName;
        
        if ( lock )
        {
            
            time_t now;
            time( &now );
            if ( timeLength == 0 ) {
                agentLock.timeLengh = 0;
            }
            else {
                agentLock.timeLengh = timeLength * 60;
            }
            
        }
        
        [UserAgentLockDAO updateUserAgentLock:agentLock];
        
        //更新完数据库后要更新下可锁应用的数字
        canLock = 0;
        [self getCanLockNum];
        
    }
    [self loadtableViewWithjiesuo ];
}

-(NSString *)dateInFormat:(long)dateTime
{
    int dd= 60*60*60*24;
    int hh=60 *60*60;
    int mm=60*60;
    
    int cDay=dateTime/dd;
    int HH=(dateTime-dd*cDay)/60/60/60;
    int MM=(dateTime-dd*cDay-HH*hh)/mm;
    
    return [NSString  stringWithFormat:@"%d天%d小时%d分",cDay,HH,MM];
}

-(void)initDetail:(UILabel*)label index:(int)indexs
{
    time_t now;
    time(&now);

    UserAgentLock *userAgentLock = (UserAgentLock*)[allLockArr objectAtIndex:indexs];
    long cha=userAgentLock.timeLengh;
    NSString *str=[NSString stringWithFormat:@"剩余解锁时间 : %@",[self dateInFormat:cha]];
    if(userAgentLock.timeLengh==0)
    {
        str=[NSString stringWithFormat:@"该应用已永久锁网(需手动开启)"];
    }
    label.text=str;
    
}

-(IBAction)oneUnlockBtnPress:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    int tags = btn.tag;
    if (tags == 1100) {
        [self unlockButtonClick];
    }else if (tags == 1001){
        [self lockButtonClick];
    }
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

-(IBAction)turnBrnPress:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshAppLockedNotification object:nil];
    [[sysdelegate navController  ] popViewControllerAnimated:YES];
    
}
-(IBAction)refleshPress:(id)sender
{
    if (pdsw) {
        [self jiesuoBtn:nil];
    }else{
        [self jiasuoBtn:nil];
    }
}


#pragma mark - UIActionSheetDelegate
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

#pragma mark : 查询没有锁网的应用
- (void) getAccessData
{
    [TCUtils readIfData:-1];
    
    [[AppDelegate getAppDelegate] showLockView:@"正在更新数据..."];
    
    if ( twitterClient ) {
        //[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.3f];
        return;
    }
    
    AppDelegate* app = [AppDelegate getAppDelegate];
    if ( [app.networkReachablity currentReachabilityStatus] == NotReachable ) {
        //   [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.3f];
        return;
    }
    
    //？？
    if ( ![[AppDelegate getAppDelegate].refreshingLock tryLock] ) {
        // [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.3f];
        return;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    time_t lastDayLong = [AppDelegate getLastAccessLogTime];
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(didGetAccessData:obj:)];
    twitterClient.context = [NSNumber numberWithLong:lastDayLong];
    [twitterClient getAccessData];
}

- (void) didGetAccessData:(TwitterClient*)client obj:(NSObject*)obj
{
    
    [[AppDelegate getAppDelegate] hideLockView];
    
    twitterClient = nil;
    
    NSNumber* num = client.context;
    time_t t = [num longValue];
    
    if ( client.hasError ) {
        [[AppDelegate getAppDelegate].refreshingLock unlock]; //开锁
        [AppDelegate showAlert:client.errorMessage];
        return;
    }
    
    //解析数据写到数据库（调用这个方法是查询今天的数据的）；
    BOOL hasData = [TwitterClient procecssAccessData:obj time:t]; //今天的数据为空
    [[AppDelegate getAppDelegate].refreshingLock unlock];
    
    if ( hasData ) {
        //从数据库中加载数据
        [self loadNotData];
    }
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    if ( user.ifLastTime == 0 ) {
        //  [TCUtils readIfData:self.currentStats.bytesAfter];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}

-(void)loadNotData
{
    StageStats *currentStats = [StatsMonthDAO statForPeriod:startTime endTime:endTime];
    
    if ( currentStats.bytesBefore > 0 ) {
        NSArray* arr = [StatsMonthDAO userAgentStatsForPeriod:startTime endTime:endTime orderby:nil];
        NSArray* tempArr = [arr sortedArrayUsingSelector:@selector(compareByPercent:)];
        
        for (int i=0;i<[tempArr count]; i++)
        {
            
            StatsDetail* topStats = [tempArr objectAtIndex:i];
            UserAgentLock *agentLock = [UserAgentLockDAO getUserAgentLock:[topStats.uaStr trim]];
            
            if(!agentLock.isLock)
            {
                if(![[topStats.uaStr trim] isEqualToString:@"Mozilla"])
                {
                    [ self.datasArray addObject:topStats];
                }
            }
            
        }
    }
    
    [self.myTableView reloadData];
    [self loadtableViewWithjiasuo];
}


-(void)hiddenLoadingViewWithjiesuo
{
    
    [AppDelegate showAlert:@"已恢复应用的网络连接！"];
    
}

-(void)hiddenLoadingViewWithjiasuo
{
    
    [AppDelegate showAlert:@"已锁定应用的网络连接！"];
    
}

#pragma mark - 锁网 和 解锁 的alertView 提示
- (void) unlockButtonClick
{
    if ( twitterClient ) return;
    
    NSDictionary* dic = [UserAgentLockDAO getAllLockedApps];
    if ( [dic count] == 0 ) {
        [AppDelegate showAlert:@"当前没有已经锁网的应用！"];
        return;
    }
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:[NSString stringWithFormat:@"您已经锁网了%d个应用。确定要将这些应用解锁吗？", [dic count]]
                                                       delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 1010;
    [alertView show];
    [alertView release];
    
}

-(void) lockButtonClick
{
    if ( twitterClient ) return;
    
    if ( [datasArray count] == 0 || !datasArray ) {
        [AppDelegate showAlert:@"当前没有可以锁网的应用！"];
        return;
    }
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:[NSString stringWithFormat:@"您可以锁网%d个应用。确定要将这些应用锁网吗？", [datasArray count]]
                                                       delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 0101;
    [alertView show];
    [alertView release];
    

}

#pragma mark - alertViewDelegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 1 ) //如果点击的是确定
    {
        if (alertView.tag == 1010) { //一键解锁
            [self unlockAllApps];

        }else if (alertView.tag == 0101){ //一键加锁
            
            [self lockAllApps];
            
        }
    }
}

#pragma mark - 解锁单个应用
-(void)unlockButtonPress:(UIButton*)button
{
    int indexs=button.tag- AGENT_BUTTON_TAG;
    
    [self disableUserAgentNetwork:0 lockMinutes:0 usStrIndex:indexs];
    
}

- (void) disableUserAgentNetwork:(int)isLock lockMinutes:(int)minutes usStrIndex:(int)uaStrIndex
{
    if ( twitterClient ) return;
    
//    NSArray *dataArray=[self.allLockDic allKeys];
    index=uaStrIndex;
//    UserAgentLock*agentLock=(UserAgentLock*)[self.allLockDic objectForKey:[dataArray objectAtIndex:uaStrIndex]];
    
    UserAgentLock *agentLock = (UserAgentLock*)[allLockArr objectAtIndex:uaStrIndex];
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    NSString* url = [NSString stringWithFormat:@"%@/%@.json?misc=%@&lock=%d&locktime=%d&host=%@&port=%d",
                     API_BASE, API_SETTING_DISABLEUA,
                     [agentLock.userAgent encodeAsURIComponent], isLock, minutes, user.proxyServer, user.proxyPort];
    [[AppDelegate getAppDelegate] showLockView:@"正在为您解锁..."];
    
    
    url = [TwitterClient composeURLVerifyCode:url];
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(didUnlockApp:obj:)];
    [twitterClient get:url];
}

- (void) didUnlockApp:(TwitterClient*)tc obj:(NSObject*)obj
{
    twitterClient = nil;
    NSArray *dataArray=[self.allLockDic allKeys];
    
    UserAgentLock *agentLock=(UserAgentLock*)[self.allLockDic objectForKey:[dataArray objectAtIndex:index]];
    [[AppDelegate getAppDelegate] hideLockView];
    
    if ( tc.hasError ) {
        [AppDelegate showAlert:@"抱歉，网络访问失败"];
    }
    
    NSDictionary* dic = (NSDictionary*) obj;
    if ( !obj && ![obj isKindOfClass:[NSDictionary class]] )
    {
        [AppDelegate showAlert:@"抱歉，操作失败"];
    }
    
    NSNumber* number = (NSNumber*) [dic objectForKey:@"code"];
    int code = [number intValue];
    if ( code == 200 )
    {
        
        //更新可锁应用个数
        canLock ++;
        [self changeLockNum];
        
        time_t now;
        time( &now );
        agentLock.isLock = 0;
        agentLock.resumeTime = now;
        [[AppDelegate getAppDelegate] hideLockView];
        
        [UserAgentLockDAO updateUserAgentLock:agentLock];
        [self loadtableViewWithjiesuo];
        [self performSelector:@selector(hiddenLoadingViewWithjiesuo) withObject:nil afterDelay:0.3f];
                
    }
    else
    {
        [AppDelegate showAlert:@"抱歉，操作失败"];
    }
}

#pragma mark - 解锁所有应用
- (void) unlockAllApps
{
    if ( twitterClient ) return;
    
    if ([[UserAgentLockDAO getAllLockedApps] count] == 0) {
        [AppDelegate showAlert:@"目前没有可解锁的应用哦。"];
        return;
    }
    
    if ( ![AppDelegate networkReachable] ) {
        [AppDelegate showAlert:@"抱歉，网络访问失败!"];
        return;
    }
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    NSString* url = [NSString stringWithFormat:@"%@/%@.json?host=%@&port=%d",
                     API_BASE, API_SETTING_RESETUA,
                     user.proxyServer, user.proxyPort];
    url = [TwitterClient composeURLVerifyCode:url];
    [[AppDelegate getAppDelegate] showLockView:@"正在为您解锁..."];
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(didUnlockAllApps:obj:)];
    [twitterClient get:url];
}
- (void) didUnlockAllApps:(TwitterClient*)tc obj:(NSObject*)obj
{
    twitterClient = nil;
    [[AppDelegate getAppDelegate] hideLockView];
    
    if ( tc.hasError ) {
        [AppDelegate showAlert:@"抱歉，网络访问失败"];
        return;
    }
    
    if ( !obj || ![obj isKindOfClass:[NSDictionary class]] ) return;
    
    NSDictionary* dic = (NSDictionary*) obj;
    if ( [dic objectForKey:@"code"] && [dic objectForKey:@"code"] != [NSNull null] ) {
        int code = [[dic objectForKey:@"code"] intValue];
        if ( code == 200 ) {
            
            //更新可锁应用数
            canLock += [allLockArr count];
            [self changeLockNum];
            
            [UserAgentLockDAO deleteAll];
            //            NSLog(@"userAgetDAo===%@",[UserAgentLockDAO getAllLockedApps]);
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshAppLockedNotification object:nil];
            [self performSelector:@selector(hiddenLoadingViewWithjiesuo) withObject:nil afterDelay:0.3f];
            [self loadtableViewWithjiesuo];
            return;
        }
    }
    
    [AppDelegate showAlert:@"抱歉，操作失败!"];
}

#pragma mark - 锁网单个应用
-(void)lockButtonPress:(UIButton*)button
{
    int tag = button.tag - AGENT_BUTTON_TAG;
    lockCell = tag;
    StatsDetail *s = [datasArray objectAtIndex:tag];
    NSString *title = [NSString stringWithFormat:@"请选择 %@ 的锁网时长", s.userAgent ];
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"2小时",@"8小时",@"当月",@"永久(手动开启)", nil];
    [sheet showInView:self.navigationController.view];
    [sheet release];
}

- (void) disableUserAgentNetwork:(int)isLock lockMinutes:(int)minutes
{
    UserSettings* user = [AppDelegate getAppDelegate].user;
    StatsDetail *s = [datasArray objectAtIndex:lockCell];
    NSString* url = [NSString stringWithFormat:@"%@/%@.json?misc=%@&lock=%d&locktime=%d&host=%@&port=%d",
                     API_BASE, API_SETTING_DISABLEUA,
                     [[s.uaStr trim] encodeAsURIComponent], isLock, minutes, user.proxyServer, user.proxyPort];
    
    [[AppDelegate getAppDelegate] showLockView:@"正在为您锁网..."];
    
    url = [TwitterClient composeURLVerifyCode:url];
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(didlockApp:obj:)];
    [twitterClient get:url];
}

- (void) didlockApp:(TwitterClient*)tc obj:(NSObject*)obj
{
    twitterClient = nil;
    
    [[AppDelegate getAppDelegate] hideLockView];
    
    if ( tc.hasError ) {
        [AppDelegate showAlert:@"抱歉，网络访问失败"];
    }
    
    if ( !obj || ![obj isKindOfClass:[NSDictionary class]] ) return;
    
    NSDictionary* dic = (NSDictionary*) obj;
    
    if ( [dic objectForKey:@"code"] && [dic objectForKey:@"code"] != [NSNull null] ) {
        int code = [[dic objectForKey:@"code"] intValue];
        if ( code == 200 ) {
            
            canLock -- ;
            //更新可锁应用
            [self changeLockNum];
            
            time_t now;
            
            time( &now );
            
            for(int i=0;i<[datasArray count];i++)
            {
                StatsDetail* topStats = [self.datasArray objectAtIndex:i];
                UserAgentLock*agentLock = [[[UserAgentLock alloc] init] autorelease];
                agentLock.userAgent = [topStats.uaStr trim];
                agentLock.appName=topStats.userAgent;
                agentLock.isLock = 1;
                agentLock.lockTime = now;
                agentLock.timeLengh = 0;
                [UserAgentLockDAO updateUserAgentLock:agentLock];
            }
            [datasArray removeObjectAtIndex:lockCell];
            [self loadtableViewWithjiasuo];
            [self performSelector:@selector(hiddenLoadingViewWithjiasuo) withObject:nil afterDelay:0.3f];
            return;
        }
        
        [AppDelegate showAlert:@"抱歉，操作失败"];
        
    }
    
}

#pragma mark - 锁网所有应用
-(void)lockAllApps
{
    
    if (twitterClient) {
        return;
    }
    
    if([self.datasArray count]==0)
    {
        [AppDelegate showAlert:@"没有可锁网的应用了哦。"];
        return;
    }
    if ( ![AppDelegate networkReachable] ) {
        [AppDelegate showAlert:@"抱歉，网络访问失败!"];
        return;
    }
    
    NSString*dicStr=@"";
    
    [[AppDelegate getAppDelegate] showLockView:@"正在为您锁网..."];
    
    for(int i=0;i<[datasArray count];i++)
    {
        StatsDetail* topStats = [self.datasArray objectAtIndex:i];
        NSString* Str=[topStats.uaStr trim];
        
        if(i==[datasArray count]-1)
        {
            dicStr=[dicStr stringByAppendingFormat:@"%@%@%@",@"\"",Str,@"\""];
        }
        else
        {
            dicStr=[dicStr stringByAppendingFormat:@"%@%@%@,",@"\"",Str,@"\""];
        }
    }
    dicStr=[NSString stringWithFormat:@"[%@]",dicStr];
    dicStr=[dicStr  encodeAsURIComponent];
    
    NSString* url = [NSString stringWithFormat:@"%@/%@.json?misc=%@",
                     API_BASE, API_SETTING_DISABLEUAS,
                     dicStr];
    url = [TwitterClient composeURLVerifyCode:url];
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(didlockAllApps:obj:)];
    [twitterClient get:url];
}
- (void) didlockAllApps:(TwitterClient*)tc obj:(NSObject*)obj
{
    twitterClient = nil;
    
    [[AppDelegate getAppDelegate] hideLockView];
    
    if ( tc.hasError ) {
        [AppDelegate showAlert:@"抱歉，网络访问失败"];
    }
    
    if ( !obj || ![obj isKindOfClass:[NSDictionary class]] ) return;
    
    NSDictionary* dic = (NSDictionary*) obj;
    
    if ( [dic objectForKey:@"code"] && [dic objectForKey:@"code"] != [NSNull null] ) {
        int code = [[dic objectForKey:@"code"] intValue];
        if ( code == 200 ) {
            
            //更新可锁应用数
            canLock = 0 ;
            [self changeLockNum];
            
            time_t now;
            
            time( &now );
            
            for(int i=0;i<[datasArray count];i++)
            {
                StatsDetail* topStats = [self.datasArray objectAtIndex:i];
                UserAgentLock*agentLock = [[[UserAgentLock alloc] init] autorelease];
                agentLock.userAgent = [topStats.uaStr trim];
                agentLock.appName=topStats.userAgent;
                agentLock.isLock = 1;
                agentLock.lockTime = now;
                agentLock.timeLengh = 0;
                [UserAgentLockDAO updateUserAgentLock:agentLock];
            }
            [datasArray removeAllObjects];
            [self loadtableViewWithjiasuo];
            [self performSelector:@selector(hiddenLoadingViewWithjiasuo) withObject:nil afterDelay:0.3f];
            return;
        }
        
        [AppDelegate showAlert:@"抱歉，操作失败"];
        
    }
}

#pragma mark - UITableViewDelegate or set
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (pdsw) {
        return [allLockArr  count];
    }else{
        return [datasArray count];
    }
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62.0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (pdsw) {
        return [self jiesuoTableViewCellWithTable:tableView andRows:indexPath.row];
    }else{
        return [self jiasuoTableViewCellWithTable:tableView andRows:indexPath.row];
    }
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

-(UITableViewCell *)jiesuoTableViewCellWithTable:(UITableView *)tableView andRows:(int )rows
{
    static NSString *CellIdentifier = @"jiasuCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.backgroundColor=[UIColor grayColor];
    }
    
    for ( UIView* v in cell.contentView.subviews )
    {
        [v removeFromSuperview];
    }
    
    UILabel *nameLabel=[[[UILabel alloc]init] autorelease];
    nameLabel.textAlignment=UITextAlignmentLeft;
    nameLabel.textColor=[UIColor darkGrayColor];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    nameLabel.frame=CGRectMake(24, 16, 250, 21);
    nameLabel.font=[UIFont systemFontOfSize:17.0];
    [self initAgentName:nameLabel index:rows];
    
    UILabel *detailLabel=[[[UILabel alloc]init] autorelease];
    detailLabel.frame=CGRectMake(25, 34, 260, 21);
    detailLabel.textAlignment=UITextAlignmentLeft;
    detailLabel.textColor=[UIColor darkGrayColor];
    detailLabel.font=[UIFont systemFontOfSize:11.0];
    [detailLabel setBackgroundColor:[UIColor clearColor]];
    [self initDetail:detailLabel index:rows];
    
    UIImageView *lineImageView=[[[UIImageView alloc]init] autorelease];
    lineImageView.frame=CGRectMake(0, 61, 320, 1);
    lineImageView.image=[UIImage imageNamed:@"henxian.png"];
    
    UIImage *image=[UIImage imageNamed:@"graypoint.png"];
    UIImageView *imageView=[[[UIImageView alloc]initWithFrame:CGRectMake(18, 24, image.size.width/2, image.size.height/2)] autorelease];
    imageView.image=image;
    
    UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(263, 18, 49, 28);
    button.tag=AGENT_BUTTON_TAG+rows;
    UIImage *image1=[UIImage imageNamed:@"unlock_bg.png"];
    image1=[image1 stretchableImageWithLeftCapWidth:image1.size.width/2 topCapHeight:image1.size.height/2];
    [button setBackgroundImage:image1 forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[button titleLabel] setFont:[UIFont systemFontOfSize:13.0]];
    [button setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
    [AppDelegate buttonTopShadow:button shadowColor:[UIColor grayColor]];
    [button setTitle:@"解锁" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(unlockButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.contentView addSubview:button];
    [cell.contentView addSubview:imageView];
    [cell.contentView addSubview:nameLabel];
    [cell.contentView addSubview:detailLabel];
    [cell.contentView addSubview:lineImageView];
    
    return cell;
}

-(void)initAgentName:(UILabel*)label index:(int)indexs
{
    if (pdsw) {
//        NSArray *dataArray = [self.allLockDic allKeys];
//
//        UserAgentLock*userAgentLock=(UserAgentLock*)[self.allLockDic objectForKey:[dataArray objectAtIndex:indexs]];
        UserAgentLock *userAgentLock = (UserAgentLock*)[self.allLockArr objectAtIndex:indexs];
        label.text=userAgentLock.appName;
        
    }else{
        StatsDetail *StatsDetail = [datasArray objectAtIndex:indexs];
        label.text = StatsDetail.userAgent;
    }
}

-(UITableViewCell *)jiasuoTableViewCellWithTable:(UITableView *)tableView andRows:(int )rows
{
    static NSString *CellIdentifier = @"jiesuCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.backgroundColor=[UIColor grayColor];
    }
    
    for ( UIView* v in cell.contentView.subviews )
    {
        [v removeFromSuperview];
    }
    
    UILabel *nameLabel=[[[UILabel alloc]init] autorelease];
    nameLabel.textAlignment=UITextAlignmentLeft;
    nameLabel.textColor=[UIColor darkGrayColor];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    nameLabel.frame=CGRectMake(24, 18, 250, 21);
    nameLabel.font=[UIFont systemFontOfSize:20.0];
    [self initAgentName:nameLabel index:rows];
    
    UIImageView *lineImageView=[[[UIImageView alloc]init] autorelease];
    lineImageView.frame=CGRectMake(0, 61, 320, 1);
    lineImageView.image=[UIImage imageNamed:@"henxian.png"];
    
    UIImage *image=[UIImage imageNamed:@"graypoint.png"];
    UIImageView *imageView=[[[UIImageView alloc]initWithFrame:CGRectMake(18, 26, image.size.width/2, image.size.height/2)] autorelease];
    imageView.image=image;
    
    UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(263, 16, 49, 28);
    button.tag=AGENT_BUTTON_TAG+rows;
    UIImage *image1=[UIImage imageNamed:@"unlock_bg.png"];
    image1=[image1 stretchableImageWithLeftCapWidth:image1.size.width/2 topCapHeight:image1.size.height/2];
    [button setBackgroundImage:image1 forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[button titleLabel] setFont:[UIFont systemFontOfSize:13.0]];
    [button setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
    [AppDelegate buttonTopShadow:button shadowColor:[UIColor grayColor]];
    [button setTitle:@"锁网" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(lockButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.contentView addSubview:button];
    [cell.contentView addSubview:imageView];
    [cell.contentView addSubview:nameLabel];
    [cell.contentView addSubview:lineImageView];
    
    return cell;
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

