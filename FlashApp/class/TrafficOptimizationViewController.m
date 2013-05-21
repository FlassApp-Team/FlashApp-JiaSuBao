//
//  TrafficOptimizationViewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-20.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//
#define TAOCAN_HEAD_IMAGE  101
#define TAOCAN_LABEL 102
#define TAOCAN_DETAIL_LABEL 103

#define IMAGEQUALITY_HEAD_IMAGE 201
#define IMAGEQUALITY_LABEL 202
#define IMAGEQUALITY_DETAIL_LABEL 203
#define IMAGEQUALITY_SETTING_BUTTON 204


#define  STATUBAR_LABEL 301
#define  STATUBAR_BUTTON 302
#define  STATUBAR_DE_BUTTON 303

#define  USER_ANENT_IMAGE 401
#define  USER_ANENT_LABEL 402
#define  USER_ANENT_DETAIL_LABEL 403
#define  USER_ANENT_BUTTON 404
#define  USER_ANENT_SUGGEST_LABEL 405

#define  HENXIAN_LINE  5000

#import "TrafficOptimizationViewController.h"
#import "YouHuaModleViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FlowJiaoZhunViewController.h"
#import "ShareWeiBoViewController.h"
#import "TCUtils.h"
#import "StatsMonthDAO.h"
#import "DateUtils.h"
#import "StringUtil.h"
#import "UserAgentLockDAO.h"
#import "UserAgentLock.h"
#import "cnvUILabel.h"
#import "OpenUDID.h"
#import "UserAgentLockDAO.h"
#import "ImageCompressViewController.h"
@interface TrafficOptimizationViewController ()
- (void) getAccessData;
-(void)initView;
-(UITableViewCell*)tableView:(UITableView *)tableView taoCanCellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(UITableViewCell*)tableView:(UITableView *)tableView statusBarCellForRowAtIndexPat:(NSIndexPath *)indexPath;
-(UITableViewCell*)tableView:(UITableView *)tableView imageQualityCellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(UITableViewCell*)tableView:(UITableView *)tableView userAgentCellForRowAtIndexPat:(NSIndexPath *)indexPath;
-(void)selectCell:(UITableView*)tableView selectIndex:(NSIndexPath*)indexPath;
-(void)deSelectCell:(UITableView*)tableView selectIndex:(NSIndexPath*)indexPath;
-(void)unAllLockApp;
-(void)saveDataTODefault:(NSString*)count jiesheng:(long long)jieshengC;
-(void)loadData;
@end

