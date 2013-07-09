//
//  TaoCanViewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-19.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import "TaoCanViewController.h"
#import "FlowJiaoZhunViewController.h"
#import "JiaoZhunViewController.h"
#import "TCUtils.h"
#import "DateUtils.h"
#import "StatsDayDAO.h"
#import "StatsDay.h"
#import "StringUtil.h"

@interface TaoCanViewController ()
-(void)initView:(float)totalm _byte:(long long)byte;
- (void) getDataFromServer;

@end

@implementation TaoCanViewController
@synthesize turnBtn;
@synthesize jiaozhunBtn;
@synthesize shengyuDetailLabel;
@synthesize shengyuLabel;
@synthesize jiaozhunTimeLabel;
@synthesize jingduImageView;
@synthesize jingduLabel;
@synthesize titleLabel;
@synthesize jingduBgImageView;
@synthesize flowJiaoZhunViewController;
@synthesize jiaoZhunViewController;
@synthesize client;
 
@synthesize unitLabel;
@synthesize wangGeImageView;
@synthesize kuangImageView;
@synthesize lineView;
@synthesize chartUnitLabel;
@synthesize chart;
@synthesize chaDetailArray;
-(void)dealloc
{
    self.chaDetailArray=nil;
    if(self.chart)
    {
        self.chart=nil;

    }
    self.chartUnitLabel=nil;
    self.lineView=nil;
    self.wangGeImageView=nil;
    self.kuangImageView=nil;
    self.unitLabel=nil;
    [client cancel];
    [client release];
    client = nil;
    self.jiaozhunBtn=nil;
    self.jiaozhunTimeLabel=nil;
    self.jingduImageView=nil;
    self.jingduLabel=nil;
    
    self.turnBtn=nil;
    self.titleLabel=nil;
    self.jingduLabel=nil;
    self.jingduImageView=nil;
    
    self.flowJiaoZhunViewController=nil;
    self.jiaoZhunViewController=nil;
    self.jingduBgImageView=nil;
    if ( client ) {
        [client cancel];
        [client release];
        client = nil;
    }
    [super dealloc];
}
-(void)viewWillDisappear:(BOOL)animated
{
    if ( client ) {
        [client cancel];
        [client release];
        client = nil;
    }

    
    [super viewWillDisappear:YES];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
}
-(NSString *)dateInFormat:(time_t)dateTime format:(NSString*) stringFormat //time_t to string
{



    char buffer[80];

    const char *format = [stringFormat UTF8String];
    
    struct tm * timeinfo;
    
    timeinfo = localtime(&dateTime);
    
    strftime(buffer, 80, format, timeinfo);
    
    return [NSString  stringWithCString:buffer encoding:NSUTF8StringEncoding];
    
}

