//
//  DataListViewController.m
//  FlashApp
//
//  Created by lidiansen on 13-1-6.
//  Copyright (c) 2013年 lidiansen. All rights reserved.
//

#import "DataListViewController.h"
#import "DatastatsDetailViewController.h"
#import "StatsDetail.h"
#import "StringUtil.h"
#import "DatastatsViewController.h"
#import "TCUtils.h"
#import "StatsMonthDAO.h"
#import "UserAgentLockDAO.h"
#import "UserAgentLock.h"
#import "MBProgressHUD.h"
#import "LoadMoreViewController.h"
@interface DataListViewController ()
-(UITableViewCell*)saveLiuLiang:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(UITableViewCell*)jiaSuLiuLiang:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@implementation DataListViewController
@synthesize bgView;
@synthesize myTableView;
@synthesize saveCountLabel;
@synthesize unitLabel;
@synthesize userAgentArray;
@synthesize currentStats;
@synthesize viewcontroller;

@synthesize monthSaveBtn;
@synthesize jiaSuBtn;
@synthesize currentBtn;
@synthesize jiasuAgentArray;
@synthesize jieshengAgentArray;
@synthesize dataView;
@synthesize titleLabel;
@synthesize startTime;
@synthesize endTime;

@synthesize JieShengDic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc
{
    self.titleLabel=nil;
    self.dataView=nil;
    self.jiasuAgentArray=nil;
    self.jieshengAgentArray=nil;
    self.viewcontroller=nil;
    self.monthSaveBtn=nil;
    self.currentBtn=nil;
    self.jiaSuBtn=nil;
    self.currentStats=nil;
    self.userAgentArray=nil;
    self.bgView=nil;
    self.myTableView=nil;
    self.saveCountLabel=nil;
    self.unitLabel=nil;
    
    self.JieShengDic = nil;
    
    if ( twitterClient ) {
        [twitterClient cancel];
        [twitterClient release];
        twitterClient = nil;
    }
    
    
    [super dealloc];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.myTableView.separatorColor=[UIColor clearColor];
    
    self.currentBtn=self.monthSaveBtn;
    
    [AppDelegate labelShadow:self.monthSaveBtn.titleLabel];
    [AppDelegate labelShadow:self.jiaSuBtn.titleLabel];
    // [self reloadData];
    // Do any additional setup after loading the view from its nib.
}