@implementation TrafficOptimizationViewController
@synthesize myTableView;
@synthesize dataArray;
@synthesize youhuaBtn;
@synthesize shareBtn;
@synthesize relfleshBtn;
@synthesize shareWeiBoViewController;
@synthesize messageLabel;
@synthesize cellArray;
@synthesize controller;
-(void)dealloc
{
    self.controller=nil;
    if ( twitterClient ) {
        [twitterClient cancel];
        [twitterClient release];
        twitterClient = nil;
    }
    
    self.cellArray=nil;
    self.messageLabel=nil;
    self.shareWeiBoViewController=nil;
    self.relfleshBtn=nil;
    self.shareBtn=nil;
    self.myTableView=nil;
    self.dataArray=nil;
    self.youhuaBtn=nil;
    [super dealloc];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self loadData ];
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
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(IBAction )relfleshBtnPress:(id )sender
{
    [self getAccessData];
    
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
-(IBAction)turnBack:(id)sender
{
    YouHuaModleViewController*youHuaModleViewController=(YouHuaModleViewController*)self.controller;
    [youHuaModleViewController showMessage];
    [[sysdelegate navController  ] popToViewController:[[sysdelegate navController  ].viewControllers objectAtIndex:([[sysdelegate navController  ].viewControllers count] -3)] animated:YES];
    //  NSLog(@"AAAAAAAAAAAAA%@",[sysdelegate navController  ].viewControllers);
    //[[sysdelegate navController  ] popViewControllerAnimated:NO];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cellArray=[[[NSMutableArray alloc]init] autorelease];
    UIImage* img1=[UIImage imageNamed:@"opaque_small.png"];
    img1=[img1 stretchableImageWithLeftCapWidth:7 topCapHeight:8];
    
    [self.relfleshBtn setBackgroundImage:img1 forState:UIControlStateNormal];
    
    UIImage* img=[UIImage imageNamed:@"unlock_btn_bg"];
    img=[img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:0];
    [self.youhuaBtn setBackgroundImage:img forState:UIControlStateNormal];
    [AppDelegate labelShadow:self.youhuaBtn.titleLabel];
    
    self.dataArray=[[[NSMutableArray alloc]init]autorelease];
    twitterClient = nil;
    
    loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(95, 150, 130, 100)];
    loadingView.message = NSLocalizedString(@"set.accountView.loading.message", nil);
    loadingView.hidden = YES;
    [self.view addSubview:loadingView];
    [loadingView release];
    
    [self getAccessData];
}
-(void)loadData
{
    time_t now;
    time(&now);
    time_t peroid[2];
    jieshengCount=0;

    [self.dataArray removeAllObjects];
    [self.cellArray removeAllObjects];
    [TCUtils getPeriodOfTcMonth:peroid time:now];
    long startTime=peroid[0];
    long endTime=peroid[1];
    StageStats*currentStats = [StatsMonthDAO statForPeriod:startTime endTime:endTime];
     
    if ( currentStats.bytesBefore > 0 ) {
        NSArray* arr = [StatsMonthDAO userAgentStatsForPeriod:startTime endTime:endTime orderby:nil];
        NSArray* tempArr = [arr sortedArrayUsingSelector:@selector(compareByPercent:)];

        for (int i=0;i<[tempArr count]; i++)
        {
            
            StatsDetail* topStats = [tempArr objectAtIndex:i];
            UserAgentLock*agentLock=  [UserAgentLockDAO getUserAgentLock:[topStats.uaStr trim]];

            if(!agentLock.isLock)
            {
                if(![[topStats.uaStr trim] isEqualToString:@"Mozilla"])
                {
                    [ self.dataArray addObject:topStats];
                }


            }

            
        }
    }
    
    //NSLog(@"self.data===%@",self.dataArray);
    [self.myTableView reloadData];

    [self initView];
    //默认全选状态
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:2];
    UITableViewCell *cell = [self.myTableView cellForRowAtIndexPath:path];
    
    UIButton*selectButton=(UIButton*)[cell viewWithTag:STATUBAR_BUTTON];
    [self selectAll:selectButton];
    //////////
    //显示数据
    //  [self show];
}



#pragma mark - refresh data
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
        [self loadData];

    }
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    if ( user.ifLastTime == 0 ) {
        //  [TCUtils readIfData:self.currentStats.bytesAfter];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // [_refreshHeaderView refreshLastUpdatedDate];
    // [self doneLoadingTableViewData];
}


-(void)initView
{
    NSString *str=nil;
    UserSettings* user = [AppDelegate getAppDelegate].user;
    
    long byte=[user.ctUsed longLongValue];
    str = [NSString stringForByteNumber:byte decimal:1];
    self.messageLabel.text=[NSString stringWithFormat:@"本月已用%@",str ];
}

