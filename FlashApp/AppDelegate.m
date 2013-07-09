//
//  AppDelegate.m
//  FlashApp
//
//  Created by lidiansen on 12-12-13.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import <TencentOpenAPI/TencentOAuth.h>
#import "SetingViewController.h"
#import "DetectionViewController.h"
#import "WangSuViewController.h"
#import "LaunchViewController.h"
#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "FlowJiaoZhunViewController.h"
#import "SetingViewController.h"
#import "AppDelegate.h"
#import "ViewController.h"
#include <Quartzcore/Quartzcore.h>
#import "DBConnection.h"
#import "WXApi.h"
#import "TCUtils.h"
#import "StatsDayDAO.h"
#import "TwitterClient.h"
#import "DateUtils.h"
#import "TCLocationManager.h"
#import "StringUtil.h"
#import "UIDevice-software.h"
#import "AppInfo.h"
#import "OpenUDID.h"
#import "MBProgressHUD.h"
#import "GetAddress.h"
#import "NSString+SBJson.h"
#import "Flurry.h"

//add guangtao 
#import "OpenServeViewController.h"
#import "ASIHttpRequest.h"
#import "AppClasses.h"
#import "AppRecommendDao.h"

//add fangzhen notification
#import "NotificationUtils.h"
#import "JiaoZhunViewController.h"
#import "DatastatsViewController.h"
#import "Prefs.h"
#import "TaoCanViewController.h"

#define APPID 606803214//addd jianfei han

@implementation AppDelegate
@synthesize navController;
@synthesize user;
@synthesize refreshingLock;
@synthesize dbWriteLock;
@synthesize refreshDatasave;
@synthesize networkReachablity;
@synthesize carrier;
@synthesize refreshDatastats;
@synthesize proxySlow;
@synthesize adjustSMSSend;
@synthesize window;
@synthesize mArray;
//@synthesize pushNotifationType;
- (void)dealloc
{
    [operationQueue release];

    [refreshThread release];
    [timerTaskLock release];
    [refreshingLock release];
    [locationManager release];

    self.carrier=nil;
    self.networkReachablity=nil;
    [dbWriteLock release];
     self.user=nil;
    self.navController=nil;
    [mArray release];
    
    [window release];
  //  [pushNotifationType release];
    [super dealloc];
}

-(void)ifNewApp
{
    DeviceInfo *device = [DeviceInfo deviceInfoWithLocalDevice];
    
    CTTelephonyNetworkInfo *tni = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *ccar = tni.subscriberCellularProvider;
    [tni release];
    
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
    
    double cpi = [[NSUserDefaults standardUserDefaults] doubleForKey:@"catsucp"];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    NSString *scr =[NSString stringWithFormat:@"%.0f*%.0f",rect.size.width,rect.size.height];
    
    NSString *str = [NSString stringWithFormat:@"http://apps.flashapp.cn/api/vapp/catsu?deviceId=%@&platform=%@&cpi=%.0f&appid=%d&osversion=%@&dwname=%@&scr=%@&mnc=%@&mcc=%@&vr=%@&chl=%@&ver=%@",device.deviceId,[device.platform encodeAsURIComponent],cpi,APP_ID,[device.version encodeAsURIComponent],[device.hardware encodeAsURIComponent],scr,ccar ?ccar.mobileNetworkCode:@"",ccar?ccar.mobileCountryCode:@"",version,CHANNEL,API_VER];
    NSLog(@"");
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
    [request setCompletionBlock:^{
        //请求返回的 应用分类 的结果集
        NSDictionary *result = [NSDictionary dictionaryWithDictionary:[[request responseString] JSONValue]]; 
        //结果集解析成array
        NSMutableArray *categoryArray = [NSMutableArray arrayWithCapacity:3];
        [categoryArray addObjectsFromArray:[result objectForKey:@"catsu"]];
        
        //储存CP 下次请求数据的时候带上
        [[NSUserDefaults standardUserDefaults] setObject:[result objectForKey:@"cp"] forKey:@"catsucp"] ;
        
        //查询数据库中 应用分类 的结果集
        NSDictionary *databasedic = [AppRecommendDao fondAllAppRecommend];
        
        NSLog(@"1212121212121212 urlurlurl is %@  cpcpcpcpcp is %.0f %@ :",str,cpi,result);
        
         //如果查询的结果集是空， 那么我们就把请求来的结果 插入数据库表中
        if ([databasedic count] == 0) {
            
            [DBConnection beginTransaction];
            
            [AppRecommendDao insertAllAppRecommend:categoryArray];
            
            [DBConnection commitTransaction];
            
        }else{
            for (NSString *str in [databasedic allKeys]) {
                if ([str isEqualToString:@"精品推荐"]) {
                    AppClasses *appClasses = [databasedic objectForKey:@"精品推荐"];
                    
                   long long new_tim = [[[categoryArray objectAtIndex:0] objectForKey:@"tim"] longLongValue];
                    
                    long long old_tim = appClasses.appClass_tim;
                    
                    if (new_tim >old_tim) {
                        appClasses.appClass_tim = new_tim;
                        [AppRecommendDao updateAppRecommend:appClasses];
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:NEWS_APP];
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:JPTJ_APP];
                    }
                    
                    NSLog(@"%@ 's NEW_TIM IS %lld , OLD_TIM IS %lld",appClasses.appClasses_name,new_tim , old_tim);
                    
                }
                if ([str isEqualToString:@"限时免费"]) {
                    AppClasses *appClasses = [databasedic objectForKey:@"限时免费"];
                    
                    long long new_tim = [[[categoryArray objectAtIndex:1] objectForKey:@"tim"] longLongValue];
                    
                    long long old_tim = appClasses.appClass_tim;
                    
                    if (new_tim >old_tim) {
                        appClasses.appClass_tim = new_tim;
                        [AppRecommendDao updateAppRecommend:appClasses];
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:NEWS_APP];
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:XSMF_APP];
                    }
                    
                     NSLog(@"%@ 'sNEW_TIM IS %lld , OLD_TIM IS %lld",appClasses.appClasses_name,new_tim , old_tim);
                    
                }
                if ([str isEqualToString:@"热门游戏"]) {
                    AppClasses *appClasses = [databasedic objectForKey:@"热门游戏"];
                    
                    long long new_tim = [[[categoryArray objectAtIndex:2] objectForKey:@"tim"] longLongValue];
                    
                    long long old_tim = appClasses.appClass_tim;
                    
                    if (new_tim >old_tim) {
                        appClasses.appClass_tim = new_tim;
                        [AppRecommendDao updateAppRecommend:appClasses];
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:NEWS_APP];
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:RMYX_APP];
                    }
                    
                    NSLog(@"%@ 'sNEW_TIM IS %lld , OLD_TIM IS %lld",appClasses.appClasses_name,new_tim , old_tim);
                }
            }
        }
        

    }];
    [request startAsynchronous];
    
}

