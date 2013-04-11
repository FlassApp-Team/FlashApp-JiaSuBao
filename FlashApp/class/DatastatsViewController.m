//
//  DatastatsViewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-18.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//
#define kNumberOfPages 50
#import <QuartzCore/QuartzCore.h>

#import "DatastatsViewController.h"
#import "MonthSliderViewController.h"
#import "DatastatsDetailViewController.h"
#import "ShareWeiBoViewController.h"
#import "DataListViewController.h"
#import "StatsMonthDAO.h"


#import "StatsDayDAO.h"
#import "DateUtils.h"
#import "StringUtil.h"
#import "UIImageUtil.h"
#import "JSON.h"
#import "OpenUDID.h"
#import "TCUtils.h"
#import "ShareToSNSViewController.h"
@interface DatastatsViewController ()
-(void)initscrollview;
- (void) loadData;
- (void)loadScrollViewWithPage:(int)page _userAgent:(NSMutableArray*)userAgentArray _StageStats:(StageStats*)stageStats;
- (void) monthSliderPrev;
- (NSData*) captureScreen;
- (UIImage*) captureScreenImage;
@end

@implementation DatastatsViewController
@synthesize turnBtn;
@synthesize refleshBtn;

@synthesize shareBtn;
@synthesize userAgentStats;
@synthesize monthSliderViewController;
@synthesize backView;
@synthesize shareWeiBoViewController;
@synthesize scrollView;

@synthesize dataArray;
@synthesize controllerArray;

@synthesize currentStats;
@synthesize prevMonthStats;
@synthesize nextMonthStats;
@synthesize startTime;
@synthesize endTime;
@synthesize savaLabel;
@synthesize jiasuLabel;

@synthesize savePoint;
@synthesize saveTriangle;

@synthesize shareArray;

//这个变量是用来标记scrollView的页面的，是第几个页面。 用这个来取shareArray 里面最高的节省的应用。用于分享
static int shareArrayPage ;

-(void)dealloc
{
    
    self.saveTriangle=nil;
    self.savePoint=nil;
    
    self.savaLabel=nil;
    self.jiasuLabel=nil;
    self.currentStats=nil;
    self.nextMonthStats=nil;
    self.prevMonthStats=nil;
    
    self.scrollView=nil;
    self.shareBtn=nil;
    self.refleshBtn=nil;
    self.turnBtn=nil;
    
    self.userAgentStats=nil;
    
    self.monthSliderViewController=nil;
    self.backView=nil;
    
    self.dataArray=nil;
    self.shareWeiBoViewController=nil;
    
    self.controllerArray=nil;
    
    self.shareArray = nil;
    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    currentPage = 0;
    
    self.userAgentStats=[[[NSMutableArray alloc]init] autorelease];
    [self.navigationController setNavigationBarHidden:YES];
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
    
    self.controllerArray=[[[NSMutableArray alloc] init] autorelease];
    self.dataArray=[[[NSMutableArray alloc] initWithCapacity:3] autorelease];
    self.dataArray=[NSMutableArray arrayWithObjects:@"1",@"2",@"3", nil];
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    self.scrollView.delegate = self;
    
    UIImage* img1=[UIImage imageNamed:@"opaque_small.png"];
    img1=[img1 stretchableImageWithLeftCapWidth:img1.size.width/2 topCapHeight:img1.size.height/2];
    [self.refleshBtn setBackgroundImage:img1 forState:UIControlStateNormal];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:RefreshNotification object: nil];
    
    [self initscrollview];
    
    twitterClient = nil;
    time_t now;
    time(&now);
    time_t peroid[2];
    [TCUtils getPeriodOfTcMonth:peroid time:now];
    startTime = peroid[0];
    endTime = peroid[1];
    
    //更新数据
    [self loadData];
    
    if(self.monthSliderViewController==nil)
    {
        self.monthSliderViewController=[[[MonthSliderViewController alloc]init] autorelease];
        self.monthSliderViewController.superScrollView=self.scrollView;
        [self.backView addSubview:self.monthSliderViewController.view];
        self.monthSliderViewController.view.frame=CGRectMake(0.0, 45, 35, 57);
    }
    
    if(self.currentStats)
    {
        [self loadScrollViewWithPage:currentPage _userAgent:userAgentStats _StageStats:self.currentStats];
        [self.monthSliderViewController loadScrollViewWithPage:currentPage _StageStats:self.currentStats];
    }
    
    if ( prevMonthStats.bytesAfter > 0 ) //上个月节省后的流量 大于 0 说明有上个月
    {
        NSArray* arr = [StatsMonthDAO userAgentStatsForPeriod: self.prevMonthStats.startTime endTime:self.prevMonthStats.endTime orderby:nil];
        NSArray* tempArr = [arr sortedArrayUsingSelector:@selector(compareByPercent:)];
        NSMutableArray *array=[NSMutableArray arrayWithArray:tempArr];
        currentPage = currentPage+1;
        [self loadScrollViewWithPage:currentPage _userAgent:array _StageStats:self.prevMonthStats];
        [self.monthSliderViewController loadScrollViewWithPage:currentPage _StageStats:self.prevMonthStats];
    }
    
}

