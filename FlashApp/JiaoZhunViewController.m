//
//  JiaoZhunViewController.m
//  FlashApp
//
//  Created by 朱广涛 on 13-6-20.
//  Copyright (c) 2013年 lidiansen. All rights reserved.
//

#define TAG_ALERTVIEW_TOTAL 101
#define TAG_ALERTVIEW_DAY 102
#define TAG_ALERTVIEW_USED 103
#import "JiaoZhunViewController.h"
#import "AppDelegate.h"
#import "TCUtils.h"
#import "TwitterClient.h"
#import "DateUtils.h"
#import "StringUtil.h"
#import "TCCarrierViewController.h"
#import "REString.h"
#import "TaoCanViewController.h"

#define TAG_ALERTVIEW_LOCATION 104

@interface JiaoZhunViewController ()

@end

@implementation JiaoZhunViewController

@synthesize taocanCountLabel;
@synthesize benyueCountLabel;
@synthesize yuejieCountLabel;
@synthesize client;
@synthesize controller;

- (void)dealloc {
    [oneSessiontopImageArray release];
    [twoSessiontopImageArray release];
    [oneSessionnameLabelArray release];
    [twoSessionnameLabelArray release];
    [oneSessiontitleArray release];

    [self.oneNameLabel release];
    [self.twoNameLabel release];
    [self.turnOnBtn release];
    [client cancel];
    [client release];
    client = nil;
    
    [yueJieRiStr release];
    [taoCanZongStr release];
    [yiYongLiangStr release];
    
    self.taocanCountLabel=nil;    
    self.benyueCountLabel=nil;
    self.yuejieCountLabel=nil;
    self.controller=nil;
    [super dealloc];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        oneSessiontopImageArray = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"jiaozhun_1_.png"], [UIImage imageNamed:@"jiaozhun_2_.png"],[UIImage imageNamed:@"jiaozhun_3_.png"],nil];
        
        twoSessiontopImageArray = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"jiaozhun_4_.png"],[UIImage imageNamed:@"jiaozhun_5_.png"], nil];
        
        oneSessionnameLabelArray = [[NSArray alloc] initWithObjects:@"校准本月已用流量",@"设置套餐流量",@"设置月结算日" ,nil];
        
        twoSessionnameLabelArray = [[NSArray alloc] initWithObjects:@"发送流量短信套餐",@"精确流量监控", nil];
        
        oneSessiontitleArray = [[NSArray alloc] initWithObjects:@"taocan.TCAdjustView.setUsedFlow",@"taocan.TCAdjustView.setPackageFlow",@"taocan.TCAdjustView.setDay",nil];
        
         
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UITableView *myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, [UIScreen mainScreen].applicationFrame.size.height - 44) style:UITableViewStyleGrouped];
    myTableView.scrollEnabled = NO;
    myTableView.dataSource =self;
    myTableView.delegate = self;
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [view setBackgroundColor:[UIColor whiteColor]];
    myTableView.backgroundView = view;
    [view release];
    [self.view addSubview:myTableView];
    [myTableView release];
    
    [self loadData];
    //定位
    [self loadDingWei];
}
- (void) viewWillDisappear:(BOOL)animated
{    
    if ( client ) {
        [client cancel];
        [client release];
        client = nil;
    }
    
    
    [super viewWillDisappear:YES];
}
-(void)loadDingWei
{
    BOOL locationEnabled = [CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized;
    BOOL opend = [[NSUserDefaults standardUserDefaults] boolForKey:UD_LOCATION_ENABLED];
    if ( locationEnabled && opend ) {
        locationFlag = NO;
        [self.turnOnBtn setBackgroundImage:[UIImage imageNamed:@"jiaozhun_lo_open.png"] forState:UIControlStateNormal];
    }
    else {
        locationFlag = YES;
        [self.turnOnBtn setBackgroundImage:[UIImage imageNamed:@"jiaozhun_lo_close.png"] forState:UIControlStateNormal];
    }
}

- (void) loadData
{
    [TCUtils readIfData:-1];
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    NSString* total = user.ctTotal;
    NSString* used = user.ctUsed;
    NSString* day = user.ctDay;
    
    if ( !total ) {
        //读取服务器的数值
        [self getDataFromServer];
        total = [NSString stringWithFormat:@"%d", TC_TOTAL];
        
    }
    if( !day){
        day = @"1";
    }
    if ( !used || used.length == 0 ) {
        used = @"2.0"; 
    }
    else {
        used = [NSString stringWithFormat:@"%.2f", [used longLongValue] / 1024.0f / 1024.0f];
    }
    
    yueJieRiStr = nil;
    [yueJieRiStr release];
    yueJieRiStr = [NSString stringWithFormat:@"%@日", day];
    //yueJieRiStr = day;
    [yueJieRiStr retain];
    
    taoCanZongStr =nil;
    [taoCanZongStr release];
    taoCanZongStr = [NSString stringWithFormat:@"%@MB", total];
    //taoCanZongStr = total;
    [taoCanZongStr retain];
    
    yiYongLiangStr = nil;
    [yiYongLiangStr release];
    yiYongLiangStr = [NSString stringWithFormat:@"%@MB", used];
    //yiYongLiangStr = used;
    [yiYongLiangStr retain];
    
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
    int daym = ( day ? [day intValue] : 1 );
    
    time_t peroid[2];
    time_t now;
    time( &now );
    [TCUtils getPeriodOfTcMonth:peroid time:now];
    if ( used && used.length > 0 ) {
        if ( lastUpdate >= peroid[0] && lastUpdate <= peroid[1] && [used floatValue] > bytes ) {
            bytes = [used longLongValue];
        }
    }
    user.lastUpdate=[DateUtils stringWithDateFormat:lastUpdate format:@"yyyy年MM月dd日"];
    
    //判断是否修改过
    NSString* curTotal = user.ctTotal;
    NSString* curUsed = user.ctUsed;
    NSString* curDay = user.ctDay;
    
    if ( !curTotal || curTotal.length == 0 ) {
        taoCanZongStr = nil;
        [taoCanZongStr release];
        taoCanZongStr = [NSString stringWithFloatTrim:totalm decimal:2];
        [taoCanZongStr retain];
//        dirty = YES;
    }
    
    if ( !curDay || curDay.length == 0 ) {
        yueJieRiStr = nil;
        [yueJieRiStr release];
        yueJieRiStr = [NSString stringWithFormat:@"%d", daym];
        [yueJieRiStr retain];
//        dirty = YES;
    }
    
    if ( !curUsed || curUsed.length == 0 ) {
        yiYongLiangStr = nil;
        [yiYongLiangStr release];
        yiYongLiangStr = [NSString stringWithFormat:@"%.2f", bytes / 1024.0f / 1024.0f];
        [yiYongLiangStr retain];
//        dirty = YES;
    }
}

- (void)openOrCloseLocation:(UIButton *)btn
{
    
    self.turnOnBtn = btn;
    
    UIDevice* device = [UIDevice currentDevice];
    NSString* desc = nil;
    if ( [device.systemVersion compare:@"6.0"] == NSOrderedAscending ) {
        desc = @"设置>定位服务";
    }
    else {
        desc = @"设置>隐私>位置";
    }
    
    if ( locationFlag ) {
        if ( ![CLLocationManager locationServicesEnabled] ) {
            [AppDelegate showAlert:[NSString stringWithFormat:@"您的设备未开启定位服务\n请在\"%@\"中打开定位服务！", desc]];
            locationFlag = YES;
            [self.turnOnBtn setBackgroundImage:[UIImage imageNamed:@"jiaozhun_lo_close.png"] forState:UIControlStateNormal];
            
        }
        else if ( [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized && [[NSUserDefaults standardUserDefaults] objectForKey:UD_LOCATION_ENABLED]) {
            //判断是否是第一次使用
            [AppDelegate showAlert:[NSString stringWithFormat:@"您现在禁止加速宝使用定位服务\n请在\"%@\"中打开加速宝的开关",desc]];
            locationFlag = YES;
            [self.turnOnBtn setBackgroundImage:[UIImage imageNamed:@"jiaozhun_lo_close.png"] forState:UIControlStateNormal];
            
        }
        else {
            [[AppDelegate getAppDelegate] startLocationManager];
            [[NSUserDefaults standardUserDefaults] setBool:locationFlag forKey:UD_LOCATION_ENABLED];
            [[NSUserDefaults standardUserDefaults] synchronize];
            locationFlag=NO;
            [self.turnOnBtn setBackgroundImage:[UIImage imageNamed:@"jiaozhun_lo_open.png"] forState:UIControlStateNormal];
            
        }
    }
    else {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"关闭精确流量监控将无法实时统计流量，可能造成流量统计不准确！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = TAG_ALERTVIEW_LOCATION;
        [alertView show];
        [alertView release];
    }

}

- (IBAction)saveBtn:(id)sender
{
    
    NSString* total = [self.taocanCountLabel.text trim];
    NSString* used = [self.benyueCountLabel.text trim];
    NSString* day = [self.yuejieCountLabel.text trim];
    
    NSRange foundtotalObj=[total rangeOfString:@"MB" options:NSCaseInsensitiveSearch];
    if(foundtotalObj.length>0) {
        total = [total substringWithRange:NSMakeRange(0,foundtotalObj.location)];
    } 
    
    NSRange foundusedObj=[used rangeOfString:@"MB" options:NSCaseInsensitiveSearch];
    if(foundusedObj.length>0) {
        used = [used substringWithRange:NSMakeRange(0,foundusedObj.location)];
    }
    
    NSRange founddayObj=[day rangeOfString:@"日" options:NSCaseInsensitiveSearch];
    if(founddayObj.length>0) {
        day = [day substringWithRange:NSMakeRange(0,founddayObj.location)];
    }
    
    time_t now;
    time( &now );
    UserSettings* user = [AppDelegate getAppDelegate].user;
    
    user.lastUpdate=[DateUtils stringWithDateFormat:now format:@"yyyy年MM月dd日"];
    
    
    long long bytes = [used floatValue] * 1024.0f * 1024.0f;
    [TCUtils saveTCUsed:bytes total:[total floatValue] day:[day intValue]];
    
    //发送页面刷新通知
    [[NSNotificationCenter defaultCenter] postNotificationName:TCChangedNotification object:nil];
    
    if ( [[AppDelegate getAppDelegate].networkReachablity currentReachabilityStatus] != NotReachable ) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [TwitterClient saveTaocanData:total used:[NSString stringWithFormat:@"%lld", bytes] day:day];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    
    //[self.navigationController popViewControllerAnimated:YES];
    TaoCanViewController*taoCanViewController=(TaoCanViewController*)self.controller;
    [taoCanViewController getDataTotalCount ];
    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshNotification object:nil];//刷新界面
    
    [[sysdelegate navController  ] popViewControllerAnimated:YES];
}

- (IBAction)backBtn:(id)sender
{
    [[sysdelegate navController  ] popViewControllerAnimated:YES];
}

- (UITableViewCell *)setOneTableViewCell:(UITableViewCell *)cell atImdexPath:(NSIndexPath *)indexPath
{
    //设置cell按钮被按下时的颜色
    UIView *cellSelBgView  = [[UIView alloc] init];
    cellSelBgView.backgroundColor = RGB(211, 232, 237);
    cell.selectedBackgroundView = cellSelBgView;
    [cellSelBgView release];
    
    //每个cell的图片
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    topImageView.image = [oneSessiontopImageArray objectAtIndex:indexPath.row];
    [cell.contentView addSubview:topImageView];
    [topImageView release];
    
    //定义cell的name
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 160, 40)];
    nameLabel.textColor = RGB(76, 76, 76);
    nameLabel.backgroundColor = [UIColor clearColor];
    self.oneNameLabel = nameLabel;
    [nameLabel release];
    [cell.contentView addSubview:self.oneNameLabel];
    
    
    
    //定义cell后面的数字
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 5, 80, 40)];
    numLabel.textColor = RGB(112, 185, 127);
    numLabel.backgroundColor = [UIColor clearColor];
    switch (indexPath.row) {
        case 0:
            self.benyueCountLabel = numLabel;
            [numLabel release];
            [cell.contentView addSubview:self.benyueCountLabel];
            
//            UILabel *mbLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 5, 50, 40)];
//            mbLabel.textColor = RGB(112, 185, 127);
//            mbLabel.backgroundColor = [UIColor clearColor];
//            mbLabel.text = @"MB";
//            [cell.contentView addSubview:mbLabel];
//            [mbLabel release];
            
            break;
        case 1:
            self.taocanCountLabel = numLabel;
            [numLabel release];
            [cell.contentView addSubview:self.taocanCountLabel];
            
//            UILabel *totalbLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 5, 50, 40)];
//            totalbLabel.textColor = RGB(112, 185, 127);
//            totalbLabel.backgroundColor = [UIColor clearColor];
//            totalbLabel.text = @"MB";
//            [cell.contentView addSubview:totalbLabel];
//            [totalbLabel release];
            
            break;
        case 2:
            self.yuejieCountLabel = numLabel;
            [numLabel release];
            [cell.contentView addSubview:self.yuejieCountLabel];
            
//            UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 5, 50, 40)];
//            dayLabel.textColor = RGB(112, 185, 127);
//            dayLabel.backgroundColor = [UIColor clearColor];
//            dayLabel.text = @"日";
//            [cell.contentView addSubview:dayLabel];
//            [dayLabel release];
            
            break;
        default:
            break;
    }
   
    
    //定义cell后面的MB