-(void)reloadData
{
    jiasuCount=0;
    //    float number;
    //    NSString* item1Number =nil;
    if(!self.userAgentArray)
        self.userAgentArray=[[[NSMutableArray alloc]init] autorelease];
    else
        [self.userAgentArray removeAllObjects];
    
    self.currentStats = [StatsMonthDAO statForPeriod:self.currentStats.startTime endTime:self.currentStats.endTime];
    
    if ( currentStats.bytesBefore > 0 ) {
        NSArray* arr = [StatsMonthDAO userAgentStatsForPeriod:self.currentStats.startTime endTime:self.currentStats.endTime orderby:nil];
        NSArray* tempArr = [arr sortedArrayUsingSelector:@selector(compareByAfter:)];
        [self.userAgentArray addObjectsFromArray:tempArr];
    }
    
    DatastatsViewController *controller=(DatastatsViewController*)viewcontroller;
//    if (controller.userAgentStats!=nil) {
//        [controller.userAgentStats removeAllObjects];
//    }
//    controller.userAgentStats = self.userAgentArray;
    
    if(self.currentStats.bytesBefore==0)
    {
        //[self.dataView setHidden:YES];
        [self.titleLabel setHidden:NO];
        [controller.shareBtn setHidden:YES];
        
    }
    else
    {
        [self.titleLabel setHidden:YES];
        [self.dataView setHidden:NO];
        [controller.shareBtn setHidden:NO];
    }
    if(!self.jiasuAgentArray)
    {
        self.jiasuAgentArray=[[[NSMutableArray alloc]init] autorelease];
        
        self.JieShengDic = [[[NSMutableDictionary alloc] init] autorelease];
    }
    else
    {
        [self.jiasuAgentArray removeAllObjects];
        
    }
    if(!self.jieshengAgentArray)
    {
        self.jieshengAgentArray=[[[NSMutableArray alloc]init] autorelease];
        
    }
    else
    {
        [self.jieshengAgentArray removeAllObjects];
        
    }
    
    for (int i=0;i<[self.userAgentArray count];i++)
    {
        
        StatsDetail *detail=[self.userAgentArray objectAtIndex:i];
        
        if(detail.before==detail.after)
        {
            [self.jiasuAgentArray addObject:detail];
            jiasuCount+=detail.before;
        }
        else
        {
            [self setDicWithJieSheng:detail];
//            [self.jieshengAgentArray addObject:detail];
        }
    }
    
    //节省流量 放到字典， 字典的key = 压缩前 - 压缩后  ；排序它的Key值，根据从高调地，然后放入 jieshengAgentArray 数数组里面
    if ([JieShengDic count] != 0) {
        NSArray * keys = [[JieShengDic allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            if ([obj1 integerValue] < [obj2 integerValue]) { 
                return (NSComparisonResult)NSOrderedDescending;
            }
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
//        NSLog(@"all keys %@",keys);
        for (NSString *key in keys) {
            [jieshengAgentArray addObject:[JieShengDic objectForKey:key ]];
        }
        if (controller.shareArray == nil) {
            controller.shareArray = [[[NSMutableArray alloc] init] autorelease];
        }
        
        //把每个月 节省流量 节省最多的这个应用放 array 里面。 用 scrollView 的page 值去取这个最高的，用来分享
        [controller.shareArray addObject:[jieshengAgentArray objectAtIndex:0]];
    }
    
    if(self.currentBtn==self.monthSaveBtn)
    {
        NSArray*array=[NSString bytesAndUnitString:self.currentStats.bytesBefore-self.currentStats.bytesAfter decimal:2];
        self.unitLabel.text=[array objectAtIndex:1];
        self.saveCountLabel.text=[array objectAtIndex:0];
        //         number = [NSString bytesNumberByUnit:self.currentStats.bytesBefore-self.currentStats.bytesAfter unit:@"MB"];
        //        item1Number = [NSString stringWithFormat:@"%.2f", number];
    }
    else
    {
        NSArray*array=[NSString bytesAndUnitString:jiasuCount decimal:2];
        //number=[array objectAtIndex:0];
        self.unitLabel.text=[array objectAtIndex:1];
        self.saveCountLabel.text=[array objectAtIndex:0];
        // number = [NSString bytesNumberByUnit:jiasuCount unit:@"MB"];
        //item1Number = [NSString stringWithFormat:@"%.2f", number];
    }
    //  self.saveCountLabel.text=item1Number;
    
    CGSize labFrame = [self.saveCountLabel.text sizeWithFont:self.saveCountLabel.font constrainedToSize:CGSizeMake(320, 999) lineBreakMode:UILineBreakModeWordWrap];
    self.saveCountLabel.frame =CGRectMake(self.saveCountLabel.frame.origin.x,self.saveCountLabel.frame.origin.y,labFrame.width,labFrame.height);
    self.unitLabel.frame=CGRectMake(self.saveCountLabel.frame.origin.x+self.saveCountLabel.frame.size.width+2, self.unitLabel.frame.origin.y, self.unitLabel.frame.size.width, self.unitLabel.frame.size.height);
    // NSLog(@"ffffffffffff%@",self.userAgentArray);
    
    [self.myTableView reloadData];
}

-(void)setDicWithJieSheng:(StatsDetail *)st
{
    
    long long num = st.before - st.after;
//    NSLog(@"num = %lld",num);
    [JieShengDic setObject:st forKey:[NSNumber numberWithLongLong:num]];
}


#pragma mark -getAccessData M
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
    [[AppDelegate getAppDelegate] showLockView:@"正在加载...."];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    time_t lastDayLong = [AppDelegate getLastAccessLogTime];
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(didGetAccessData:obj:)];
    twitterClient.context = [NSNumber numberWithLong:lastDayLong];
    
   // twitterClient.context = [NSArray arrayWithObjects:[NSNumber numberWithLong:lastDayLong], [NSNumber numberWithBool:no],nil];
    
    [twitterClient getAccessData];
    
    

}