#pragma mark - inti TableView
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    if ( section == 0 ) {
       return [self tableView:tableView taoCanCellForRowAtIndexPath:indexPath];
    }
    else if ( section == 1 ) {
       return [self tableView:tableView imageQualityCellForRowAtIndexPath:indexPath];
    }
    else if ( section == 2 ) {
       return  [self tableView:tableView statusBarCellForRowAtIndexPat:indexPath];
    }
    else if(section == 3)
    {
       return [self tableView:tableView userAgentCellForRowAtIndexPat:indexPath];
    }
    return nil;
}
-(UITableViewCell*)tableView:(UITableView *)tableView statusBarCellForRowAtIndexPat:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @" statusBarCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.backgroundColor=[UIColor grayColor];

        cnvUILabel *detailLabel=[[[cnvUILabel alloc]init] autorelease];
        detailLabel.frame=CGRectMake(8, 7, 231, 21);
        detailLabel.textAlignment=UITextAlignmentLeft;
       // detailLabel.textColor=BgTextColor;
        detailLabel.font=[UIFont systemFontOfSize:12.0];
        [detailLabel setBackgroundColor:[UIColor clearColor]];
        detailLabel.tag=STATUBAR_LABEL;
        [detailLabel cnv_setUIlabelTextColor:BgTextColor  andKeyWordColor:[UIColor colorWithRed:255.0/255 green:152.0/255 blue:30.0/255 alpha:1.0] ];

        
        UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(246, 5, 67, 25);
        button.tag=STATUBAR_BUTTON;
        [button setTitleColor:BgTextColor forState:UIControlStateNormal];
        [[button titleLabel] setFont:[UIFont systemFontOfSize:10.0]];
        [button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[button titleLabel]setShadowOffset:CGSizeMake(0, -1)];
        [button addTarget:self action:@selector(selectAll:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton*button1=[UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame=CGRectMake(246, 5, 67, 25);
        button1.tag=STATUBAR_DE_BUTTON;
        [button1 setTitleColor:BgTextColor forState:UIControlStateNormal];
        [[button1 titleLabel] setFont:[UIFont systemFontOfSize:10.0]];
        [button1 setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[button1 titleLabel]setShadowOffset:CGSizeMake(0, -1)];
        [button1 addTarget:self action:@selector(deSelectAll:) forControlEvents:UIControlEventTouchUpInside];
        [button1 setHidden:YES];
        
        
        [cell.contentView addSubview:button1];
        [cell.contentView addSubview:button];
        [cell.contentView addSubview:detailLabel];
        
        UIImageView *lineImageView=[[[UIImageView alloc]init] autorelease];
        lineImageView.frame=CGRectMake(0, 35, 320, 1);
        
        lineImageView.tag=HENXIAN_LINE;
        [cell.contentView addSubview:lineImageView];
        
    }
    UIImageView*lineImage=(UIImageView*)[cell.contentView viewWithTag:HENXIAN_LINE];
    lineImage.image=[UIImage imageNamed:@"henxian.png"];

    NSString *keyStr=nil;
    NSString *str=nil;
    
    
    cnvUILabel*detailLabel=(cnvUILabel*)[cell.contentView viewWithTag:STATUBAR_LABEL];
    NSString *averageStr = [NSString stringForByteNumber:jieshengCount*30 decimal:1];
    keyStr=[NSString stringWithFormat:@"%d",[self.cellArray count]];
    str=[NSString stringWithFormat:@"可优化 %@ 个应用,预计最高可节省%@",keyStr,averageStr];

    if(![self.dataArray count])
    {
        NSUserDefaults*userDefault=[NSUserDefaults standardUserDefaults];
        int count=[[userDefault objectForKey:@"youhuaAPPCount"] intValue];
        keyStr=[NSString stringWithFormat:@"%d",count];
        long long jieshengC=[[userDefault objectForKey:@"jieshengCount"] longLongValue];
        averageStr = [NSString stringForByteNumber:jieshengC decimal:1];
        str=[NSString stringWithFormat:@"已优化 %@ 个应用,预计最高可节省%@",keyStr,averageStr];

    }
//    [self saveDataTODefault:[NSString stringWithFormat:@"%d",[self.dataArray count]] jiesheng:jieshengCount*30];
    [detailLabel cnv_setUILabelText: str  andKeyWord:keyStr];


    UIButton*button=(UIButton*)[cell.contentView viewWithTag:STATUBAR_BUTTON];
    UIButton*button1=(UIButton*)[cell.contentView viewWithTag:STATUBAR_DE_BUTTON];
    if([self.dataArray count]!=0)
    {
        [button setHidden:YES];
        [button1 setHidden:NO];
        UIImage*image=[UIImage imageNamed:@"jiaozhun_select.png"];
        image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setTitle:@"全选" forState:UIControlStateNormal];
        
        [button1 setTitle:@"取消全选" forState:UIControlStateNormal];
        [button1 setBackgroundImage:image forState:UIControlStateNormal];
    }
    else
    {
        [button setHidden:YES];
        [button1 setHidden:YES];

    }
    return cell;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView taoCanCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"taoCanCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.backgroundColor=[UIColor grayColor];
        
        UIImageView *imageView=[[[UIImageView alloc]initWithFrame:CGRectMake(8, 20, 14, 13)] autorelease];
        imageView.tag=TAOCAN_HEAD_IMAGE;
        
        
        UILabel *taoCanLabel=[[[UILabel alloc]init] autorelease];
        taoCanLabel.frame=CGRectMake(30, 14, 270, 26);
        taoCanLabel.textAlignment=UITextAlignmentLeft;
        taoCanLabel.textColor=BgTextColor;
        taoCanLabel.tag=TAOCAN_LABEL;
        taoCanLabel.font=[UIFont systemFontOfSize:14.0];
        [taoCanLabel setBackgroundColor:[UIColor clearColor]];
        

        
        
        UIImageView *lineImageView=[[[UIImageView alloc]init] autorelease];
        
        lineImageView.frame=CGRectMake(0, 54, 320, 1);
        lineImageView.tag=5002;
   
        
        [cell.contentView addSubview:imageView];
        [cell.contentView addSubview:taoCanLabel];
        [cell.contentView addSubview:lineImageView];
    }
    
    UIImageView*lineImage=(UIImageView*)[cell.contentView viewWithTag:5002];
    lineImage.image=[UIImage imageNamed:@"henxian.png"];
    
    
    UILabel*taoCanLabel=(UILabel*)[cell.contentView viewWithTag:TAOCAN_LABEL];
    UserSettings* user = [AppDelegate getAppDelegate].user;
    NSString* curTotal = user.ctTotal;
    UIImageView*imageView=(UIImageView*)[cell.contentView viewWithTag:TAOCAN_HEAD_IMAGE];
    if ( !curTotal || curTotal.length == 0 ) {
        taoCanLabel.text=@"未设置套餐流量,点击校准";
        imageView.image=[UIImage imageNamed:@"taohao.jpg"];
    }
    else
    {
        NSString*totalStr=[NSString stringWithFormat:@"套餐流量:%@MB",curTotal];
        taoCanLabel.text=totalStr;
        imageView.image=nil;
    }
    return cell;
    
    
    //    StatsDetail* topStats = [self.dataArray objectAtIndex:[indexPath row]];
    //    UserAgentLock*agentLock = [UserAgentLockDAO getUserAgentLock:topStats.userAgent];
    //
    
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView imageQualityCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"imageQualityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.backgroundColor=[UIColor grayColor];
        
        
        
        UILabel *imageQualityLabel=[[[UILabel alloc]init] autorelease];
        imageQualityLabel.frame=CGRectMake(30, 6, 200, 26);
        imageQualityLabel.textAlignment=UITextAlignmentLeft;
        imageQualityLabel.textColor=BgTextColor;
        imageQualityLabel.tag=IMAGEQUALITY_LABEL;
        imageQualityLabel.font=[UIFont systemFontOfSize:14.0];
        [imageQualityLabel setBackgroundColor:[UIColor clearColor]];
        
        UILabel *detailLabel=[[[UILabel alloc]init] autorelease];
        detailLabel.frame=CGRectMake(29, 26, 231, 21);
        detailLabel.textAlignment=UITextAlignmentLeft;
        detailLabel.textColor=[UIColor darkGrayColor];
        detailLabel.font=[UIFont systemFontOfSize:12.0];
        [detailLabel setBackgroundColor:[UIColor clearColor]];
        detailLabel.tag=IMAGEQUALITY_DETAIL_LABEL;
        
        
        UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(266, 12, 48, 29);
        button.tag=IMAGEQUALITY_SETTING_BUTTON;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[button titleLabel] setFont:[UIFont systemFontOfSize:12.0]];
        [button setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
        [[button titleLabel]setShadowOffset:CGSizeMake(0, -1)];
        [button addTarget:self action:@selector(setting:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *lineImageView=[[[UIImageView alloc]init] autorelease];
        
        lineImageView.frame=CGRectMake(0, 54, 320, 1);
        lineImageView.tag=5003;
        
        [cell.contentView addSubview:button];
        [cell.contentView addSubview:imageQualityLabel];
        [cell.contentView addSubview:detailLabel];
        [cell.contentView addSubview:lineImageView];

    }
    UIImageView*lineImage=(UIImageView*)[cell.contentView viewWithTag:5003];
    lineImage.image=[UIImage imageNamed:@"henxian.png"];
    
    UILabel*taoCanLabel=(UILabel*)[cell.contentView viewWithTag:IMAGEQUALITY_LABEL];
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    NSString*qualityStr=nil;
    UILabel*detailLabel=(UILabel*)[cell.contentView viewWithTag:IMAGEQUALITY_DETAIL_LABEL];
    detailLabel.text=@"流量使用频率过大,调节图片质量节省更多!";

    if ( user.pictureQsLevel == PIC_ZL_MIDDLE ) {
        qualityStr=@"中";
        qualityStr=[NSString stringWithFormat:@"图片压缩质量:%@",qualityStr];

    }
    else if ( user.pictureQsLevel == PIC_ZL_HIGH ) {
        qualityStr=@"高";
        qualityStr=[NSString stringWithFormat:@"图片压缩质量:%@",qualityStr];

        
    }
    else if ( user.pictureQsLevel == PIC_ZL_NOCOMPRESS ) {
        qualityStr=@"不压缩";
        detailLabel.text=@"调节图片质量,可节省更多";
        qualityStr=[NSString stringWithFormat:@"图片无压缩,无法节省流量"];

        
    }
    else if ( user.pictureQsLevel == PIC_ZL_LOW ) {
        qualityStr=@"低";
        qualityStr=[NSString stringWithFormat:@"图片压缩质量:%@",qualityStr];

        
    }
    
    taoCanLabel.text=qualityStr;
    
     
    UIButton*button=(UIButton*)[cell.contentView viewWithTag:IMAGEQUALITY_SETTING_BUTTON];
    UIImage *image1=[UIImage imageNamed:@"unlock_bg.png"];
    image1=[image1 stretchableImageWithLeftCapWidth:image1.size.width/2 topCapHeight:image1.size.height/2];
    [button setBackgroundImage:image1 forState:UIControlStateNormal];
    [button setTitle:@"设置" forState:UIControlStateNormal];
    
    return cell;
    
    
    //    StatsDetail* topStats = [self.dataArray objectAtIndex:[indexPath row]];
    //    UserAgentLock*agentLock = [UserAgentLockDAO getUserAgentLock:topStats.userAgent];
}
-(UITableViewCell*)tableView:(UITableView *)tableView userAgentCellForRowAtIndexPat:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"userAgentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.backgroundColor=[UIColor grayColor];
        
        UIImageView *imageView=[[[UIImageView alloc]initWithFrame:CGRectMake(8, 25, 14, 14)] autorelease];
        imageView.tag=USER_ANENT_IMAGE;
        
        UILabel *userAgentLabel=[[[UILabel alloc]init] autorelease];
        userAgentLabel.frame=CGRectMake(30, 12, 132, 26);
        userAgentLabel.textAlignment=UITextAlignmentLeft;
        userAgentLabel.textColor=BgTextColor;
        userAgentLabel.tag=USER_ANENT_LABEL;
        userAgentLabel.font=[UIFont systemFontOfSize:16.0];
        [userAgentLabel setBackgroundColor:[UIColor clearColor]];
        
        UILabel *detailLabel=[[[UILabel alloc]init] autorelease];
        detailLabel.frame=CGRectMake(30, 32, 132, 21);
        detailLabel.textAlignment=UITextAlignmentLeft;
        detailLabel.textColor=BgTextColor;
        detailLabel.font=[UIFont systemFontOfSize:12.0];
        [detailLabel setBackgroundColor:[UIColor clearColor]];
        detailLabel.tag=USER_ANENT_DETAIL_LABEL;
        
        
        UILabel *suggestLabel=[[[UILabel alloc]init] autorelease];
        //157
        suggestLabel.frame=CGRectMake(160, 21, 140, 21);
        suggestLabel.textAlignment=UITextAlignmentRight;
        suggestLabel.textColor=BgTextColor;
        suggestLabel.font=[UIFont systemFontOfSize:14.0];
        [suggestLabel setBackgroundColor:[UIColor clearColor]];
        suggestLabel.tag=USER_ANENT_SUGGEST_LABEL;
        
        
        UIImageView *lineImageView=[[[UIImageView alloc]init] autorelease];
        lineImageView.frame=CGRectMake(0, 61, 320, 1);
        lineImageView.tag=5004;
        

        [cell.contentView addSubview:imageView];
        [cell.contentView addSubview:userAgentLabel];
        [cell.contentView addSubview:detailLabel];
        [cell.contentView addSubview:suggestLabel];
        [cell.contentView addSubview:lineImageView];

    }
    UIImageView*lineImage=(UIImageView*)[cell.contentView viewWithTag:5004];
    lineImage.image=[UIImage imageNamed:@"henxian.png"];

    
    cell.tag=[indexPath row];
    
    StatsDetail* topStats = [self.dataArray objectAtIndex:[indexPath row]];
    
    time_t now;
    time(&now);
    int currentDay = [[DateUtils stringWithDateFormat:now format:@"dd"] intValue];
    int jiesunDay=[[UserSettings  currentUserSettings].ctDay intValue];
    int cha=currentDay-jiesunDay;
    long long count=topStats.after /cha;
    NSString *averageStr = [NSString stringForByteNumber:count decimal:1];
    
    UIImage *image=nil;
    UIImageView*titleImageView=(UIImageView*)[cell.contentView viewWithTag:USER_ANENT_IMAGE];
    NSNumber *rowNsNum = [NSNumber numberWithUnsignedInt:indexPath.row];
    if ( [cellArray containsObject:rowNsNum]  )
    {
        image= [UIImage imageNamed:@"select_point.png"];
    }
    else
    {
        image= [UIImage imageNamed:@"no_select_point.png"];
    }
    
    titleImageView.image=image;
    
    UILabel*anentLabel=(UILabel*)[cell.contentView viewWithTag:USER_ANENT_LABEL];
    anentLabel.text=topStats.userAgent;
    
    UILabel*detailLabel=(UILabel*)[cell.contentView viewWithTag:USER_ANENT_DETAIL_LABEL];
    averageStr=[NSString stringWithFormat:@"日均使用%@",averageStr];
    detailLabel.text=averageStr;
    
    UILabel*suggestLabel=(UILabel*)[cell.contentView viewWithTag:USER_ANENT_SUGGEST_LABEL];
    suggestLabel.text=@"只允许wifi下联网";
    