//    UILabel *mbLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 5, 50, 40)];
//    mbLabel.textColor = RGB(112, 185, 127);
//    mbLabel.backgroundColor = [UIColor clearColor];
//    mbLabel.text = @"MB";
//    [cell.contentView addSubview:mbLabel];
//    [mbLabel release];
    
    //定义accessoryView
    UIView *cellAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jiaozhun_jiantou.png"]];
    cell.accessoryView = cellAccessoryView;
    [cellAccessoryView release];
    
    return cell;
}

- (UITableViewCell *)setTwoTableViewCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    //cell的图片
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    topImageView.image = [twoSessiontopImageArray objectAtIndex:indexPath.row];
    [cell.contentView addSubview:topImageView];
    [topImageView release];
    
    //定义cell的name
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 1, 160, 40)];
    nameLabel.textColor = RGB(76, 76, 76);
    nameLabel.backgroundColor = [UIColor clearColor];
    self.twoNameLabel = nameLabel;
    [nameLabel release];
    [cell.contentView addSubview:self.twoNameLabel];
   
    if (indexPath.row == 0 ) {
        //定义accessoryView
        UIView *cellAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jiaozhun_jiantou.png"]];
        cell.accessoryView = cellAccessoryView;
        [cellAccessoryView release];
        
        //设置cell按钮被按下时的颜色
        UIView *cellSelBgView  = [[UIView alloc] init];
        cellSelBgView.backgroundColor = RGB(211, 232, 237);
        cell.selectedBackgroundView = cellSelBgView;
        [cellSelBgView release];
    }else{
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        //提示标题
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 35, 160, 10)];
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.textColor = [UIColor darkGrayColor];
        detailLabel.font = [UIFont systemFontOfSize:10];
        detailLabel.text = @"大幅度提高统计精准度(耗电量略高)";
        [cell.contentView addSubview:detailLabel];
        [detailLabel release];
    
        UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        locationBtn.frame = CGRectMake(235, 10, 50, 26);
        if (locationFlag) {
            [locationBtn setBackgroundImage:[UIImage imageNamed:@"jiaozhun_lo_close.png"] forState:UIControlStateNormal];
        }else{
             [locationBtn setBackgroundImage:[UIImage imageNamed:@"jiaozhun_lo_open.png"] forState:UIControlStateNormal];
        }
        [locationBtn addTarget:self action:@selector(openOrCloseLocation:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:locationBtn];
    }
    return cell;

}