- (void) didGetAccessData:(TwitterClient*)client obj:(NSObject*)obj
{
    twitterClient = nil;
    [[AppDelegate getAppDelegate] hideLockView];
    [self.userAgentArray removeAllObjects];
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
//        self.currentStats = [StatsMonthDAO statForPeriod:self.currentStats.startTime endTime:self.currentStats.endTime];
//
//        if ( currentStats.bytesBefore > 0 ) {
//            NSArray* arr = [StatsMonthDAO userAgentStatsForPeriod:self.currentStats.startTime endTime:self.currentStats.endTime orderby:nil];
//            NSArray* tempArr = [arr sortedArrayUsingSelector:@selector(compareByPercent:)];
//            [self.userAgentArray addObjectsFromArray:tempArr];
//        }
        [self reloadData];
        
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

-(IBAction)monthSaveBtnPress:(id)sender
{
    DatastatsViewController *controller=(DatastatsViewController*)viewcontroller;
    if(!self.currentStats.bytesBefore==0)
    {
        controller.shareBtn.hidden=NO;
    }
    controller.savePoint.frame=CGRectMake(25, 140, 16, 16);
    controller.saveTriangle.frame=CGRectMake(78.0, 163.0, 12.0, 6.0);
    [self.jiaSuBtn setImage:nil forState:UIControlStateNormal];
    self.currentBtn=self.monthSaveBtn;    
    
    NSArray*array=[NSString bytesAndUnitString:self.currentStats.bytesBefore-self.currentStats.bytesAfter decimal:2];
    self.unitLabel.text=[array objectAtIndex:1];
    self.saveCountLabel.text=[array objectAtIndex:0];

    [AppDelegate setLabelFrame:self.saveCountLabel label2:self.unitLabel];
    [self.myTableView reloadData];
    
}

-(IBAction)jiaSuBtnPress:(id)sender
{
    DatastatsViewController *controller=(DatastatsViewController*)viewcontroller;
    controller.shareBtn.hidden=YES;
    controller.savePoint.frame=CGRectMake(182, 140, 16, 16);
    controller.saveTriangle.frame=CGRectMake(214.0, 163.0, 12.0, 6.0);
    [self.monthSaveBtn setImage:nil forState:UIControlStateNormal];
    
    NSArray*array=[NSString bytesAndUnitString:jiasuCount decimal:2];
    //number=[array objectAtIndex:0];
    self.unitLabel.text=[array objectAtIndex:1];
    self.saveCountLabel.text=[array objectAtIndex:0];
    
    [AppDelegate setLabelFrame:self.saveCountLabel label2:self.unitLabel];
    self.currentBtn=self.jiaSuBtn;

    [self.myTableView reloadData];

//    for (int i=0;i<[self.controllerArray count] ;i++ )
//    {
//        DataListViewController *dataController=(DataListViewController*)[self.controllerArray objectAtIndex:i];
//        dataController.tableFlag=102;
//        [dataController.myTableView reloadData];
//    }
}


#pragma mark - tableView Delegate
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=nil;
    static NSString *MoreCellId = @"moreCell";
    if([indexPath row] == tableCellCount)
    {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MoreCellId];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MoreCellId] autorelease];
        }
        
        
        
        UIButton*button1=[UIButton buttonWithType:UIButtonTypeCustom];
        button1.tag=110;
        button1.frame=CGRectMake(23, 12, 274, 45);
        [button1 addTarget:self action:@selector(loadMore:) forControlEvents:UIControlEventTouchUpInside];
        [button1 setTitleColor:BgTextColor forState:UIControlStateNormal];
        [[button1 titleLabel] setFont:[UIFont systemFontOfSize:15.0]];
        [button1 setTitle:@"更多..." forState:UIControlStateNormal   ];
        UIImage*image=[UIImage imageNamed:@"loadmore.png"];
        image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:0];
        [button1 setBackgroundImage:image forState:UIControlStateNormal];
        [cell.contentView addSubview:button1];
        return cell;
        
    }
    else
    {
        if(self.currentBtn==self.monthSaveBtn)
        {
            cell= [self saveLiuLiang:tableView cellForRowAtIndexPath:indexPath];
        }
        else if(self.currentBtn==self.jiaSuBtn)
        {
            cell= [self jiaSuLiuLiang:tableView cellForRowAtIndexPath:indexPath];
        }
        return cell;
 
    }
}

