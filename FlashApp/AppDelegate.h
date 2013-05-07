//
//  AppDelegate.h
//  FlashApp
//
//  Created by lidiansen on 12-12-13.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//
#define MJOY_91_APPID 9623
#define MJOY_91_APPKEY @"aac8eda4394d8be2a4b8767e1af2d556"

#define P_HOST @"p.flashapp.cn"
#define API_BASE @"http://p.flashapp.cn/api"
//#define P_HOST @"27.flashget.com"
//#define API_BASE @"http://27.flashget.com/api"
//#define P_HOST @"192.168.11.5"
//#define API_BASE @"http://192.168.11.5/api"

#define API_LOG_LOG_MEM @"accesslog/getAccessLogAndMember"
#define API_LOG_LOG @"accesslog/getAccesslog"
#define API_LOG_GETDEVICE @"accesslog/getDevice"
#define API_LOG_MEMBERINFO @"accesslog/getMemberInfo"
#define API_LOG_VERIFY @"accesslog/verified"
#define API_USER_GETCODE @"users/getCode"
#define API_USER_REGISTER @"users/regist"
#define API_USER_VERIFY @"users/verify"
#define API_USER_LOGIN @"users/login"
#define API_USER_MODIFY @"users/modefyInfo"
#define API_USER_MODIFY_PASSWD @"users/modefyPwd"
#define API_USER_RESET_PASSWD @"users/forgetPwd"
#define API_USER_91_INCRLIMIT @"users/addlmt"
#define API_FEEDBACK_FEEDBACK @"feedback/feedback"
#define API_COMBO_COMBOINFO @"combo/getComboInfo"
#define API_COMBO_CARRIERINFO @ "combo/getCarrierInfo"
#define API_IDC_ZLIST @"server/zlist"
#define API_IDC_SPEED @"server/speedtest"
#define API_APP_APPS @"apps/apps"
#define API_APP_APPS_3DES @"apps/apps2"
#define API_SETTING_DISABLEUA @"settngs/disableua"
#define API_SETTING_DISABLEUAS @"settngs/disableuas"

#define API_SETTING_RESETUA @"settngs/resetua"
#define API_SETTING_UA_IS_ENABLED @"settngs/uastatus"
#define API_SETTING_UA_ALL_ENABLED @"settngs/uastatusa"

#define API_SETTING_IMAGE_QUALITY @"settngs/imgquality"

#define URL_SHARE @"/loginsns/share/device.jsp"

#define APP_ID 1
#define API_KEY @"30efb1a621c4bd711652ecafb7cbd3673a062b3f"
#define API_VER @"1.5.4"

#define RefreshNotification @"refreshNotification"
#define TCChangedNotification @"TCChangedNotification"
#define RefreshAppLockedNotification @"refreshAppLockedNotification"
#define RefreshLoginNotification @"refreshLoginNotification"

#define CHANNEL @"appstore"

//#define CHANNEL @"fangzhen_market"

//#define CHANNEL @"jasubao_market"

//#define CHANNEL @"fangyi_market"

//#define CHANNEL @"zhuguangtao_market"

//#define CHANNEL @"yulei_market"

//#define CHANNEL @"wanghui_market"

//#define CHANNEL @"91_market"
//#define CHANNEL @"weiphone_market"
//#define CHANNEL @"tongbutui_market"
//#define CHANNEL @"163_market"
//#define CHANNEL @"baidu_market"
//#define CHANNEL @"tx_market"
//#define CHANNEL @"souhu_market"
//#define CHANNEL @"pp_market"
//#define CHANNEL @"kuaiyong_market"
//#define CHANNEL @"xianmian_market"
//#define CHANNEL @"gaoqu_market"
//#define CHANNEL @"liqu_market"

#define DES_KEY @"flashapp12345678ppahsalf"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define ACCESS_LOG_LAST_TIME @"accessLogLastTime"
#define UD_LOCATION_ENABLED @"locationEnabled"
#define FIRST_INSTALL_APP @"first_install_app" //用来设置第一次安装图片质量的缺省值

//add guangtao 
#define NEWS_APP @"shownewapp"
#define JPTJ_APP @"jptjnewapp"
#define XSMF_APP @"xsmfnewapp"
#define RMYX_APP @"rmyxnewapp"

#import <UIKit/UIKit.h>
#import "UserSettings.h"
#import "UIDevice-Reachability.h"
#import "WXApi.h"
#import "Reachability.h"
#import <CoreTelephony/CTCarrier.h>
#import "TCLocationManager.h"
#import "UserSettings.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate >
{
    BOOL timerTaskDoing;
    NSObject* timerTaskLock;
    ConnectionType connType;
    TCLocationManager* locationManager;
    //NSTimer* timer;
    NSThread* refreshThread;
    
    NSString *pushNotifationType;
    
    //线程队列
    NSOperationQueue* operationQueue;
}

@property (nonatomic, assign) BOOL refreshDatasave;
@property (nonatomic, assign) BOOL refreshDatastats;
@property (nonatomic, assign) BOOL proxySlow;
@property (nonatomic, assign) BOOL adjustSMSSend;


@property (nonatomic, readonly) NSLock* refreshingLock;
@property (nonatomic, retain) NSObject* dbWriteLock;
@property (nonatomic, retain) CTCarrier* carrier;

@property (nonatomic, retain) UserSettings* user;

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,retain) UINavigationController *navController;
@property (nonatomic, retain) Reachability* networkReachablity;


+ (time_t) getLastAccessLogTime;
+(void)setLabelFrame:(UILabel *)label1 label2:(UILabel*)label2;
- (void) timerTask;

- (UIViewController*) currentViewController;
-(void)showLockView:(NSString*)message;
-(void)hideLockView;
- (void) switchUser;
+(void)labelShadow:(UILabel*)label;
+(void)buttonTopShadow:(UIButton*)button shadowColor:(UIColor*)color;
+(void)exChangeOut:(UIView *)changeOutView dur:(CFTimeInterval)dur;
+ (void) showAlert:(NSString*)title message:(NSString*)message;
+ (void) showAlert:(NSString*)message;
+(double)deviceSysVersion;
+ (AppDelegate*)getAppDelegate;
+ (Reachability*) getNetworkReachablity;
+ (BOOL) networkReachable;
+ (void) showHelp;
+ (void) showUserReviews;
+(void)installProfile;
+(void)installProfileWithServicetype:(NSString *)servicetype;
+ (void) installProfile:(NSString *)nextPage idc:(NSString*)idcCode;
+ (void) installProfile:(NSString *)nextPage apn:(NSString*)apn;
+ (void) installProfile:(NSString *)nextPage vpnn:(NSString*)voaName;
+ (void) installProfile:(NSString*)nextPage;
+ (void) uninstallProfile:(NSString*)nextPage;
- (void) startLocationManager;
- (void) stopLocationManager;
- (void) uploadAppInfo;
- (void) initDatabase:(BOOL)versionUpgrade;
- (int) execUpgradeSQL:(NSString*)newVersion oldVersion:(NSString*)oldVersion;
- (void) showSetupView;
- (BOOL) proxyServerSlow;
- (NSString*) appInfoToJSONString:(NSDictionary*)currentApps;
+(BOOL)pdVpnIsOpenOrClose;
@end