+ (void) installProfile:(NSString *)nextPage idc:(NSString*)idcCode
{
    
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSString *url;
    NSString *inchk = [[NSUserDefaults standardUserDefaults] objectForKey:@"inchk"];
    UserSettings *user = [UserSettings currentUserSettings];
    
    if ([@"1" isEqualToString:inchk] &&[CHANNEL isEqualToString:@"appstore" ] &&[user.profileType isEqualToString:@"vpn"]) {
        NSString *vpn = [userDefault objectForKey:@"vpnName"];
        url = [AppDelegate getInstallURL:nextPage install:YES vpn:vpn idc:idcCode servicetype:@"apn" interfable:@"1"];
    }else{
        NSString* apn = [userDefault objectForKey:@"apnName"];
        url = [AppDelegate getInstallURL:nextPage install:YES vpn:apn idc:idcCode servicetype:@"apn" interfable:@"0"];
    }
    NSLog(@"112233 %@",url);
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}
//
///*
// *安装apn
// */
//+ (void) installProfile:(NSString *)nextPage apn:(NSString*)apn
//{
//    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
//    if ( apn && [apn length] > 0 ) {
//        [userDefault setObject:apn forKey:@"apnName"];
//    }
//    else {
//        [userDefault removeObjectForKey:@"apnName"];
//    }
//    [userDefault synchronize];
//    
//    NSString* url = [AppDelegate getInstallURL:nextPage install:YES apn:apn idc:nil];
//    NSLog(@"url=%@", url);
//	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
//}
//
//+ (NSString*) getInstallURL:(NSString*)nextPage install:(BOOL)isInstall apn:(NSString*)apn idc:(NSString*)idcCode
//{
//    DeviceInfo* device = [DeviceInfo deviceInfoWithLocalDevice];
//    NSString* type = [UIDevice connectionTypeString];
//    NSString* deviceToken =  [[NSUserDefaults standardUserDefaults] stringForKey:@"deviceToken"];
//    CTTelephonyNetworkInfo* tni = [[CTTelephonyNetworkInfo alloc] init];
//    CTCarrier* carrier = tni.subscriberCellularProvider;
//    [tni release];
//    int rd = ((double) rand() / RAND_MAX) * 10000;
//    
//    NSString* deviceId = [OpenUDID value];
//    NSString* code = [[NSString stringWithFormat:@"%@%@%@%d", deviceId, CHANNEL, API_KEY, rd] md5HexDigest];
//    //add jianfei han
//    UserSettings* user = [AppDelegate getAppDelegate].user;
//    NSMutableString* url=nil;
//    if(user.nickname)
//    {
//        url= [NSMutableString stringWithFormat:@"http://%@/vpnn?_method=profile&deviceId=%@&name=%@&platform=%@&osversion=%@&connType=%@&carrier=%@&mcc=%@&mnc=%@&install=%d&apn=%@&appid=%d&chl=%@&rd=%d&code=%@&ver=%@%@&username=%@&deviceToken=%@&servicetype=%@", P_HOST, device.deviceId, [device.hardware encodeAsURIComponent], [device.platform encodeAsURIComponent], [device.version encodeAsURIComponent], type,
//              carrier ? [carrier.carrierName encodeAsURIComponent] : @"",
//              carrier ? carrier.mobileCountryCode : @"",
//              carrier ? carrier.mobileNetworkCode : @"",
//              isInstall ? 1 : 0,
//              apn && [apn length] > 0 ? [apn encodeAsURIComponent] : @"",2,CHANNEL, rd, code, API_VER,
//              idcCode ? [NSString stringWithFormat:@"&area=%@", idcCode] : @"",[user.nickname encodeAsURIComponent],deviceToken ,@"apn" ];
//        
//    }
//    else
//    {
//        url = [NSMutableString stringWithFormat:@"http://%@/vpnn?_method=profile&deviceId=%@&name=%@&platform=%@&osversion=%@&connType=%@&carrier=%@&mcc=%@&mnc=%@&install=%d&apn=%@&appid=%d&chl=%@&rd=%d&code=%@&ver=%@%@&deviceToken=%@&servicetype=%@",
//               P_HOST,
//               device.deviceId,
//               [device.hardware encodeAsURIComponent],
//               [device.platform encodeAsURIComponent],
//               [device.version encodeAsURIComponent],
//               type,
//               carrier ? [carrier.carrierName encodeAsURIComponent] : @"",
//               carrier ? carrier.mobileCountryCode : @"",
//               carrier ? carrier.mobileNetworkCode : @"",
//               isInstall ? 1 : 0,
//               apn && [apn length] > 0 ? [apn encodeAsURIComponent] : @"",
//               2,
//               CHANNEL,
//               rd,
//               code,
//               API_VER,
//               idcCode ? [NSString stringWithFormat:@"&area=%@", idcCode] : @"",
//               deviceToken,
//               @"apn"];
//        
//    }
//    if ( nextPage && [nextPage length] > 0 )
//    {
//        [url appendFormat:@"&nextPage=%@", [nextPage encodeAsURIComponent]];
//    }
//    
//    return url;
//}

/*
 *越狱用户 户第一次安装点击进入的是直接安装 apn ,或者安装设置页面
 */
//+(void)installProfile;
//{
//    NSString* url = [AppDelegate getInstallURL:nil install:YES vpn:nil idc:nil servicetype:@"apn"];
//	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];    
//}

/*
 有一个新参数interfable 如果是 0  就不允许 ， 是 1 就允许 服务器端来改变
 */
+ (void)installProfile:(NSString *)nextPage vpnn:(NSString*)voaName interfable:(NSString *)interfable
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    UserSettings *user = [UserSettings currentUserSettings];
    
    if ([user.profileType isEqualToString:@"apn"]) {
        if ( voaName && [voaName length] > 0 ) {
            [userDefault setObject:voaName forKey:@"apnName"];
        }
        else {
            [userDefault removeObjectForKey:@"apnName"];
        }
    }
    //应该不会进入这里吧
//    else if([user.profileType isEqualToString:@"vpn"]){
//        if ( voaName && [voaName length] > 0 ) {
//            [userDefault setObject:voaName forKey:@"vpnName"];
//        }
//        else {
//            [userDefault removeObjectForKey:@"vpnName"];
//        }
//    }
    [userDefault synchronize];
    
    NSString *url = [AppDelegate getInstallURL:nextPage install:YES vpn:voaName idc:nil servicetype:@"apn" interfable:interfable];
    