//    
//    UIButton*button=(UIButton*)[cell.contentView viewWithTag:USER_ANENT_BUTTON];
//    UIImage *image1=[UIImage imageNamed:@"unlock_bg.png"];
//    image1=[image1 stretchableImageWithLeftCapWidth:image1.size.width/2 topCapHeight:image1.size.height/2];
//    [button setBackgroundImage:[UIImage imageNamed:@"yellow_lock.png"] forState:UIControlStateNormal];
    
    
    
    return cell;
    
}
#pragma mark- operation uitablecell


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int section = indexPath.section;
    if ( section == 0 ) {
        if([indexPath row]==0)
        {
            FlowJiaoZhunViewController*flowJiaoZhunViewController=[[[FlowJiaoZhunViewController alloc]init] autorelease];
            [[sysdelegate currentViewController].navigationController pushViewController:flowJiaoZhunViewController animated:YES];
        }
        
        
    }
    if(section==1)
    {
        
    }
    if(section==2){}
    if(section==3)
    {
        [self selectCell:tableView selectIndex:indexPath];
    }
}
-(void)setStatuBar:(NSIndexPath*)indexPath selectFlag:(BOOL)selectFlag tableView:(UITableView*)tableView
{
    NSIndexPath*tempIndexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    UITableViewCell *statueCell = [tableView cellForRowAtIndexPath:tempIndexPath];
    // NSLog(@"AAAAAAAAAAAAAAAAA%@",statueCell.contentView.subviews);
    cnvUILabel*detailLabel=(cnvUILabel*)[statueCell.contentView viewWithTag:STATUBAR_LABEL];
    NSString *str=nil;
    NSString *keyStr=nil;
    if(selectFlag)
    {
        StatsDetail* topStats = [self.dataArray objectAtIndex:[indexPath row]];
        time_t now;
        time(&now);
        int currentDay = [[DateUtils stringWithDateFormat:now format:@"dd"] intValue];
        int jiesunDay=[[UserSettings  currentUserSettings].ctDay intValue];
        int cha=currentDay-jiesunDay;
        long long count=topStats.after /cha;
        jieshengCount=jieshengCount+count;
        NSString *averageStr = [NSString stringForByteNumber:jieshengCount*30 decimal:1];
        
        keyStr=[NSString stringWithFormat:@"%d",[self.cellArray count]];
        str=[NSString stringWithFormat:@"已选择 %@ 个应用,预计最高可节省%@",keyStr,averageStr];
        
    }
    else
    {
        StatsDetail* topStats = [self.dataArray objectAtIndex:[indexPath row]];
        time_t now;
        time(&now);
        int currentDay = [[DateUtils stringWithDateFormat:now format:@"dd"] intValue];
        int jiesunDay=[[UserSettings  currentUserSettings].ctDay intValue];
        int cha=currentDay-jiesunDay;
        long long count=topStats.after /cha;
        jieshengCount=jieshengCount-count;
        if(jieshengCount<0)
            jieshengCount=0;
        NSString *averageStr = [NSString stringForByteNumber:jieshengCount*30 decimal:1];
        
        keyStr=[NSString stringWithFormat:@"%d",[self.cellArray count]];
        str=[NSString stringWithFormat:@"已选择 %@ 个应用,预计最高可节省%@",keyStr,averageStr];

        
    }
    appFlowCount=jieshengCount*30;
    [detailLabel cnv_setUILabelText: str  andKeyWord:keyStr];
   // detailLabel.text=str;
    
}
-(void)deSelectAll:(UIButton*)button
{
    jieshengCount=0;
    [button setHidden:YES];
    UITableViewCell *tableViewCell = (UITableViewCell *)button.superview.superview;
    UIButton*selectButton=(UIButton*)[tableViewCell viewWithTag:STATUBAR_BUTTON];
    if([self.dataArray count])
    {
        [selectButton setHidden:NO];

    }
    for(int i=0;i<[self.dataArray count];i++)
    {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:3];
        [self deSelectCell:self.myTableView selectIndex:path];
    }
}
-(void)selectAll:(UIButton*)button
{
    [button setHidden:YES];
    [self.cellArray removeAllObjects];
    UITableViewCell *tableViewCell = (UITableViewCell *)button.superview.superview;
    UIButton*deSelectButton=(UIButton*)[tableViewCell viewWithTag:STATUBAR_DE_BUTTON];
    if([self.dataArray count])
    {
        [deSelectButton setHidden:NO];
        
    }
    for(int i=0;i<[self.dataArray count];i++)
    {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:3];
        [self selectCell:self.myTableView selectIndex:path];
    }
}
-(void)deSelectCell:(UITableView*)tableView selectIndex:(NSIndexPath*)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView*imageView=(UIImageView*)[cell.contentView viewWithTag:USER_ANENT_IMAGE];
    imageView.image=[UIImage imageNamed:@"no_select_point.png"];
    NSNumber *rowNsNum = [NSNumber numberWithUnsignedInt:indexPath.row];
    [self.cellArray removeObject:rowNsNum];
    [self setStatuBar:indexPath selectFlag:NO tableView:tableView];

}
-(void)selectCell:(UITableView*)tableView selectIndex:(NSIndexPath*)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView*imageView=(UIImageView*)[cell.contentView viewWithTag:USER_ANENT_IMAGE];
    imageView.image=[UIImage imageNamed:@"select_point.png"];
    NSNumber *rowNsNum = [NSNumber numberWithUnsignedInt:indexPath.row];
    if ( [cellArray containsObject:rowNsNum]  )
    {
        [self deSelectCell:tableView selectIndex:indexPath];
        //[self setStatuBar:indexPath selectFlag:NO tableView:tableView];

    }
    else
    {
        [self.cellArray addObject:rowNsNum];
        [self setStatuBar:indexPath selectFlag:YES tableView:tableView];
    }
 //   NSLog(@"select cell====%@",self.cellArray);
    
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    if ( section == 2 ) {
        return nil;
    }
    
    return indexPath;
}