-(void)initscrollview
{
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < kNumberOfPages; i++)
    {
		[controllers addObject:[NSNull null]];
    }
    self.controllerArray = controllers;
    [controllers release];
}

#pragma mark - load data

- (void) loadData
{
    [userAgentStats removeAllObjects];
    
    //本月/上月/下月/节省的流量
    self.currentStats = [StatsMonthDAO statForPeriod:startTime endTime:endTime];
    
    //获取第一次访问的时间
    time_t firstDay = [StatsDayDAO getfirstDay];
    
    time_t now;
    time( &now );
    
    time_t prevPeroid[2];
    [TCUtils getPeriodOfTcMonth:prevPeroid time:startTime - 1]; //开始的时间 - 1 就变成了上个月的最后一天 从上个月的 天 可以得到上个月的 开始和结束时间， 在prevPeroid 数组里面，
    if (prevPeroid[1] < firstDay) { //上个月的最后一天要小于开始时间，说明没有用够一个月，那么prevMonthStats就是空的
        self.prevMonthStats = nil;
    }
    else {
        self.prevMonthStats = [StatsMonthDAO statForPeriod:prevPeroid[0] endTime:prevPeroid[1]];
        if ( !prevMonthStats ) {
            prevMonthStats = [[StageStats alloc] init];
            prevMonthStats.startTime = prevPeroid[0];
            prevMonthStats.endTime = prevPeroid[1];
        }
    }
    
    time_t nextPeroid[2];
    [TCUtils getPeriodOfTcMonth:nextPeroid time:endTime + 1];
    if ( nextPeroid[0] <= now ) { //下个月的时间如果大于或者等于现在的时间呢，那就是现在的最后一天
        self.nextMonthStats = [StatsMonthDAO statForPeriod:nextPeroid[0] endTime:nextPeroid[1]];
        if ( !nextMonthStats ) {
            nextMonthStats = [[StageStats alloc] init];
            nextMonthStats.startTime = nextPeroid[0];
            nextMonthStats.endTime = nextPeroid[1];
        }
    }
    else {
        self.nextMonthStats = nil;
    }
    
//    //本月流量详情
    if (currentStats.bytesBefore > 0 ) {
        NSArray* arr = [StatsMonthDAO userAgentStatsForPeriod:startTime endTime:endTime orderby:nil];
        NSArray* tempArr = [arr sortedArrayUsingSelector:@selector(compareByBefore:)];
        [userAgentStats addObjectsFromArray:tempArr];
    }
}