//    NSLog(@"%@",url);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}
+ (NSString*) getInstallURL:(NSString*)nextPage install:(BOOL)isInstall vpn:(NSString*)apn idc:(NSString*)idcCode servicetype:(NSString *)profiletype interfable:(NSString *)interfable
{
    DeviceInfo* device = [DeviceInfo deviceInfoWithLocalDevice];
    NSString* type = [UIDevice connectionTypeString];
    NSString* deviceToken =  [[NSUserDefaults standardUserDefaults] stringForKey:@"deviceToken"];
    CTTelephonyNetworkInfo* tni = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier* carrier = tni.subscriberCellularProvider;
    [tni release];
    
    int rd = ((double) rand() / RAND_MAX) * 10000; //随机数
    
    NSString* deviceId = [OpenUDID value];
    NSString* code = [[NSString stringWithFormat:@"%@%@%@%d", deviceId, CHANNEL, API_KEY, rd] md5HexDigest];
    //add jianfei han
    UserSettings* user = [AppDelegate getAppDelegate].user;
    NSMutableString* url=nil;
    if(user.nickname)
    {
        url= [NSMutableString stringWithFormat:@"http://%@/vpnn?_method=profile&deviceId=%@&name=%@&platform=%@&osversion=%@&connType=%@&carrier=%@&mcc=%@&mnc=%@&install=%d&apn=%@&appid=%d&chl=%@&rd=%d&code=%@&ver=%@%@&username=%@&deviceToken=%@&servicetype=%@&interfable=%@", P_HOST, device.deviceId, [device.hardware encodeAsURIComponent], [device.platform encodeAsURIComponent], [device.version encodeAsURIComponent], type,
              carrier ? [carrier.carrierName encodeAsURIComponent] : @"",
              carrier ? carrier.mobileCountryCode : @"",
              carrier ? carrier.mobileNetworkCode : @"",
              isInstall ? 1 : 0,
              apn && [apn length] > 0 ? [apn encodeAsURIComponent] : @"",2,CHANNEL, rd, code, API_VER,
              idcCode ? [NSString stringWithFormat:@"&area=%@", idcCode] : @"",[user.nickname encodeAsURIComponent],deviceToken,
              profiletype? profiletype :@"" ,interfable];
        
    }
    else
    {
        url = [NSMutableString stringWithFormat:@"http://%@/vpnn?_method=profile&deviceId=%@&name=%@&platform=%@&osversion=%@&connType=%@&carrier=%@&mcc=%@&mnc=%@&install=%d&apn=%@&appid=%d&chl=%@&rd=%d&code=%@&ver=%@%@&deviceToken=%@&servicetype=%@&interfable=%@", P_HOST, device.deviceId, [device.hardware encodeAsURIComponent], [device.platform encodeAsURIComponent], [device.version encodeAsURIComponent], type,
               carrier ? [carrier.carrierName encodeAsURIComponent] : @"",
               carrier ? carrier.mobileCountryCode : @"",
               carrier ? carrier.mobileNetworkCode : @"",
               isInstall ? 1 : 0,
               apn && [apn length] > 0 ? [apn encodeAsURIComponent] : @"",2,CHANNEL, rd, code, API_VER,
               idcCode ? [NSString stringWithFormat:@"&area=%@", idcCode] : @"",deviceToken ,profiletype? profiletype :@"" ,interfable];
        
    }
    if ( nextPage && [nextPage length] > 0 )
    {
        [url appendFormat:@"&nextPage=%@", [nextPage encodeAsURIComponent]];
    }
    
    return url;
}

/*
 *新接口这个接口带有 自动 和 手动 两种模式
 */
//+ (void)installProfile:(NSString *)nextPage vpnn:(NSString*)voaName
//{
//    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
//    UserSettings *user = [UserSettings currentUserSettings];
//    
//    NSLog(@"user.profileType ===================== %@",user.profileType);
//    
//    if ([user.profileType isEqualToString:@"apn"]) {
//        if ( voaName && [voaName length] > 0 ) {
//            [userDefault setObject:voaName forKey:@"apnName"];
//        }
//        else {
//            [userDefault removeObjectForKey:@"apnName"];
//        }
//    }else if([user.profileType isEqualToString:@"vpn"]){
//        if ( voaName && [voaName length] > 0 ) {
//            [userDefault setObject:voaName forKey:@"vpnName"];
//        }
//        else {
//            [userDefault removeObjectForKey:@"vpnName"];
//        }
//
//    }
//    [userDefault synchronize];
//    
//    NSString* url = [AppDelegate getInstallURL:nextPage install:YES vpn:voaName idc:nil servicetype:user.profileType];
//    NSLog(@"url=%@", url);
//	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
//}
//
//
//+ (NSString*) getInstallURL:(NSString*)nextPage install:(BOOL)isInstall vpn:(NSString*)apn idc:(NSString*)idcCode servicetype:(NSString *)profiletype
//{
//    DeviceInfo* device = [DeviceInfo deviceInfoWithLocalDevice];
//    NSString* type = [UIDevice connectionTypeString];
//    NSString* deviceToken =  [[NSUserDefaults standardUserDefaults] stringForKey:@"deviceToken"];
//    CTTelephonyNetworkInfo* tni = [[CTTelephonyNetworkInfo alloc] init];
//    CTCarrier* carrier = tni.subscriberCellularProvider;
//    [tni release];
//    
//    int rd = ((double) rand() / RAND_MAX) * 10000; //随机数
//    
//    NSString* deviceId = [OpenUDID value];
//    NSString* code = [[NSString stringWithFormat:@"%@%@%@%d", deviceId, CHANNEL, API_KEY, rd] md5HexDigest];
//    //add jianfei han
//    UserSettings* user = [AppDelegate getAppDelegate].user;
//    NSMutableString* url=nil;
//    if(user.nickname)
//    {
//        url= [NSMutableString stringWithFormat:@"http://%@/vpnn?_method=profile&deviceId=%@&name=%@&platform=%@&osversion=%@&connType=%@&carrier=%@&mcc=%@&mnc=%@&install=%d&apn=%@&appid=%d&chl=%@&rd=%d&code=%@&ver=%@%@&username=%@&deviceToken=%@&servicetype=%@", P_HOST, device.deviceId, [device.hardware encodeAsURIComponent], [device.platform encodeAsURIComponent], [device.version encodeAsURIComponent], type,
//              carrier ? [carrier.carrierName encodeAsURIComponent] : @"",
//              carrier ? carrier.mobileCountryCode : @"",
//              carrier ? carrier.mobileNetworkCode : @"",
//              isInstall ? 1 : 0,
//              apn && [apn length] > 0 ? [apn encodeAsURIComponent] : @"",2,CHANNEL, rd, code, API_VER,
//              idcCode ? [NSString stringWithFormat:@"&area=%@", idcCode] : @"",[user.nickname encodeAsURIComponent],deviceToken,
//              profiletype? profiletype :@"" ];
//        
//    }
//    else
//    {
//        url = [NSMutableString stringWithFormat:@"http://%@/vpnn?_method=profile&deviceId=%@&name=%@&platform=%@&osversion=%@&connType=%@&carrier=%@&mcc=%@&mnc=%@&install=%d&apn=%@&appid=%d&chl=%@&rd=%d&code=%@&ver=%@%@&deviceToken=%@&servicetype=%@", P_HOST, device.deviceId, [device.hardware encodeAsURIComponent], [device.platform encodeAsURIComponent], [device.version encodeAsURIComponent], type,
//               carrier ? [carrier.carrierName encodeAsURIComponent] : @"",
//               carrier ? carrier.mobileCountryCode : @"",
//               carrier ? carrier.mobileNetworkCode : @"",
//               isInstall ? 1 : 0,
//               apn && [apn length] > 0 ? [apn encodeAsURIComponent] : @"",2,CHANNEL, rd, code, API_VER,
//               idcCode ? [NSString stringWithFormat:@"&area=%@", idcCode] : @"",deviceToken ,profiletype? profiletype :@"" ];
//        
//    }
//    if ( nextPage && [nextPage length] > 0 )
//    {
//        [url appendFormat:@"&nextPage=%@", [nextPage encodeAsURIComponent]];
//    }
//    
//    return url;
//}