#pragma mark - UITableViewDatasouce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }else{
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierOne = @"oneCell";
    static NSString *identifierTwo = @"twoCell";
    
    switch (indexPath.section) {
        case 0:{
            UITableViewCell *oneCell = [tableView dequeueReusableCellWithIdentifier:identifierOne] ;
            
            if (oneCell == nil) {
                oneCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierOne];
                [self setOneTableViewCell:oneCell atImdexPath:indexPath ];
            }
            //data manage
            self.oneNameLabel.text = [oneSessionnameLabelArray objectAtIndex:indexPath.row];
            switch (indexPath.row) {
                case 0:
                   
                    self.benyueCountLabel.text = yiYongLiangStr;
                    break;
                case 1:
                    self.taocanCountLabel.text  = taoCanZongStr;
                    break;
                case 2:
                    self.yuejieCountLabel.text  = yueJieRiStr;
                    break;
                default:
                    break;
            }
            
            
            return oneCell;
        }
        case 1:{
            UITableViewCell *twoCell = [tableView dequeueReusableCellWithIdentifier:identifierTwo];
            if (twoCell == nil) {
                twoCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierTwo];
                [self setTwoTableViewCell:twoCell atIndexPath:indexPath];
            }
            //data manage
            self.twoNameLabel.text = [twoSessionnameLabelArray objectAtIndex:indexPath.row];
            
            
            return twoCell;
        }
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString* value = @"";
    NSInteger* tag = 0;
    switch (indexPath.section) {
        case 0:{     
            switch (indexPath.row) {
                case 0:
                    value = self.benyueCountLabel.text;
                    tag = TAG_ALERTVIEW_USED;
                    break;
                case 1:
                    value = self.taocanCountLabel.text;
                    tag = TAG_ALERTVIEW_TOTAL;
                    break;
                case 2:
                    value = self.yuejieCountLabel.text ;
                    tag = TAG_ALERTVIEW_DAY;
                    break;
                default:
                    break;
            }
            [self showInputAlertView:NSLocalizedString([oneSessiontitleArray objectAtIndex:indexPath.row], nil) value:value tag:tag];
            break;
        }
        case 1:{
            if (indexPath.row == 0 ) {
                UserSettings* user = [AppDelegate getAppDelegate].user;
                if ( user.username && user.username.length > 0 ) {
                    NetworkStatus status = [[AppDelegate getAppDelegate].networkReachablity currentReachabilityStatus];
                    if ( (!user.areaCode || user.areaCode.length == 0) && status != NotReachable  ) {
                        if ( client ) return;
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                        client = [[TwitterClient alloc] initWithTarget:self action:@selector(didGetCarrierInfo:obj:)];
                        [client getCarrierInfo:user.username area:nil code:nil type:nil];
                    }
                    else {
                        [self openCarrierView];
                    }
                }
                else {
                    [self openCarrierView];
                }
            }
            
            break;
        }
        default:
            break;
    }
    
}