#pragma mark- button click

-(void)setting:(UIButton*)button
{
    ImageCompressViewController *imageQualityViewController=[[[ImageCompressViewController alloc]init] autorelease];
    [[sysdelegate currentViewController].navigationController pushViewController:imageQualityViewController animated:YES];
}

-(void)lockButtonPress:(id)sender
{
    NSLog(@"解锁or锁网%@",self.cellArray);
    [self unAllLockApp];
    //    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"选择暂停网络连接的时间" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"2小时",@"8小时",@"当月",@"永久(手动开启)", nil];
    //    [sheet showInView:self.view];
    //    [sheet release];
    
}
-(IBAction)youhuaBtnPress:(id)sender
{
    [self unAllLockApp];
}
-(void)unAllLockApp
{
    NSString*dicStr=@"";

    if([self.dataArray count]==0)
    {
        [AppDelegate showAlert:@"已达到最佳状态"];
        return;
    }
    else if([self.cellArray count]==0)
    {
        [AppDelegate showAlert:@"请选择您要锁网的应用"];
        return;
    }
    for(int i=0;i<[cellArray count];i++)
    {
        NSNumber *rowNsNum =[self.cellArray objectAtIndex:i];
        int index=[rowNsNum intValue];
        StatsDetail* topStats = [self.dataArray objectAtIndex:index];
        NSString* Str=[topStats.uaStr trim];
      //  NSLog(@"AAAAAAAAAA===%@GGGGGG",Str);

        if(i==[cellArray count]-1)
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
    // NSLog(@"dicStr====%@",dicStr);
//    NSString* deviceId = [OpenUDID value];
//    
//    UserSettings* user = [AppDelegate getAppDelegate].user;
//    int rd = ((double) rand() / RAND_MAX) * 10000;
//    DeviceInfo* device = [DeviceInfo deviceInfoWithLocalDevice];
//    NSString* code = [[NSString stringWithFormat:@"%@%@%@%d", deviceId, CHANNEL, API_KEY, rd] md5HexDigest];
    NSString* url = [NSString stringWithFormat:@"%@/%@.json?misc=%@",
                     API_BASE, API_SETTING_DISABLEUAS,
                     dicStr];
    url = [TwitterClient composeURLVerifyCode:url];
    
    NSLog(@"url======%@",url);

    NSHTTPURLResponse* response;
    NSError* error;
    
    
    loadingView.hidden = NO;
    NSObject* obj = [TwitterClient sendSynchronousRequest:url response:&response error:&error];
    [self performSelector:@selector(hiddenLoadingView) withObject:nil afterDelay:0.3f];
    
    if ( response.statusCode == 200 )
    {
       // NSLog(@"response====%@",obj);

        if ( !obj && ![obj isKindOfClass:[NSDictionary class]] )
        {
            [AppDelegate showAlert:@"抱歉，操作失败"];
        }
        
        NSDictionary* dic = (NSDictionary*) obj;
        NSNumber* number = (NSNumber*) [dic objectForKey:@"code"];
        int code = [number intValue];
        if ( code == 200 )
        {
            time_t now;
            
            time( &now );
            // NSLog(@"DDDDDDDDDDDDDDDDD%@",[self dateInFormat:now format:@"%d.%m.%Y %H:%M:%S"]);
            for(int i=0;i<[cellArray count];i++)
            {
                NSNumber *rowNsNum =[self.cellArray objectAtIndex:i];
                int index=[rowNsNum intValue];
                StatsDetail* topStats = [self.dataArray objectAtIndex:index];
                UserAgentLock*agentLock = [[[UserAgentLock alloc] init] autorelease];
                agentLock.userAgent = [topStats.uaStr trim];
                agentLock.appName=topStats.userAgent;
                agentLock.isLock = 1;
                agentLock.lockTime = now;
                agentLock.timeLengh = 0;
                [UserAgentLockDAO updateUserAgentLock:agentLock];
            }
            int count=[self.cellArray count];
            NSString *averageStr = [NSString stringForByteNumber:jieshengCount*30 decimal:1];

            NSString*desc=[NSString stringWithFormat:@"已为您锁网%d个应用,最高可节省%@流量,可手动恢复",count,averageStr];
            appFlowCount=jieshengCount*30;
   
            [AppDelegate showAlert:desc];
            [self loadData];
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:2];
            UITableViewCell *cell = [self.myTableView cellForRowAtIndexPath:path];
            cnvUILabel*detailLabel=(cnvUILabel*)[cell.contentView viewWithTag:STATUBAR_LABEL];

            NSString*keyStr=[NSString stringWithFormat:@"%d",count];
            NSString*str=[NSString stringWithFormat:@"已优化 %@ 个应用,预计最高可节省%@",keyStr,averageStr];
            [detailLabel cnv_setUILabelText: str  andKeyWord:keyStr];

            [self saveDataTODefault:keyStr jiesheng:appFlowCount];
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshAppLockedNotification object:nil];
            //            if ( isLock )
            //            {
            //                if ( !agentLock ) {
            //                    agentLock = [[UserAgentLock alloc] init];
            //                    agentLock.userAgent = self.statsDetail.userAgent;
            //                }
            //                agentLock.isLock = 1;
            //                agentLock.lockTime = now;
            //                agentLock.timeLengh = 0;
            //                [AppDelegate showAlert:@"已经暂时停止了该应用的网络链接。"];
            //            }
            //
            //            }
            //            if ( agentLock ) {
            //                [UserAgentLockDAO updateUserAgentLock:agentLock];
            //                [self showLockStatus];
            //            }
            //  [[NSNotificationCenter defaultCenter] postNotificationName:RefreshAppLockedNotification object:nil];
        }
        else
        {
            [AppDelegate showAlert:@"抱歉，操作失败"];
        }
    }
    else {
        [AppDelegate showAlert:@"抱歉，操作失败"];
    }
    

}
-(void)saveDataTODefault:(NSString*)count jiesheng:(long long)jieshengC
{
    NSUserDefaults*userDefault=[NSUserDefaults standardUserDefaults];
    [userDefault setObject:count forKey:@"youhuaAPPCount"];
    [userDefault setObject:[NSNumber numberWithLongLong:jieshengC] forKey:@"jieshengCount"];
}
- (void) hiddenLoadingView
{
    loadingView.hidden = YES;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([self.dataArray count])
    {
        return 4;
    }
    else
        return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == 0 ) {
        return 1;
    }
    else if ( section == 1 ) {
        return 1;
    }
    else if ( section == 2 ) {
        return 1;
    }
    else if(section==3)
        return [self.dataArray count];
    return 0;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    if ( section == 0 ||section == 1) {
        return 55;
    }
    else if ( section == 2 ) {
        return 36;
    }
    else if(section==3)
    {
        return 62;
        
    }
    return 0;
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