-(UITableViewCell*)saveLiuLiang:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UserAgentCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            //  cell.selectionStyle=UITableViewCellSelectionStyleBlue;
            
            //        UIColor* color=[UIColor blueColor];//cell选中后的效果
            //        cell.selectedBackgroundView=[[[UIView alloc]initWithFrame:cell.frame]autorelease];
            //        cell.selectedBackgroundView.backgroundColor=color;
            
        }
        
        for ( UIView* v in cell.contentView.subviews )
        {
            [v removeFromSuperview];
        }
        
        StatsDetail *detail=[self.jieshengAgentArray objectAtIndex:[indexPath row]];
        UserAgentLock *agentLock = [UserAgentLockDAO getUserAgentLock:detail.uaStr];
        UIView *bgImageView=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 62)] autorelease];
        UIImage *image1=[UIImage imageNamed:@"jianbian.png"];
        bgImageView.backgroundColor=[UIColor colorWithPatternImage:image1] ;
        bgImageView.opaque=NO;
        [cell.contentView addSubview:bgImageView];
        
        UIImageView *lineImageView=[[[UIImageView alloc]init] autorelease];
        lineImageView.frame=CGRectMake(0, 61, 320, 1);
        lineImageView.image=[UIImage imageNamed:@"henxian.png"];
        [cell.contentView addSubview:lineImageView];
        
        UIImage *image=nil;
        CGRect rect;
        if ( agentLock && agentLock.isLock )
        {
            image=[UIImage imageNamed:@"smalllock.png"];
            rect=CGRectMake(12, 22, 8, 10);
        }
        else
        {
            image=[UIImage imageNamed:@"graypoint.png"];
            rect=CGRectMake(15, 22, image.size.width/2, image.size.height/2);
            
        }
        UIImageView *imageView=[[[UIImageView alloc]initWithFrame:rect] autorelease];
        imageView.image=image;
        
        UILabel *nameLabel=[[[UILabel alloc]init] autorelease];
        nameLabel.frame=CGRectMake(24, 14, 183, 21);
        nameLabel.textAlignment=UITextAlignmentLeft;
        nameLabel.textColor=[UIColor colorWithRed:59.0/255 green:59.0/255 blue:59.0/255 alpha:1.0];
        nameLabel.font=[UIFont systemFontOfSize:17.0];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        nameLabel.text=detail.userAgent;
        
        UILabel *detailLabel=[[[UILabel alloc]init] autorelease];
        detailLabel.frame=CGRectMake(24, 32, 183, 19);
        detailLabel.textAlignment=UITextAlignmentLeft;
        detailLabel.textColor=[UIColor colorWithRed:61.0/255 green:61.0/255 blue:61.0/255 alpha:1.0];
        detailLabel.font=[UIFont systemFontOfSize:11.0];
        [detailLabel setBackgroundColor:[UIColor clearColor]];
        NSString*beforeStr= [NSString stringForByteNumber:detail.before decimal:1];
        NSString*afterStr= [NSString stringForByteNumber:detail.after decimal:1];
        NSString *detailStr=[NSString stringWithFormat:@"%@%@%@%@",@"压缩前",beforeStr,@","@"压缩后",afterStr];
        detailLabel.text=detailStr;
        
        UILabel *jieshengLabel=[[[UILabel alloc]init] autorelease];
        jieshengLabel.frame=CGRectMake(190, 18, 105, 23);
        jieshengLabel.textAlignment=UITextAlignmentRight;
        jieshengLabel.textColor=[UIColor darkGrayColor];
        jieshengLabel.font=[UIFont systemFontOfSize:16.0];
        [jieshengLabel setBackgroundColor:[UIColor clearColor]];
        NSString *str1 = [NSString stringForByteNumber:(detail.before - detail.after) decimal:1];
        NSString *jieshengStr=[NSString stringWithFormat:@"%@%@",@"节省",str1];
        jieshengLabel.text=jieshengStr;
        
        [cell.contentView addSubview:imageView];
        [cell.contentView addSubview:nameLabel];
        [cell.contentView addSubview:detailLabel];
        [cell.contentView addSubview:jieshengLabel];
        return cell;

    
}