-(int)judgeDayOfMonth:(long long)time 
{

    int day=time/(5);
    switch (day) {
        case 0:
            return 0;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 2;
            break;
        case 3:
            return 3;
            break;
        case 4:
            return 4;
            break;
        case 5:
            return 5;
            break;
        case 6:
            return 6;
            break;
        default:
            return 7;
            break;
    }
    
}
- (void) loadData
{
    [TCUtils readIfData:-1];
    time_t now;
    time( &now );
    time_t peroid[2];
    [TCUtils getPeriodOfTcMonth:peroid time:now];

    
    NSMutableArray*detailArray =[NSMutableArray arrayWithArray:[StatsDayDAO getDayOfMonthData:peroid[0] end:peroid[1]]] ;
    for(long i=0;i<7;i++)
    {
        StatsDay*detail=[[[StatsDay alloc]init] autorelease];
        detail.accessDay=peroid[0]+60*60*24*5*i;
        detail.totalAfter=0;
        detail.totalBefore=0;
        [chaDetailArray addObject:detail];

    }
    for(int i=0;i<[detailArray count];i++)
    {
        StatsDay *statsD=[detailArray objectAtIndex:i];
        NSString  *str = @"%d";
        //    //其中sts.createdAt为time_t类型
         int time = [[self dateInFormat:statsD.accessDay format:str] intValue];
        // NSLog(@"createdAt: %@",time);
       // NSLog(@"BBBBB====%d",time/5);
        
        
        
        int index=[self judgeDayOfMonth:time];
        StatsDay *chaStatsD=[chaDetailArray objectAtIndex:index];

        chaStatsD.totalBefore=statsD.totalBefore+chaStatsD.totalBefore;
        chaStatsD.totalAfter=statsD.totalAfter+chaStatsD.totalAfter;
       // chaStatsD.accessDay=statsD.accessDay;
        
        
        [chaDetailArray removeObjectAtIndex:index];
        [chaDetailArray insertObject:chaStatsD atIndex:index];
    }
    for(int i=0;i<[chaDetailArray count];i++)
    {
        StatsDay *statsD=[chaDetailArray objectAtIndex:i];
            NSString  *str = @"%d.%m.%Y %H:%M:%S";
        //    //其中sts.createdAt为time_t类型
           // NSString  *time = [self dateInFormat:aa format:str];
           // NSLog(@"createdAt: %@",time);
        NSLog(@"detail.accessDay====%@",[self dateInFormat:statsD.accessDay format:str]);

    }
//
//    
    

    
    
    chart.userAgentData = chaDetailArray;
    long long maxBytes = 0;
    for ( StatsDay* stats in chaDetailArray ) {
        maxBytes = MAX( maxBytes, stats.totalBefore );
    }
    
    NSArray* arr1 = [NSString bytesAndUnitString:maxBytes];
    NSString* byteUnit = [[arr1 objectAtIndex:1] retain];
    self.chartUnitLabel.text = byteUnit;
    if(!self.chart)
    {
        self.chart = [[[TCStatsAPPSpeed alloc] init] autorelease];
        self.chart.linColor=[UIColor colorWithRed:0.0/255 green:191.0/255 blue:232.0/255 alpha:1.0];
        self.chart.arColor=[UIColor colorWithRed:191.0/255 green:239.0/255 blue:249.0/255 alpha:1.0];
    }
    //NSLog(@"self.lineView===%@",self.lineView);
    [self.chart renderInView:self.lineView  withTheme:nil];
    [self getDataTotalCount];
    
}
-(void)getDataTotalCount
{
    UserSettings* user = [AppDelegate getAppDelegate].user;
    NSString* total = user.ctTotal;
    NSString* used = user.ctUsed;
    NSString* day = user.ctDay;
    
    if ( !total ) {
        //读取服务器的数值
        [self getDataFromServer];
        total = [NSString stringWithFormat:@"%d", TC_TOTAL];
        day = @"1";
    }
    
    if ( !used || used.length == 0 ) {
        used = @"0.0";
    }
    else {
    }
    float tota=[total floatValue];
    long long byte=[used longLongValue];
    [self initView:tota _byte:byte];

}

- (void) getDataFromServer
{
    if ( client ) return;
    
    if ( [[AppDelegate getAppDelegate].networkReachablity currentReachabilityStatus] == NotReachable ) return;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    client = [[TwitterClient alloc] initWithTarget:self action:@selector(didGetDataFromServer:obj:)];
    [client getTaocanData:nil used:nil day:nil];
}