+ (void) installProfile:(NSString*)nextPage
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSString* apnName = [userDefault objectForKey:@"apnName"];
    [self installProfile:nextPage vpnn:apnName interfable:@"0"  ];
}


+ (void) uninstallProfile:(NSString*)nextPage
{
    
    NSString *url ;
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    if ( user.proxyFlag == INSTALL_FLAG_APN_WRONG_IDC ) {
         url = [AppDelegate getInstallURL:nextPage install:NO vpn:@"apn" idc:nil servicetype:nil interfable:@"0"];
    }
    else {
        url = [AppDelegate getInstallURL:nextPage install:NO vpn:@"apn" idc:nil servicetype:nil interfable:@"0"];
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    
    //    InstallProfileViewController* controller = [[InstallProfileViewController alloc] init];
    //    [[[AppDelegate getAppDelegate] currentNavigationController] pushViewController:controller animated:YES];
    //    [controller release];
}


- (void) switchUser
{
    self.refreshDatasave = YES;
    self.refreshDatastats = YES;
    
    [DBConnection clearDB];
}
- (void) getMemberInfo
{
    //访问getMemberInfo接口
    operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue setMaxConcurrentOperationCount:1];
    NSInvocationOperation* operation = [[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(requestMemberInfo) object:nil] autorelease];
    [operationQueue addOperation:operation];
}


- (void) requestMemberInfo
{
    Reachability* reachablity = [Reachability reachabilityWithHostName:P_HOST];
    if ( [reachablity currentReachabilityStatus] == NotReachable ) return;
    
    [TwitterClient getMemberInfoSync];
    
    UIDevice* device = [UIDevice currentDevice];
    if ( [device isJailbroken] ) {
        
        //对于越狱的手机，上传安装的应用信息
        [self uploadAppInfo];
    }
}

+(void)setLabelFrame:(UILabel *)label1 label2:(UILabel*)label2
{
    CGSize mbDataFrame = [label1.text sizeWithFont:label1.font constrainedToSize:CGSizeMake(320, 999) lineBreakMode:UILineBreakModeWordWrap];
    label1.frame =CGRectMake(label1.frame.origin.x,label1.frame.origin.y,mbDataFrame.width,label1.frame.size.height);
    
    label2.frame=CGRectMake(label1.frame.origin.x+label1.frame.size.width+2, label2.frame.origin.y, label2.frame.size.width, label2.frame.size.height);
}
- (void) startLocationManager
{
    [locationManager startManager];
}


- (void) stopLocationManager
{
    [locationManager stopManager];
}
+ (Reachability*) getNetworkReachablity
{
    Reachability* reachable = [Reachability reachabilityWithHostName:P_HOST];
    return reachable;
}


+ (BOOL) networkReachable
{
    Reachability* reachablity = [Reachability reachabilityWithHostName:P_HOST];
    if ( [reachablity currentReachabilityStatus] == NotReachable ) {
        return NO;
    }
    else {
        return YES;
    }
}
+ (void) showHelp
{
    //NSString* url = @"http://p.flashapp.cn/faq.html";
    NSString *url = [NSString stringWithFormat:@"file://%@/%@",[[NSBundle mainBundle] bundlePath],@"flashapp/faq/faq.html" ];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}


+ (void) showUserReviews
{
    NSString *str = [NSString stringWithFormat:
                     @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",
                     APPID ];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}


- (void) showDatasaveView:(BOOL)justInstallProfile
{
    //       time_t now;
    //    time(&now);
    //    time_t peroid[2];
    //    [TCUtils getPeriodOfTcMonth:peroid time:now];
    ViewController *viewController =  [ViewController getSelfViewController];
    navController=[[UINavigationController alloc]initWithRootViewController:viewController];
    self.window.rootViewController = navController;
    
    [navController release];
}


- (void) showSetupView
{
    LaunchViewController *lanuchController = [[LaunchViewController alloc]init];
    if(navController==nil)
    {
        navController=[[UINavigationController alloc]initWithRootViewController:lanuchController];
    }
    DeviceInfo* device = [DeviceInfo deviceInfoWithLocalDevice];
    float version = [device.version floatValue];
    if ( version >= 4.0 ) {
        self.window.rootViewController =  navController;
    }
    else {
        [self.window addSubview: navController.view];
    }
    [lanuchController release];
    [navController release];
    
}

/*
 *判断VPN是开启还是关闭
 *return YES 开启 ， return NO 关闭；
 */
+(BOOL)pdVpnIsOpenOrClose
{
    GetAddress* ga = [[GetAddress alloc] init];
    BOOL vpnStarted = NO;
    [ga getIPAddress];
    NSArray* ipNames = ga.ipNames;
    NSArray* ifNames = ga.ifNames;
    int len = [ipNames count];
    NSString* ifName;
    NSString* ipName;
    for ( int i=0; i<len; i++ ) {
        ifName = [ifNames objectAtIndex:i];
        ipName = [ipNames objectAtIndex:i];
        NSRange r = [ifName rangeOfString:@"utun"];
        if ( r.location == NSNotFound ) {
            continue;
        }
        else {
            vpnStarted  = YES;
            break;
        }
    }
    [ga release];
    return vpnStarted;
}