-(UITableViewCell*)jiaSuLiuLiang:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"jiasuCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.userInteractionEnabled = NO;
    }
    
    for ( UIView* v in cell.contentView.subviews )
    {
        [v removeFromSuperview];
    }
    
    StatsDetail *detail=[self.jiasuAgentArray objectAtIndex:[indexPath row]];
    UserAgentLock*agentLock = [UserAgentLockDAO getUserAgentLock:detail.uaStr];
    
    UIImageView *lineImageView=[[[UIImageView alloc]init] autorelease];
    lineImageView.frame=CGRectMake(0, 61, 320, 1);
    lineImageView.image=[UIImage imageNamed:@"henxian.png"];
    [cell.contentView addSubview:lineImageView];
    
    UIImage *image=nil;
    CGRect rect;
    if ( agentLock && agentLock.isLock )
    {
        image=[UIImage imageNamed:@"smalllock.png"];
        rect=CGRectMake(12, 26, 8, 10);
    }
    else
    {
        image=[UIImage imageNamed:@"graypoint.png"];
        rect=CGRectMake(15, 26, image.size.width/2, image.size.height/2);
        
    }
    UIImageView *imageView=[[[UIImageView alloc]initWithFrame:rect] autorelease];
    imageView.image=image;

    UILabel *nameLabel=[[[UILabel alloc]init] autorelease];
    nameLabel.frame=CGRectMake(24, 18, 183, 21);
    nameLabel.textAlignment=UITextAlignmentLeft;
    nameLabel.textColor=[UIColor colorWithRed:59.0/255 green:59.0/255 blue:59.0/255 alpha:1.0];
    nameLabel.font=[UIFont systemFontOfSize:17.0];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    nameLabel.text=detail.userAgent;
    
    UILabel *jieshengLabel=[[[UILabel alloc]init] autorelease];
    jieshengLabel.frame=CGRectMake(205, 18, 105, 23);
    jieshengLabel.textAlignment=UITextAlignmentRight;
    jieshengLabel.textColor=[UIColor darkGrayColor];
    jieshengLabel.font=[UIFont systemFontOfSize:16.0];
    [jieshengLabel setBackgroundColor:[UIColor clearColor]];
    NSString *str1 = [NSString stringForByteNumber:detail.before  decimal:1];
    NSString *jieshengStr=[NSString stringWithFormat:@"%@%@",@"加速",str1];
    jieshengLabel.text=jieshengStr;
    
    [cell.contentView addSubview:imageView];
    [cell.contentView addSubview:nameLabel];
    [cell.contentView addSubview:jieshengLabel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DatastatsDetailViewController*datastatsDetailViewController=[[[DatastatsDetailViewController alloc]init] autorelease];
    if(self.currentBtn==self.monthSaveBtn)
    {
        StatsDetail *detail=[self.jieshengAgentArray objectAtIndex:[indexPath row]];
        
        datastatsDetailViewController.statsDetail=detail;
    }
//    else if(self.currentBtn==self.jiaSuBtn)
//    {
//        StatsDetail *detail=[self.jiasuAgentArray objectAtIndex:[indexPath row]];
//        
//        datastatsDetailViewController.statsDetail=detail;
//    }
    datastatsDetailViewController.dataListController=self;
    datastatsDetailViewController.currentStats=self.currentStats;
    datastatsDetailViewController.startTime=self.startTime;
    datastatsDetailViewController.endTime=self.endTime;
    [[sysdelegate currentViewController].navigationController pushViewController:datastatsDetailViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSLog(@"indexPath====%d",[indexPath row]);
}

//每一行选中前调用
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.currentBtn==self.monthSaveBtn)
    {
        return indexPath;
       
    }
    else
        
        return nil;
}

//返回有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(self.currentBtn==self.monthSaveBtn)
    {
        if([self.jieshengAgentArray count]>=10)
        {
            tableCellCount= 10;
        }
        else
        {
            tableCellCount= [self.jieshengAgentArray count];

        }
    }
    else if(self.currentBtn==self.jiaSuBtn)
    {
        if([self.jiasuAgentArray count]>=10)
        {
            tableCellCount= 10;
        }
        else
        {
            tableCellCount= [self.jiasuAgentArray count];
            
        }
    }
   // NSLog(@"FFFFFFFFFFFF%d",tableCellCount);
    if(tableCellCount==10)
        return tableCellCount+1;
    else
        return tableCellCount;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62.0;
}

-(void)loadMore:(id)sender
{
    LoadMoreViewController*loadMoreViewController=[[[LoadMoreViewController alloc]init] autorelease];
    if(self.currentBtn==self.monthSaveBtn)
    {
        loadMoreViewController.flag=101;
        loadMoreViewController.jieshengAgentArray = self.jieshengAgentArray;
    }
    else if(self.currentBtn==self.jiaSuBtn)
    {
        loadMoreViewController.flag=102;
        loadMoreViewController.jiasuAgentArray = self.jiasuAgentArray;
        
    }
    loadMoreViewController.currentStats=self.currentStats;
   // NSLog(@"self.cuasdasdasd%ld_______________%ld",self.currentStats.bytesBefore,self.currentStats.endTime);

    [[sysdelegate currentViewController].navigationController pushViewController:loadMoreViewController animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