- (void) didGetDataFromServer:(TwitterClient*)tc obj:(NSObject*)obj
{
    client = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if ( tc.hasError ) {
        [AppDelegate showAlert:tc.errorDetail];
        return;
    }
    
    if ( !obj || ![obj isKindOfClass:[NSDictionary class]] ) return;
    
    NSDictionary* dic = (NSDictionary*)obj;
    
    NSString* day = nil;
    NSString* total = nil;
    NSString* used = nil;
    
    NSObject* oo = [dic objectForKey:@"dat"];
    if ( oo && oo != [NSNull null] ) {
        day = (NSString*) oo;
    }
    
    oo = [dic objectForKey:@"total"];
    if ( oo && oo != [NSNull null] ) {
        total = (NSString*) oo;
    }
    
    oo = [dic objectForKey:@"use"];
    if ( oo && oo != [NSNull null] ) {
        used = (NSString*) oo;
    }
    
    time_t lastUpdate = 0;
    oo = [dic objectForKey:@"lastUpdate"];
    if ( oo && oo != [NSNull null] ) {
        lastUpdate = [DateUtils timeWithDateFormat:(NSString*)oo format:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    if ( day.length == 0 ) day = nil;
    if ( total.length == 0 ) total = nil;
    if ( used.length == 0 ) used = nil;
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    long long bytes = [user getTcUsed];
    
    float totalm = (total ? [total floatValue] : TC_TOTAL);
    
    time_t peroid[2];
    time_t now;
    time( &now );
    [TCUtils getPeriodOfTcMonth:peroid time:now];
    if ( used && used.length > 0 ) {
        if ( lastUpdate >= peroid[0] && lastUpdate <= peroid[1] && [used floatValue] > bytes ) {
            bytes = [used longLongValue];
        }
    }
    
    //判断是否修改过
    NSString* curTotal = user.ctTotal;
    NSString* curUsed = user.ctUsed;
    NSString* curDay = user.ctDay;
    [self initView:totalm _byte:bytes];
    if ( !curTotal || curTotal.length == 0 ) {
        dirty = YES;
    }
    
    if ( !curDay || curDay.length == 0 ) {
        dirty = YES;
    }
    
    if ( !curUsed || curUsed.length == 0 ) {
        dirty = YES;
    }
}
-(void)initView:(float)totalm _byte:(long long)byte
{
    UserSettings* user = [AppDelegate getAppDelegate].user;
    if(user.lastUpdate)
    {
        self.jiaozhunTimeLabel.text=[NSString stringWithFormat:@"上一次校准%@",user.lastUpdate];
    }
    NSString *str=nil;
    float count=totalm- byte / 1024.0f / 1024.0f;
    self.unitLabel.text=@"MB";
    
    if(count/1000>1||count/1000<-1)
    {
        str=  [NSString stringWithFormat:@"%.2f",(totalm- byte / 1024.0f / 1024.0f)/1024.0f];
        self.unitLabel.text=@"GB";

    }
    else 
    {
         if(count/100>1||count/100<-1)
         {
             str=  [NSString stringWithFormat:@"%.0f",totalm- byte / 1024.0f / 1024.0f];

         }
        else
        {
            if(count/10>1||count/10<-1)
            {
                str=  [NSString stringWithFormat:@"%.1f",totalm- byte / 1024.0f / 1024.0f];

            }
            else
            {
                str=  [NSString stringWithFormat:@"%.2f",totalm- byte / 1024.0f / 1024.0f];

            }
            
        }
        
    }
    if(count/100<0)
    {
        [self.shengyuDetailLabel setFont:[UIFont systemFontOfSize:23.0]];
        [self.unitLabel setFont:[UIFont systemFontOfSize:12.0]];

    }
    self.shengyuDetailLabel.text=str;
    float persent= byte / 1024.0f / 1024.0f/totalm*100;
    self.jingduLabel.text=[NSString stringWithFormat:@"已用%.2f%@",persent,@"%"];
    
    UIImage* img=[UIImage imageNamed:@"liuliangtiao.png"];
    img=[img stretchableImageWithLeftCapWidth:img .size.width/2 topCapHeight:0];
    float imageWidth=byte / 1024.0f / 1024.0f/totalm*self.jingduBgImageView.frame.size.width;
    if(img.size.width>imageWidth)
    {
        imageWidth=img.size.width;
    }
    
    self.jingduImageView.frame=CGRectMake(self.jingduImageView.frame.origin.x, self.jingduImageView.frame.origin.y, imageWidth, self.jingduImageView.frame.size.height);
    if(self.jingduImageView.frame.size.width>185.0)
           self.jingduImageView.frame=CGRectMake(self.jingduImageView.frame.origin.x, self.jingduImageView.frame.origin.y, 185.0, self.jingduImageView.frame.size.height);
    
    self.jingduImageView.image=img;

    CGSize mbDataFrame = [self.shengyuDetailLabel.text sizeWithFont:self.shengyuDetailLabel.font constrainedToSize:CGSizeMake(320, 999) lineBreakMode:UILineBreakModeWordWrap];
    self.shengyuDetailLabel.frame =CGRectMake(self.shengyuDetailLabel.frame.origin.x,self.shengyuDetailLabel.frame.origin.y,mbDataFrame.width,self.shengyuDetailLabel.frame.size.height);
    
    self.unitLabel.frame=CGRectMake(self.shengyuDetailLabel.frame.origin.x+self.shengyuDetailLabel.frame.size.width, self.unitLabel.frame.origin.y, self.unitLabel.frame.size.width, self.unitLabel.frame.size.height);

    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.chaDetailArray=[[[NSMutableArray alloc]init] autorelease];
    UIImage* img1=[UIImage imageNamed:@"liuliangtiaodi.png"];
    img1=[img1 stretchableImageWithLeftCapWidth:img1.size.width/2 topCapHeight:img1.size.height/2];
    
    self.jingduBgImageView.image=img1;
    
    UIImage *image2=[UIImage imageNamed:@"white_box.png"];
    image2=[image2 stretchableImageWithLeftCapWidth:image2.size.width/2 topCapHeight:image2.size.height/2];
    self.kuangImageView.image=image2;
    
    UIImage *image=[UIImage imageNamed:@"wangge.png"];
    self.wangGeImageView.backgroundColor=[UIColor colorWithPatternImage:image] ;
    self.wangGeImageView.opaque=NO;
    self.chart = [[[TCStatsAPPSpeed alloc] init] autorelease];
    if(iPhone5)
    {
        self.lineView.frame=CGRectMake(7, 249, 306, 145);
    }
    self.chart.linColor=[UIColor colorWithRed:0.0/255 green:191.0/255 blue:232.0/255 alpha:1.0];
    self.chart.arColor=[UIColor colorWithRed:191.0/255 green:239.0/255 blue:249.0/255 alpha:1.0];
    [self loadData];

    // Do any additional setup after loading the view from its nib.
}
-(IBAction)turnBtnPress:(id)sender
{
[[sysdelegate navController  ] popViewControllerAnimated:YES];

}
-(IBAction)jiaozhunBtnPress:(id)sender
{
//    if(self.flowJiaoZhunViewController!=nil)
//    {
//        self.flowJiaoZhunViewController=nil;
//    }
//    if(self.flowJiaoZhunViewController==nil)
//    {
//        self.flowJiaoZhunViewController=[[[FlowJiaoZhunViewController alloc]init] autorelease];
//        self.flowJiaoZhunViewController.controller=self;
//        [[sysdelegate currentViewController].navigationController pushViewController:self.flowJiaoZhunViewController animated:YES];
//        
//    }
    if(self.jiaoZhunViewController!=nil)
    {
        self.jiaoZhunViewController=nil;
    }
    if(self.jiaoZhunViewController==nil)
    {
        self.jiaoZhunViewController=[[[JiaoZhunViewController alloc]init] autorelease];
        self.jiaoZhunViewController.controller=self;
        [[sysdelegate currentViewController].navigationController pushViewController:self.jiaoZhunViewController animated:YES];
        
    }

//    JiaoZhunViewController *jiaozhunViewController = [[JiaoZhunViewController alloc] init];
//    [[sysdelegate navController  ] pushViewController:jiaozhunViewController animated:YES];
//    [JiaoZhunViewController release];
    
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