#pragma mark - application delegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    timerTaskLock = [[NSObject alloc] init];
    timerTaskDoing = NO;
    
    refreshingLock = [[NSLock alloc] init];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    //注册微信
    [WXApi registerApp:@"wx0d70d827b4ee5ad2"];
    
    //注册Flurry
    [Flurry startSession:@"X5GH7TJ735Z82Q7M2N9M"];
    [Flurry logEvent:@"USER_OPEN_APP"]; //统计软件开启次数
    //统计渠道
    BOOL flurry_channel = [[NSUserDefaults standardUserDefaults] boolForKey:@"flurry_channel"];
    if (!flurry_channel) {
        [Flurry logEvent:@"APP_CHANNEL" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:CHANNEL ,@"channel_name" ,nil]];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"flurry_channel"];
    }
    
    
    BOOL versionUpgrade = NO;
    NSString* version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
    NSLog(@"++++++++++++++++didFinishLaunchingWithOptions,version=%@", version);
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* oldVersion = [userDefaults objectForKey:@"version"];
    if ( !oldVersion ) {
        [userDefaults setObject:version forKey:@"version"];
        [userDefaults synchronize];
        oldVersion = @"0";
        versionUpgrade = YES;
    }
    else {
        if ( [version compare:oldVersion] != NSOrderedSame ) {
            [userDefaults setObject:version forKey:@"version"];
            [userDefaults synchronize];
            
            //1.3之后的版本，通过SQL语句升级版本，不需要更新数据库
            if ( [oldVersion compare:@"1.3"] == NSOrderedAscending ) {
                versionUpgrade = YES;
            }
            else {
                versionUpgrade = NO;
            }   
        }
    }
    
    [userDefaults setObject:@"YES" forKey:@"loginStatus"];
        
    //初始化user类，单例
    self.user = [UserSettings currentUserSettings];
    
    //sim 卡信息
    CTTelephonyNetworkInfo* tni = [[CTTelephonyNetworkInfo alloc] init];
    self.carrier = tni.subscriberCellularProvider;
    [tni release];
    
    //initialize database
    [self initDatabase:versionUpgrade];
    
    if ( !versionUpgrade ) {
        [self execUpgradeSQL:version oldVersion:oldVersion];
    }
    
    //创建应用推荐分类的数据库
    [AppRecommendDao createAppRecommendTable];
    
    //查看是否有新的应用推荐
    [self ifNewApp];

    
    self.refreshDatastats = NO;
    self.refreshDatasave = YES;
    
    self.networkReachablity = [Reachability reachabilityWithHostName:P_HOST];
    [self.networkReachablity startNotifier];
    
    connType = [UIDevice connectionType];
    /*DeviceInfo* deviceInfo = nil;
     if ( currentCapacity == 0 ) {
     if ( connType == CELL_2G || connType == CELL_3G || connType == CELL_4G || connType == WIFI || connType == ETHERNET ) {
     deviceInfo = [self getDeviceInfo];
     }
     }*/
    
    proxySlow = NO;
    
    
    
    //显示程序开启页面 ， 提示安装描述文件，和欢迎界面都在这里面设置的
    [self showSetupView];
    
    [self.window makeKeyAndVisible];

    //注册通知
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];    
    
    locationManager = [[TCLocationManager alloc] init];
    BOOL b = [[NSUserDefaults standardUserDefaults] boolForKey:UD_LOCATION_ENABLED];
    if ( b ) {
        if ( ![CLLocationManager locationServicesEnabled] ) {
            b = NO;
        }
        else if ( [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized ) {
            b = NO;
        }
        
        if ( b ) {
            [locationManager startManager];
        }
        else {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:UD_LOCATION_ENABLED];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if ( userInfo ) {
        [self performSelector:@selector(processRemoteNotification:) withObject:userInfo afterDelay:0.5f];
        //[self performSelectorOnMainThread:@selector(processRemoteNotification:) withObject:userInfo waitUntilDone:NO];
    }
        
    refreshThread = [[NSThread alloc] initWithTarget:self selector:@selector(runRefresh:) object:nil];
    [refreshThread start];
    
    //add by fangzhen notification  cancel ApplicationIconBadgeNumber  
    [application setApplicationIconBadgeNumber:0];
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    //这里就不要发送通知了，这个通知叫 viewController 的 - viewDidAppear 去发送吧。错误，这里还是要发送，应为我程序运行到后台再起来的时候要接收通知
//    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshNotification object:nil];
    UIViewController* controller = [self currentViewController];
    if ( [controller isKindOfClass:[FlowJiaoZhunViewController class]] ) {
        FlowJiaoZhunViewController* flowJiaoZhunViewController = (FlowJiaoZhunViewController*) controller;
        [flowJiaoZhunViewController  loadDingWei];
    }
    if ( [controller isKindOfClass:[SetingViewController class]] ) {
        SetingViewController* setingViewController = (SetingViewController*) controller;
        [setingViewController.setTableView reloadData];
    }
    
    NSLog(@"++++++++++++++applicationDidBecomeActive");
    float currentCapacity = [UserSettings currentCapacity];
    if ( currentCapacity > 0 ) {
        
        //增加用户限额用的。
        [self incrDayCapacity];
        
        //访问getMemberInfo接口 ，获取用户限额和级别
        [self getMemberInfo];
    }
    
    //add by fangzhen notification  cancel     
    NotificationUtils *nt = [[NotificationUtils alloc]autorelease];
    [nt onOrOff:NO];
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"logoutDate"];
     [Prefs setArray:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
     //add by fangzhen notification  add
    NSDate *nowDate = [[[NSDate alloc] init] autorelease];
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nowDate forKey:@"logoutDate"];
    [userDefaults setObject:@"YES" forKey:@"background"];
    
   
    NotificationUtils *nt = [[NotificationUtils alloc]autorelease];
    [nt onOrOff:YES];
    mArray=[[NSMutableArray alloc]init];
    [mArray addObjectsFromArray:[nt mArray]];
    

    
    [Flurry logEvent:@"APP_GO_BACKGROUND"];//应用程序被挂起的次数
}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    return [TencentOAuth HandleOpenURL:url];
//}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    NSString* urlString = [url absoluteString];
    NSLog(@"application:handleOpenURL: %@", urlString);
    //?取消的情况下如何调用？
    
    if ( !user ) self.user = [UserSettings currentUserSettings];
    
    NSRange range = [urlString rangeOfString:@"speedit://"];
    if ( range.location == 0 ) {
        NSString* page = [urlString substringFromIndex:10];//截取前缀之后的url
        
        if ( [page length] > 0 )
        {
            NSDictionary* params = [TwitterClient urlParameters:page]; //跳转回来后 返回给我的一个字典
            NSArray* array = [page componentsSeparatedByString:@"?"];
            NSString* queryString = nil;
            if ( [array count] > 1 )
            {
                page = [array objectAtIndex:0];
                queryString = [array objectAtIndex:1];
            }
            
            //profile已经安装
            if ( queryString ) {
                NSString* setInstall = [params objectForKey:@"setInstall"];//setInstall 1:安装服务，0：取消服务
                NSString* status = [params objectForKey:@"status"];
                NSString* capacity = [params objectForKey:@"quantity"];
                
                //判断是否在审核， 1.在审核  ; 2.没在审核
                [UserSettings saveInchk:[params objectForKey:@"inchk"]];
                
                user.capacity = [capacity floatValue];
                user.status = [status intValue];
                
                
                NSString*apnnn=[params objectForKey:@"apn"];
                NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
                if ( apnnn && [apnnn length] > 0 ) {
                    [userDefault setObject:apnnn forKey:@"apnName"];
                }
                
                
                NSString* server = [params objectForKey:@"svr"];
                if ( server && server.length > 0 ) {
                    user.idcServer = server;
                }
                
                NSString* proxyServer = [params objectForKey:@"domain"];
                if ( proxyServer && proxyServer.length > 0 ) {
                    user.proxyServer = proxyServer;
                }
                
                NSString* proxyPort = [params objectForKey:@"port"];
                if ( proxyPort && proxyPort.length > 0 ) {
                    user.proxyPort = [proxyPort intValue];
                }
                
                if ( [@"1" compare:setInstall] == NSOrderedSame ) { // 1 是安装， 0 取消
                    //设置 stype 这个属性，
                    NSString *stype = [params objectForKey:@"stype"];
                    if (stype && stype.length > 0) {
                        [userDefault setObject:stype forKey:@"stype"];
                        user.profileType = stype ;
                    }
                    
                    if ([user.profileType isEqualToString:@"vpn"]) {
                        
                        user.proxyFlag = INSTALL_FLAG_VPN_RIGHT_IDC_PAC;
                        
                    }else if ([user.profileType isEqualToString:@"apn"]){
                        
                        user.proxyFlag = INSTALL_FLAG_APN_RIGHT_IDC;
                        
                    }
                    
                    
                    [UserSettings saveCapacity:[capacity floatValue] status:[status intValue] proxyFlag:user.proxyFlag profileType:user.profileType];
                }
                else {
                    [UserSettings saveCapacity:[capacity floatValue] status:[status intValue] proxyFlag:INSTALL_FLAG_NO profileType:user.profileType];
                    user.proxyFlag = INSTALL_FLAG_NO;
                }
            }
            
            
            /*if ( [@"register" compare:page] == NSOrderedSame ) {
             [self showRegisterView];
             return YES;
             }
             if ( [@"datasave" compare:page] == NSOrderedSame ) {
             UIViewController* controller = [self currentViewController];
             if ( [controller isKindOfClass:[DataServiceViewController class]] ) {
             DataServiceViewController* dataController = (DataServiceViewController*) controller;
             [dataController showConnectMessage];
             }
             return YES;
             }
             else {
             UIViewController* controller = [self currentViewController];
             if ( [controller isKindOfClass:[DataServiceViewController class]] ) {
             DataServiceViewController* dataController = (DataServiceViewController*) controller;
             [dataController showConnectMessage];
             }
             return YES;
             }*/
            
            if ( [@"datasave" compare:page] == NSOrderedSame ) {
                 UIViewController* controller = [self currentViewController];
                if ( [controller isKindOfClass:[ViewController class]] ) {
                    ViewController* viewC = (ViewController*) controller;
                    [viewC  refreshBtnPress:nil];
                    [self showSetupView];
                }
            }
            else {
                UIViewController* controller = [self currentViewController];
                //如果是setting界面，则需要刷新服务状态
                if ( [controller isKindOfClass:[SetingViewController class]] ) {
                    SetingViewController* settingController = (SetingViewController*) controller;
                    [settingController  refresh];
                    [settingController.navigationController popViewControllerAnimated:YES];                    
                }
                else if ( [controller isKindOfClass:[WangSuViewController class]] ) {
                    WangSuViewController* wangSuViewController = (WangSuViewController*) controller;
                    [wangSuViewController relfresh];
                }
                else if ([controller isKindOfClass:[OpenServeViewController class]]){
                    OpenServeViewController *vpnHelp = (OpenServeViewController *)controller;
                    [vpnHelp.navigationController popViewControllerAnimated:NO];
                }else if ([controller isKindOfClass:[ViewController class]] ) {
                    ViewController* viewC = (ViewController*) controller;
                    [viewC  refreshBtnPress:nil];
                }
//                else if ( [controller isKindOfClass:[HelpNetBadViewController class]] ) {
//                    HelpNetBadViewController* helpController = (HelpNetBadViewController*) controller;
//                    [helpController refreshProfileStatus];
//                }
//                else if ( [controller isKindOfClass:[HelpCompressViewController class]] ) {
//                    HelpCompressViewController* helpController = (HelpCompressViewController*) controller;
//                    [helpController check];
               // }
            }
            
            return YES;
        }
    }
    
    NSRange qqLoginRang = [urlString rangeOfString:@"tencent100379557"] ;
    
    if (qqLoginRang.length > 0 ) {
        return [TencentOAuth HandleOpenURL:url];
    }
    
    //For微信SDK
    return  [WXApi handleOpenURL:url delegate:self];
    //    return YES;
}