- (void) didGetCarrierInfo:(TwitterClient*)tc obj:(NSObject*)obj
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    client = nil;
    
    [TwitterClient parseCarrierInfo:obj];
    [self openCarrierView];
}

- (void) openCarrierView
{
    TCCarrierViewController* tCCarrierViewController = [[TCCarrierViewController alloc] init];
    [[sysdelegate currentViewController].navigationController pushViewController:tCCarrierViewController animated:YES];
    [tCCarrierViewController release];
}

#pragma mark - UIAlertViewDelegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( alertView.tag == TAG_ALERTVIEW_LOCATION ) {
        if ( buttonIndex == 0 ) {
            locationFlag = NO;
            [self.turnOnBtn setBackgroundImage:[UIImage imageNamed:@"jiaozhun_lo_open.png"] forState:UIControlStateNormal];
            
        }
        else {
            //关闭精确流量监控
            [[AppDelegate getAppDelegate] stopLocationManager];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:UD_LOCATION_ENABLED];
            [[NSUserDefaults standardUserDefaults] synchronize];
            locationFlag=YES;
            [self.turnOnBtn setBackgroundImage:[UIImage imageNamed:@"jiaozhun_lo_close.png"] forState:UIControlStateNormal];
            
        }
    } else {
        if ( buttonIndex == 0 ) return;
        
        UITextField* textField = [self getTextFieldOfAlertView:alertView];
        if ( !textField ) return;
        
        NSString* value = [textField.text trim];
        if ( value.length == 0 ) return;
        
        if ( ![self checkInputValue:value tag:alertView.tag] ) return;
        
//        UILabel* label = (UILabel*) [self.oneNumLabel viewWithTag:alertView.tag];
//        label.text = value;
        if ( alertView.tag == TAG_ALERTVIEW_TOTAL ) {
           //  value = [NSString stringWithFormat:@"%@MB", value];
            self.taocanCountLabel.text = value;
        }
        else if ( alertView.tag == TAG_ALERTVIEW_DAY ) {
           //  value = [NSString stringWithFormat:@"%@日", value];
            self.yuejieCountLabel.text = value;
        }
        else if ( alertView.tag == TAG_ALERTVIEW_USED ) {
            // value = [NSString stringWithFormat:@"%@MB", value];
            self.benyueCountLabel.text = value;
        }
    }
}