- (void)loadScrollViewWithPage:(int)page _userAgent:(NSMutableArray*)userAgentArray _StageStats:(StageStats*)stageStats
{
    if (page < 0)
        return;
    if (page >= kNumberOfPages)
        return;
    
    if(!stageStats)
    {
        return;
    }
    
    if(stageStats.bytesBefore>0)
    {
        [self.shareBtn setHidden:NO]; //分享按钮显示
    }
    else
    {
        [self.shareBtn setHidden:YES];
    }
        
    
    DataListViewController *dataListViewController = [self.controllerArray objectAtIndex:page];
    if ((NSNull *)dataListViewController == [NSNull null])
    {
        dataListViewController = [[DataListViewController alloc] init];//初始化
        [self.controllerArray replaceObjectAtIndex:page withObject:dataListViewController]; //array 里面替代的方法 指定一个位置 替代为要替换的对象
        [dataListViewController release];
    }
    
    // add the controller's view to the scroll view
    if (dataListViewController.view.superview == nil)
    {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        dataListViewController.view.frame = frame;
        [scrollView addSubview:dataListViewController.view];
        dataListViewController.currentStats=stageStats;
        self.monthSliderViewController.currentStats=stageStats;
        dataListViewController.userAgentArray=userAgentArray;
        dataListViewController.startTime=stageStats.startTime;
        dataListViewController.endTime=stageStats.endTime;
        dataListViewController.viewcontroller=self;
        [dataListViewController reloadData];
    }
        
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * (page+1), scrollView.frame.size.height);
}


#pragma mark -- ScrollViewDelegate 
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    return;
}

// 调用以下函数，来自动滚动到想要的位置，此过程中设置有动画效果，停止时，触发该函数
// UIScrollView的setContentOffset:animated:
// UIScrollView的scrollRectToVisible:animated:
// UITableView的scrollToRowAtIndexPath:atScrollPosition:animated:
// UITableView的selectRowAtIndexPath:animated:scrollPosition:
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    shareArrayPage = page;
    
//    self.mondleDataListViewController = (DataListViewController *)[self.controllerArray objectAtIndex:page];
    page=page+1;
    
    if(currentPage<page)
    {
        currentPage=page;
        [self monthSliderPrev];
        
    }
    else if(currentPage>page)
    {
//        currentPage=page;
//        [self monthSliderNext];
        return;
        
    }
    else
    {
//        [self monthSliderNow];
        return;
    }
    
}



// 滚动停止时，触发该函数
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView               //"触摸滑动事件
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    id dataListViewController = [self.controllerArray objectAtIndex:page];
    if([dataListViewController class]==[DataListViewController class])
    {
        DataListViewController*da=(DataListViewController*)dataListViewController;
        [da  monthSaveBtnPress:da.monthSaveBtn];
    }
    
    shareArrayPage = page;
    
    page=page+1;
    
    if(currentPage<page)
    {
        currentPage=page;
        
        [self monthSliderPrev];
        
    }
    else if(currentPage>page)
    {
//        currentPage = page;
//        [self monthSliderNext];
        
//        return;
        
    }
    else
    {
//        currentPage = page;
//          [self monthSliderNow];
//        return;
        
    }
}

// 触摸屏幕来滚动画面还是其他的方法使得画面滚动，皆触发该函数
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float superXX=self.scrollView.contentOffset.x/self.scrollView.bounds.size.width;
    float subXX=superXX*self.monthSliderViewController.scrollview.bounds.size.width;
    
    self.monthSliderViewController.scrollview.contentOffset=CGPointMake(subXX, 0);
}

//上一个月的流量
- (void) monthSliderPrev
{
    
    if ( prevMonthStats.bytesAfter>0 ) {
        self.startTime = self.prevMonthStats.startTime;
        self.endTime = self.prevMonthStats.endTime;
        [self loadData];
        NSArray* arr = [StatsMonthDAO userAgentStatsForPeriod:self.prevMonthStats.startTime endTime:self.prevMonthStats.endTime orderby:nil];
        NSArray* tempArr = [arr sortedArrayUsingSelector:@selector(compareByPercent:)];
        NSMutableArray*array=[NSMutableArray arrayWithArray:tempArr];
        [self loadScrollViewWithPage:currentPage  _userAgent:array _StageStats:self.prevMonthStats];
        [self.monthSliderViewController loadScrollViewWithPage:currentPage _StageStats:self.prevMonthStats ];
        
    }
}