#pragma mark -- APNS Notification
- (void) application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString* s = [deviceToken description];
    s = [s stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    s = [s stringByReplacingOccurrencesOfString:@" " withString:@""];

#ifdef DEBUG_My
    if(DEBUG_My)
    {
        s=[NSString stringWithFormat:@":%@",s];
        NSLog(@"debug deviceToken=%@", s);

    }
#endif
    NSLog(@"release deviceToken=%@", s);

    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:s forKey:@"deviceToken"];
    [userDefault synchronize];
}


- (void) application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    if ( error ) {
        if ( [error localizedDescription] ) {
            NSLog( @"++++++++++++++++1Faild to get token:%@", [error localizedDescription] );
        }
        if ( [error localizedFailureReason] ) {
            NSLog( @"++++++++++++++++2Faild to get token:%@", [error localizedFailureReason] );
        }
        if ( [error localizedRecoverySuggestion] ) {
            NSLog( @"++++++++++++++++3Faild to get token:%@", [error localizedRecoverySuggestion] );
        }
    }
    NSLog( @"++++++++++++++++4Faild to get token:%@", [error description] );
}

- (void) application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self performSelectorOnMainThread:@selector(processRemoteNotification:) withObject:userInfo waitUntilDone:NO];
}

- (void) processRemoteNotification:(NSDictionary*)userInfo
{

    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    NSString* type = [userInfo objectForKey:@"type"];
    
    pushNotifationType = nil;
    pushNotifationType = [[NSString stringWithFormat:@"%@",type]retain];

    if((state==UIApplicationStateActive || state==UIApplicationStateInactive ))
    {
        NSString *cancelTitle = @"取消";
        NSString *showTitle = @"确定";
        NSString *message = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"加速宝"
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:cancelTitle
                                                  otherButtonTitles:showTitle, nil];
        [alertView show];
        [alertView release];

    }
    else
    {
        if ( [@"init" compare:pushNotifationType] == NSOrderedSame )
        {
            
        }
        else if ( [@"sns" compare:pushNotifationType] == NSOrderedSame )
        {
            
        }
        else if ( [@"invite" compare:pushNotifationType] == NSOrderedSame )
        {
            
        }
        else if ( [@"combo" compare:pushNotifationType] == NSOrderedSame )
        {
            JiaoZhunViewController *jiaoZhunViewController=[[[JiaoZhunViewController alloc]init] autorelease];
            [self.navController pushViewController:jiaoZhunViewController animated:NO];
        }
        else if ( [@"appm" compare:pushNotifationType] == NSOrderedSame ||[@"flowm" compare:pushNotifationType] == NSOrderedSame)
        {
            DetectionViewController*detectionViewController=[[[DetectionViewController alloc]init] autorelease];
            [[sysdelegate navController  ] pushViewController:detectionViewController animated:NO];
        }

    }

//    NSLog(@"user info ====%@",userInfo);
//    NSString* type = [userInfo objectForKey:@"type"];
//    if ( [@"comment" compare:type] == NSOrderedSame ) {
//        [AppDelegate showUserReviews];
//    }
//    else if ( [@"naviurl" compare:type] == NSOrderedSame ) {
//        UINavigationController* currNav = [self currentNavigationController];
//        if ( currNav ) {
//            NSString* url = [userInfo objectForKey:@"url"];
//            NSString* title = [userInfo objectForKey:@"title"];
//            if ( !title ) title = NSLocalizedString(@"AppDelegate.processRemoteNotification.title", nil);
//            HelpViewController* controller = [[HelpViewController alloc] init];
//            controller.showCloseButton = YES;
//            controller.page = url;
//            controller.title = title;
//            UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:controller];
//            [currNav presentModalViewController:nav animated:YES];
//            [controller release];
//            [nav release];
//        }
//    }
//    else {
//        [AppDelegate showAlert:@"hahaha"];
//    }
}