- (void) showInputAlertView:(NSString*)title value:(NSString*)value tag:(NSInteger)tag
{
    UIAlertView* dialog = [[UIAlertView alloc] initWithFrame:CGRectMake(10, 20, 300, 100)];
    dialog.tag = tag;
    [dialog setDelegate:self];
    [dialog setTitle:title];
    [dialog setMessage:@" "];
    [dialog addButtonWithTitle:NSLocalizedString(@"cancleName", nil)];
    [dialog addButtonWithTitle:NSLocalizedString(@"defineName", nil)];
    
    UITextField* nameField = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 45.0, 245.0, 25.0)];
    [nameField setBackgroundColor:[UIColor whiteColor]];
    nameField.placeholder=value;//add 03-11
    // nameField.text = value;
    
    //nameField.keyboardType = UIKeyboardTypeNumberPad;
    [dialog addSubview:nameField];
    [nameField becomeFirstResponder];
    [dialog show];
    
    /*if ( !numberKeyboard ) {
     self.numberKeyboard = [NumberKeypadDecimalPoint keypadForTextField:nameField];
     }
     else {
     self.numberKeyboard.currentTextField = nameField;
     }*/
    
    [dialog release];
    [nameField release];
}

- (UITextField*) getTextFieldOfAlertView:(UIAlertView*)alertView
{
    if ( !alertView ) return nil;
    
    for ( UIView* v in [alertView subviews] ) {
        if ( [v isKindOfClass:[UITextField class]] ) return (UITextField*) v;
    }
    
    return nil;
}