- (void) monthSliderNext
{
    if ( nextMonthStats ) {
        
        self.startTime = nextMonthStats.startTime;
        self.endTime = nextMonthStats.endTime;
        [self loadData];
        NSArray* arr = [StatsMonthDAO userAgentStatsForPeriod:self.nextMonthStats.startTime endTime:self.nextMonthStats.endTime orderby:nil];
        NSArray* tempArr = [arr sortedArrayUsingSelector:@selector(compareByPercent:)];
        NSMutableArray*array=[NSMutableArray arrayWithArray:tempArr];
        [self loadScrollViewWithPage:currentPage  _userAgent:array _StageStats:self.nextMonthStats];
        [self.monthSliderViewController loadScrollViewWithPage:currentPage _StageStats:self.nextMonthStats ];
    }
}

#pragma mark -- 
- (void) getAccessData
{
    [TCUtils readIfData:-1];
    
    if ( twitterClient ) {
        //[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.3f];
        return;
    }
    
    AppDelegate* app = [AppDelegate getAppDelegate];
    if ( [app.networkReachablity currentReachabilityStatus] == NotReachable ) {
        //   [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.3f];
        return;
    }
    
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
    twitterClient = nil;
    
    NSNumber* num = client.context;
    time_t t = [num longValue];
    
    if ( client.hasError ) {
        [[AppDelegate getAppDelegate].refreshingLock unlock];
        //  [self doneLoadingTableViewData];
        [AppDelegate showAlert:client.errorMessage];
        return;
    }
    
    BOOL hasData = [TwitterClient procecssAccessData:obj time:t];
    [[AppDelegate getAppDelegate].refreshingLock unlock];
    if ( hasData ) {
        //从数据库中加载数据
        // [self loadData];
        
        //显示数据
        //  [self show];
    }
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    if ( user.ifLastTime == 0 ) {
        [TCUtils readIfData:self.currentStats.bytesAfter];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // [_refreshHeaderView refreshLastUpdatedDate];
    // [self doneLoadingTableViewData];
}


#pragma mark -- UIButton
-(IBAction)turnBrnPress:(id)sender
{
    [[sysdelegate navController  ] popViewControllerAnimated:YES];
}

-(IBAction)refleshBtnPress:(id)sender
{
    // [self getAccessData];//add 2013-01-31
    ConnectionType type = [UIDevice connectionType];
    if(type==NONE)
    {
        [AppDelegate showAlert:@"提示信息" message:@"网络连接异常,请链接网络"];
        return;
    }
    [self relodaTableViewDate];
    
}

-(void)relodaTableViewDate
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    id dataListViewController = [self.controllerArray objectAtIndex:page];
    if([dataListViewController class]==[DataListViewController class])
    {
        DataListViewController*da=(DataListViewController*)dataListViewController;
        [da  getAccessData];
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

#pragma mark - Share To
- (void) shareToSNS:(NSString*)sns
{
    
    if ( !currentStats || !shareArray || [shareArray count] == 0 ) return;
    if (shareArrayPage >= [shareArray count]) {
        return; //如果 存放月份里面节省最多的流量app的array 它的长度 小于或者等于 页数那么不对防止崩溃，所以退出
    }
    
    for (int i = 0 ; i < [shareArray count]; i ++) {
        NSLog(@"shareArray name = %@",[[shareArray objectAtIndex: i] userAgent]);
    }
    
    StatsDetail* topStats = [shareArray objectAtIndex:shareArrayPage];
    NSString* deviceId = [OpenUDID value];
    NSString* date = [DateUtils stringWithDateFormat:currentStats.startTime format:@"yyyy-MM"];
    
    //带百分比的分享话语暂时不用
//    NSString* content = [NSString stringWithFormat:@"#%@用加速宝#我正在使用加速宝，本月已经节省了%@，实际使用%@，压缩总比例为%.1f%%，其中%@压缩比例高达%.1f%%，加速宝流量，省钱，快速。 下载地址：http://jiasu.flashapp.cn/social/%@.html %@", date,
//                         [NSString stringForByteNumber:(currentStats.bytesBefore - currentStats.bytesAfter)],
//                         [NSString stringForByteNumber:currentStats.bytesAfter],
//                         ((float) (currentStats.bytesBefore - currentStats.bytesAfter)) / currentStats.bytesBefore * 100,
//                         [topStats.userAgent compare:@"未知"] == NSOrderedSame ? @"最高" : topStats.userAgent,
//                         ((float)(topStats.before - topStats.after)) / topStats.before * 100,
//                         deviceId,@"(@飞速流量压缩仪)"];
    //content = @"Very Good!";

    NSString* content = [NSString stringWithFormat:@"#%@用加速宝#节省了%@，%@节省达到%@，网速慢？流量少？就用加速宝。免费下载：http://jiasu.flashapp.cn/social/%@.html %@",         date,[NSString stringForByteNumber:(currentStats.bytesBefore - currentStats.bytesAfter)],
                         [topStats.userAgent compare:@"未知"] == NSOrderedSame ? @"最高" : topStats.userAgent,
                         [NSString stringForByteNumber:(topStats.before - topStats.after)],
                         deviceId,@"(@飞速流量压缩仪)"];
    
    NSData* image = [self captureScreen];
    
    ShareToSNSViewController * controller = [[ShareToSNSViewController alloc] init];
    controller.sns = sns;
    controller.content = content;
    controller.image = image;
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [[[AppDelegate getAppDelegate] navController] presentModalViewController:nav animated:YES];
    [controller release];
    [nav release];
}

- (void) sendWeixinImage
{
    if([WXApi isWXAppInstalled ])
    {
        //发送内容给微信
        UIImage* image = [self captureScreenImage];
        UIImage* thumbImage = [[image getSubImage:CGRectMake(0, 0, 320, 416)] scaleImage:0.3];
        WXMediaMessage *message = [WXMediaMessage message];
        [message setThumbImage:thumbImage];
        
        WXImageObject *ext = [WXImageObject object];
        NSData* imageData = UIImageJPEGRepresentation( image, 0.6 );
        ext.imageData = imageData;
        
        message.mediaObject = ext;
        
        SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
        req.bText = NO;
        req.message = message;
        enum WXScene scene = WXSceneSession;
        req.scene = scene;
        
        [WXApi sendReq:req];
        
    }
    else
    {
        UIAlertView *alertView=[[[UIAlertView alloc]initWithTitle:@"提示信息" message:@"未安装微信客户端,请选择其他分享方式，或者下载微信客户端" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]autorelease ];
        [alertView show];
    }
}

- (UIImage*) captureScreenImage
{
    UIGraphicsBeginImageContext( self.view.bounds.size );
    
    //renderInContext 呈现接受者及其子范围到指定的上下文
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    //返回一个基于当前图形上下文的图片
    UIImage *aImage =UIGraphicsGetImageFromCurrentImageContext();
    
    //移除栈顶的基于当前位图的图形上下文
    UIGraphicsEndImageContext();
    //UIImageWriteToSavedPhotosAlbum(aImage, nil, nil, nil);
    return aImage;
}

- (NSData*) captureScreen
{
    UIImage* aImage = [self captureScreenImage];
    
    //以png格式返回指定图片的数据
    NSData* imageData = UIImageJPEGRepresentation( aImage, 0.8 );
    return imageData;
    
}


#pragma mark - MonthSlider Delegate
- (NSNumber*) hasPrevMonth
{
    if ( prevMonthStats ) {
        return [NSNumber numberWithInt:1];
    }
    else {
        return [NSNumber numberWithInt:0];
    }
}

- (NSNumber*) hasNextMonth
{
    if ( nextMonthStats ) {
        return [NSNumber numberWithInt:1];
    }
    else {
        return [NSNumber numberWithInt:0];
    }
}


- (void) monthSliderNow
{
    time_t now;
    time( &now );
    time_t peroid[2];
    [TCUtils getPeriodOfTcMonth:peroid time:now];
    
    self.startTime = peroid[0];
    self.endTime = peroid[1];
    [self loadData];
    // [self.scrollView setContentOffset:CGPointMake(0, 0)];
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