#pragma mark - alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        
        if ( [@"init" compare:pushNotifationType] == NSOrderedSame )
        {

        }
        else if ( [@"sns" compare:pushNotifationType] == NSOrderedSame )
        {

        }
        else if ( [@"invite" compare:pushNotifationType] == NSOrderedSame )
        {

        }
        else if ( [@"combo" compare:pushNotifationType] == NSOrderedSame )
        {
            JiaoZhunViewController *jiaoZhunViewController=[[[JiaoZhunViewController alloc]init] autorelease];
            [self.navController pushViewController:jiaoZhunViewController animated:NO];
        }
        else if ( [@"appm" compare:pushNotifationType] == NSOrderedSame ||[@"flowm" compare:pushNotifationType] == NSOrderedSame)
        {
            DetectionViewController*detectionViewController=[[[DetectionViewController alloc]init] autorelease];
            [[sysdelegate navController  ] pushViewController:detectionViewController animated:NO];
        }
        else if ( ([@"eightStats" compare:pushNotifationType] == NSOrderedSame) ||( [@"hundredStats" compare:pushNotifationType] == NSOrderedSame ))
        {
            TaoCanViewController *taoCanViewController=[[TaoCanViewController alloc]init];
            [self.navController pushViewController:taoCanViewController animated:NO];
            
        }else if([@"weekPost" compare:pushNotifationType]  == NSOrderedSame){
            [self.navController popViewControllerAnimated:YES];
        }


    }
    NSLog(@"button index %d",buttonIndex);
}
#pragma mark - refresh timer methods

- (void) runRefresh:(void*)unused
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:60];
    NSTimer* timer = [[[NSTimer alloc] initWithFireDate:date interval:1800 target:self selector:@selector(timerTask) userInfo:nil repeats:YES] autorelease];
    [runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
    
    [runLoop run];
    [pool release];
}


/*
 - (void) startTimer
 {
 timer = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(timerTask) userInfo:nil repeats:YES];
 [timer fire];
 }*/


- (void) timerTask
{
//    UIViewController *viewConttroll = (UIViewController *)[ViewController getSelfViewController];
    if ( timerTaskDoing ) return;
    if ( [networkReachablity currentReachabilityStatus] != NotReachable ) {
        @synchronized (timerTaskLock) {
            if ( !timerTaskDoing ) {
                timerTaskDoing = YES;
                
                [TCUtils readIfData:-1];
                [TwitterClient getStatsData]; //刷新接口
                
                InstallFlag proxyFlag = user.proxyFlag;
                connType = [UIDevice connectionType];
                if ( (proxyFlag == INSTALL_FLAG_APN_RIGHT_IDC ||proxyFlag == INSTALL_FLAG_VPN_RIGHT_IDC_PAC) && (connType == CELL_2G || connType == CELL_3G || connType == CELL_4G) ) {
                    proxySlow = [self proxyServerSlow];
                }
                else {
                    proxySlow = NO;
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:RefreshNotification object:nil];
                
                timerTaskDoing = NO;
            }
        }
    }
}
- (BOOL) proxyServerSlow
{
    NSString* proxyServer = user.proxyServer;
    int proxyPort = user.proxyPort;
    
    if ( proxyPort == 0 || proxyServer.length == 0 ) return NO;
    
    long long myDuration = 0;
    long long baiduDuration = 0;
    
    for ( int i=0; i<3; i++ ) {
        //通过socket访问代理服务器，并记录时长
        long long time1 = [DateUtils millisecondTime];
        [TFConnection connectSocket:user.proxyServer port:proxyPort];
        long long time2 = [DateUtils millisecondTime];
        
        //如果访问代理服务器时长小于500毫秒，则认为速度正常，返回NO
        myDuration += time2 - time1;
        if ( myDuration < 500 ) return NO;
        
        //通过socket访问baidu，并记录时长
        NSString* otherServer = @"www.baidu.com";
        int otherPort = 80;
        [TFConnection connectSocket:otherServer port:otherPort];
        time1 = [DateUtils millisecondTime];
        baiduDuration += time1 - time2;
    }
    
    //如果访问代理服务器的时间，大于访问baidu所用时间的4倍，则认为代理服务器太慢，返回YES
    //否则认为代理服务器速度正常，返回NO
    if ( myDuration > baiduDuration * 4.0 ) {
        return YES;
    }
    else {
        return NO;
    }
}


#pragma mark - bussiness methods

- (void) initDatabase:(BOOL)versionUpgrade
{
    BOOL forceCreate = NO;
    if ( versionUpgrade ) {
        forceCreate = YES;
    }
    else {
        forceCreate = [[NSUserDefaults standardUserDefaults] boolForKey:@"dropDatabase"];
    }
    //forceCreate = YES;
    
    self.dbWriteLock = [[[NSObject alloc] init] autorelease];
    
    [DBConnection createEditableCopyOfDatabaseIfNeeded:forceCreate];
    [DBConnection getDatabase];
}