- (BOOL) checkInputValue:(NSString*)value tag:(NSInteger)tag
{
    value = [value trim];
    if ( !value || value.length == 0 ) {
        [AppDelegate showAlert:NSLocalizedString(@"taocan.TCAdjustView.checkInput.valueLength", nil)];
        return NO;
    }
    
    if ( tag == TAG_ALERTVIEW_TOTAL ) {
        NSString* total = [value trim];
        if ( total.length == 0 ) {
            [AppDelegate showAlert:NSLocalizedString(@"taocan.TCAdjustView.checkInput.totalValueLength", nil)];
            return NO;
        }
        
        BOOL b = [total matches:@"^([0-9]{1,4}(\\.[0-9]{1,2})*)$" withSubstring:nil];
        if ( !b ) {
            [AppDelegate showAlert:NSLocalizedString(@"taocan.TCAdjustView.checkInput.totalValueMatch", nil)];
            return NO;
        }
        
    }
    else if ( tag == TAG_ALERTVIEW_USED ) {
        NSString* used = [value trim];
        if ( used.length == 0 ) {
            [AppDelegate showAlert:NSLocalizedString(@"taocan.TCAdjustView.checkInput.usedValueLength", nil)];
            return NO;
        }
        
        BOOL b = [used matches:@"^([0-9]{1,4}(\\.[0-9]{1,2})*)$" withSubstring:nil];
        if ( !b ) {
            [AppDelegate showAlert:NSLocalizedString(@"taocan.TCAdjustView.checkInput.usedValueMatch", nil)];
            return NO;
        }
    }
    else if ( tag == TAG_ALERTVIEW_DAY ) {
        NSString* day = [value trim];
        if ( day.length == 0 ) {
            [AppDelegate showAlert:NSLocalizedString(@"taocan.TCAdjustView.checkInput.dayValueLength", nil)];
            return NO;
        }
        
        BOOL b = [day matches:@"^[0-9]{1,2}$" withSubstring:nil];
        if ( !b ) {
            [AppDelegate showAlert:NSLocalizedString(@"taocan.TCAdjustView.checkInput.dayValueMatch", nil)];
            return NO;
        }
        
        int d = [day intValue];
        if ( d <=0 || d > 31 ) {
            [AppDelegate showAlert:NSLocalizedString(@"taocan.TCAdjustView.checkInput.dayIntValue", nil)];
            return NO;
        }
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