- (int) execUpgradeSQL:(NSString*)newVersion oldVersion:(NSString*)oldVersion
{
    if ( [newVersion compare:oldVersion] == NSOrderedSame ) return SQLITE_OK;
    if ( [@"0" compare:oldVersion] == NSOrderedSame ) return SQLITE_OK;
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"sql" ofType:@"plist"];
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSArray* versions = [[dic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSArray* sqls;
    char* error;
    int ret;
    ret = SQLITE_OK;
    
    [DBConnection beginTransaction];
    for ( NSString* v in versions ) {
        NSLog(@"version=%@", v);
        if ( [v compare:oldVersion] == NSOrderedDescending &&
            ([v compare:newVersion] == NSOrderedAscending || [v compare:newVersion] == NSOrderedSame) ) {
            sqls = [dic objectForKey:v];
            for ( NSString* sql in sqls ) {
                NSLog(@"sql=%@", sql);
                ret = [DBConnection execute:(char*)[sql UTF8String] errmsg:&error];
                if ( ret != SQLITE_OK ) {
                    break;
                }
            }
        }
        
        if ( ret != SQLITE_OK ) break;
    }
    
    if ( ret == SQLITE_OK ) {
        [DBConnection commitTransaction];
    }
    else {
        [DBConnection rollbackTransaction];
    }
    return ret;
}

+ (time_t) getLastAccessLogTime
{
    time_t lastDayLong = 0;
    NSNumber* number = [[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_LOG_LAST_TIME];
    if ( number ) {
        lastDayLong = (time_t) ([number longLongValue] / 1000);
    }
    else {
        lastDayLong = [StatsDayDAO getLastDay];
    }
    return lastDayLong;
}

- (UIViewController*) currentViewController
{
    return [self.navController topViewController];
}
+(void)labelShadow:(UILabel*)label
{
    label.layer.shadowColor = [[UIColor blackColor] CGColor];
    label.layer.shadowOffset = CGSizeMake(0.0, 0);
    label.layer.masksToBounds = NO;
    
    label.layer.shadowRadius = 1.0f;
    label.layer.shadowOpacity =0.95;
}
+(void)buttonTopShadow:(UIButton*)button shadowColor:(UIColor*)color
{
    [button setTitleShadowColor:color forState:UIControlStateNormal];
    [[button titleLabel]setShadowOffset:CGSizeMake(0, -1)];
}
#pragma mark - alterview animation methods

+(void)exChangeOut:(UIView *)changeOutView dur:(CFTimeInterval)dur
{
    
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = dur;
    //animation.delegate = self;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    [changeOutView.layer addAnimation:animation forKey:nil];
}
+ (AppDelegate*)getAppDelegate
{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

+(double)deviceSysVersion
{
    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
    return version;
}
+ (void) showAlert:(NSString*)message
{
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示"
														message:message
													   delegate:nil
											  cancelButtonTitle:@"确定"
											  otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}
+ (void) showAlert:(NSString*)title message:(NSString*)message
{
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title
														message:message
													   delegate:nil
											  cancelButtonTitle:@"确定"
											  otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

#pragma mark - 微信sdk


- (void) onReq:(BaseReq*)req
{
    
}


- (void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"发送结果"];
        NSString* strMsg = nil;
        if ( resp.errCode == 0 ) {
            strMsg = @"已经成功发送微信！";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }
    else if([resp isKindOfClass:[SendAuthResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"Auth结果"];
        NSString *strMsg = [NSString stringWithFormat:@"Auth结果:%d", resp.errCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    
}




- (void) uploadAppInfo
{
    NSMutableDictionary* currentApps = [[UIDevice currentDevice] getInstalledApps];
    NSString* jsonString = [self appInfoToJSONString:currentApps];
    
    BOOL r = [TwitterClient uploadAppInfoSync:jsonString];
    if ( r ) {
        NSMutableDictionary* lastApps = [NSMutableDictionary dictionary];
        NSArray* keys = [currentApps allKeys];
        AppInfo* app;
        for ( NSString* key in keys ) {
            app = [currentApps objectForKey:key];
            [lastApps setObject:app.bundleID forKey:key];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:lastApps forKey:@"apps"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


- (NSString*) appInfoToJSONString:(NSDictionary*)currentApps
{
    NSMutableDictionary* lastApps = [[NSUserDefaults standardUserDefaults] objectForKey:@"apps"];
    
    NSMutableString* addString = [NSMutableString string];
    [addString appendString:@"["];
    
    NSMutableString* updateString = [NSMutableString string];
    [updateString appendString:@"["];
    
    NSMutableString* deleteString = [NSMutableString string];
    [deleteString appendString:@"["];
    
    NSArray* keys = [currentApps allKeys];
    AppInfo* currentAppInfo;
    //AppInfo* lastAppInfo;
    NSString* lastAppInfo;
    
    for ( NSString* key in keys ) {
        currentAppInfo = (AppInfo*) [currentApps objectForKey:key];
        lastAppInfo = [lastApps objectForKey:key];
        [lastApps removeObjectForKey:key];
        
        if ( !lastAppInfo ) {
            [addString appendFormat:@"{%@},", [currentAppInfo briefJsonString]];
        }
        //else if ( ![currentAppInfo isSame:lastAppInfo] ) {
        //    [updateString appendFormat:@"{%@},", [currentAppInfo briefJsonString]];
        //}
    }
    
    keys = [lastApps allKeys];
    for ( NSString* key in keys ) {
        lastAppInfo = [lastApps objectForKey:key];
        //[deleteString appendFormat:@"{%@},", [lastAppInfo briefJsonString]];
        [deleteString appendFormat:@"{id:'%@',name:'',ver:''},", lastAppInfo];
    }
    
    if ( addString.length > 1 ) {
        NSRange range;
        range.location = addString.length - 1;
        range.length = 1;
        [addString deleteCharactersInRange:range];
    }
    [addString appendString:@"]"];
    
    if ( updateString.length > 1 ) {
        NSRange range;
        range.location = updateString.length - 1;
        range.length = 1;
        [updateString deleteCharactersInRange:range];
    }
    [updateString appendString:@"]"];
    
    if ( deleteString.length > 1 ) {
        NSRange range;
        range.location = deleteString.length - 1;
        range.length = 1;
        [deleteString deleteCharactersInRange:range];
    }
    [deleteString appendString:@"]"];
    
    NSString* jsonString = [NSString stringWithFormat:@"{deviceid:'%@', add:%@, update:%@, delete:%@}", [OpenUDID value], addString, updateString, deleteString];
    
    return jsonString;
}
- (void) incrDayCapacity
{
    time_t now;
    time( &now );
    NSString* day = [DateUtils stringWithDateFormat:now format:@"yyyyMMdd"];
    
    if ( user.day ) {
        if ( [day compare:user.day] == NSOrderedSame ) {
            if ( user.dayCapacity < QUANTITY_DAY_LIMIT ) {
                user.dayCapacity += 1;
                user.dayCapacityDelta += 1;
                user.capacity += QUANTITY_PER_OPEN;
            }
        }
        else {
            user.day = day;
            user.dayCapacity = 1;
            user.dayCapacityDelta += 1;
            user.capacity += QUANTITY_PER_OPEN;
        }
    }
    else {
        user.day = day;
        user.dayCapacity = 0;
        user.dayCapacityDelta = 0;
    }
    [UserSettings saveUserSettings:user];
}

#pragma mark-Loading M
-(void)showLockView:(NSString*)message;
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navController.topViewController.view animated:YES];//add 2012-12-07
    hud.labelText = message;
    [self.navController.topViewController.view bringSubviewToFront:hud];
    [self performSelector:@selector(productLoadFailed) withObject:nil afterDelay:30.0];
}

-(void)hideLockView
{    
    [MBProgressHUD hideHUDForView:self.navController.topViewController.view animated:YES];//add 2012-12-07
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(productLoadFailed) object:nil];
    
}
-(void)productLoadFailed
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navController.topViewController.view animated:YES];//add 2012-12-07
    hud.labelText = @"加载失败,请检查网络状况";
    //hud.detailsLabelText = @"";
    [self hideLockView];
}

#pragma mark-notification
//add by fangzhen
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    if(notification.userInfo){
        int number=((NSNumber*)[notification.userInfo objectForKey:@"number"]).intValue;
        NSLog(@"notification number:%d", number);
        NSString *no_type = [notification.userInfo objectForKey:@"type"];
        NSString *info = [notification.userInfo objectForKey:@"info"];
       // [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:no_type];
        pushNotifationType = nil;
        pushNotifationType = [[NSString stringWithFormat:@"%@",no_type]retain];
           
        UIApplicationState state = [UIApplication sharedApplication].applicationState;
        //NSString *background = [[NSUserDefaults standardUserDefaults] objectForKey:@"background"];
       // NSLog(@"background:%@",background);
//        if(state==UIApplicationStateActive  )
//        {
//            NSString *cancelTitle = @"取消";
//            NSString *showTitle = @"确定";
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"加速宝"
//                                                        message:info
//                                                        delegate:self
//                                                        cancelButtonTitle:cancelTitle
//                                                        otherButtonTitles:showTitle, nil];
//            [alertView show];
//            [alertView release];
//                
//        }else{
        
            //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"background"];
        if(state != UIApplicationStateActive  ){
            if([@"eightStats" isEqualToString:no_type] || [@"hundredStats" isEqualToString:no_type]){
                TaoCanViewController *taoCanViewController=[[TaoCanViewController alloc]init];
                [self.navController pushViewController:taoCanViewController animated:NO];
                
            }else{
                NotificationUtils *nt = [[NotificationUtils alloc]autorelease];
                [nt setMArray:mArray];
                [nt showNotification:number type:no_type info:info];
                
                
            }

        }
           
       // }
    }

}
@end
