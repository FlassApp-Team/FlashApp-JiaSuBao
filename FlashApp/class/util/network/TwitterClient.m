//
//  TwitterClient.m
//  TwitterFon
//
//  Created by kaz on 7/13/08.
//  Copyright naan studio 2008. All rights reserved.
//

#import "TwitterClient.h"
#import "StatsDayService.h"
#import "StatsDayDAO.h"
#import "JSON.h"
#import "StringUtil.h"
#import "DateUtils.h"
#import "AppDelegate.h"
#import "OpenUDID.h"
#import "Profile.h"
#import "DeviceInfo.h"
#import "IDCInfo.h"
#import "DESCrypter.h"
#import "StringUtil.h"

@implementation TwitterClient

@synthesize context;
@synthesize hasError;
@synthesize errorMessage;
@synthesize errorDetail;


#pragma mark - init & destroy methods

- (id)initWithTarget:(id)aDelegate action:(SEL)anAction
{
    [super initWithDelegate:aDelegate];
    action = anAction;
    hasError = false;
    return self;
}

- (void)dealloc
{
    [errorMessage release];
    [errorDetail release];
    [context release];
    [super dealloc];
}


#pragma mark - business methods

+ (DeviceInfo*) getRegisteredDevice
{
    DeviceInfo* device = [DeviceInfo deviceInfoWithLocalDevice];
    NSString* deviceId = device.deviceId;
    NSString* name= device.name;
    NSString* plateform = device.platform;
    NSString* version = device.version;
    NSString* url = [NSString stringWithFormat:@"%@/%@.json?deviceId=%@&name=%@&platform=%@&osversion=%@&createIfNeed=Y", API_BASE,API_LOG_GETDEVICE,deviceId,[name encodeAsURIComponent],[plateform encodeAsURIComponent],[version encodeAsURIComponent]];
    NSLog(@"%@", url);
    
    NSHTTPURLResponse* response;
    NSError* error;
    NSObject* obj = [TwitterClient sendSynchronousRequest:url method:@"GET" body:nil response:&response error:&error];
    DeviceInfo* deviceInfo = [[[DeviceInfo alloc] initWithJSON:obj] autorelease];
    return deviceInfo;
}


+ (BOOL) doLogin:(NSObject*)obj passwd:(NSString*)passwd
{
    if ( !obj || ![obj isKindOfClass:[NSDictionary class]] ) return NO;
    
    NSDictionary* dic = (NSDictionary*)obj;
    NSMutableDictionary* userDic = [NSMutableDictionary dictionary];
    [userDic setObject:passwd forKey:@"password"];
    
    NSObject* userId = [dic objectForKey:@"id"];
    NSObject* username = [dic objectForKey:@"username"];
    NSObject* nickname = [dic objectForKey:@"nickname"];
    NSObject* capacity = [dic objectForKey:@"curentNum"];
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    user.password = passwd;
    
    if ( userId && userId != [NSNull null] ) {
        [userDic setObject:userId forKey:@"id"];
    }
    
    if ( username && username != [NSNull null] ) {
        [userDic setObject:username forKey:@"username"];
    }
    
    if ( nickname && nickname != [NSNull null] ) {
        [userDic setObject:nickname forKey:@"nickname"];
    }
    
    if ( capacity && capacity != [NSNull null] ) {
        [userDic setObject:[NSString stringWithFormat:@"%f",[(NSDecimalNumber*)capacity floatValue]] forKey:@"curentNum"];
    }
    
    [self doLogin:userDic];
    
    return YES;
}


+ (void) doLogin:(NSDictionary*)dic
{
    NSString* userId = [dic objectForKey:@"id"];
    NSString* username = [dic objectForKey:@"username"];
    NSString* nickname = [dic objectForKey:@"nickname"];
    NSString* passwd = [dic objectForKey:@"password"];
    NSString* capacity = [dic objectForKey:@"curentNum"];
    UserSettings* user = [AppDelegate getAppDelegate].user;
    user.userId = [userId intValue];
    user.password = passwd;
    user.username = username;
    user.nickname = nickname;
    user.capacity = [capacity floatValue];
    user.status = STATUS_REGISTERED_ACTIVE;
    
    user.day = nil;
    user.dayCapacity = 0;
    user.dayCapacityDelta = 0;
    user.month = nil;
    user.monthCapacity = 0;
    user.monthCapacityDelta = 0;
    
    [UserSettings saveUserSettings:user];
}

+ (BOOL) modifyUserInfo:(NSString*)username nickname:(NSString*)nickname password:(NSString*)password
{
    NSString* url = [NSString stringWithFormat:@"%@/%@.json?username=%@&nickname=%@&password=%@", API_BASE, API_USER_MODIFY, [username encodeAsURIComponent], [nickname encodeAsURIComponent], [password encodeAsURIComponent]];
    
    NSHTTPURLResponse* response;
    NSError* error;
    NSObject* obj = [TwitterClient sendSynchronousRequest:url method:@"GET" body:nil response:&response error:&error];
    
    if ( !obj || ![obj isKindOfClass:[NSDictionary class]] ) {
        return NO;
    }
    else {
        return YES;
    }
}


+ (BOOL) modifyPassword:(NSString*)password oldPasswd:(NSString*)oldPassword forUser:(NSString*)username
{
    NSString* url = [NSString stringWithFormat:@"%@/%@.json?username=%@&oldpwd=%@&password=%@", API_BASE, API_USER_MODIFY_PASSWD, [username encodeAsURIComponent], [oldPassword encodeAsURIComponent], [password encodeAsURIComponent]];
    
    NSHTTPURLResponse* response;
    NSError* error;
    NSObject* obj = [TwitterClient sendSynchronousRequest:url method:@"GET" body:nil response:&response error:&error];
    
    if ( !obj || ![obj isKindOfClass:[NSDictionary class]] ) {
        return NO;
    }
    else {
        return YES;
    }
}


+ (BOOL) forgetPasswd:(NSString*)username vericode:(NSString*)vericode password:(NSString*)password
{
    NSString* url = [NSString stringWithFormat:@"%@/%@.json?username=%@&vericode=%@&password=%@", API_BASE, API_USER_RESET_PASSWD, [username encodeAsURIComponent], [vericode encodeAsURIComponent], [password encodeAsURIComponent]];
    
    NSHTTPURLResponse* response;
    NSError* error;
    NSObject* obj = [TwitterClient sendSynchronousRequest:url method:@"GET" body:nil response:&response error:&error];
    
    if ( !obj || ![obj isKindOfClass:[NSDictionary class]] ) {
        return NO;
    }
    else {
        return YES;
    }
}


+ (void) getMemberInfoSync
{
    UserSettings* user = [AppDelegate getAppDelegate].user;
    
    DeviceInfo* device = [DeviceInfo deviceInfoWithLocalDevice];
    NSString* version1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
    
    NSString* plateform = device.platform;
    NSString* version = device.version;
    NSString* deviceToken =  [[NSUserDefaults standardUserDefaults] stringForKey:@"deviceToken"];
    
    time_t now;
    time( &now );
    long long currTime = now * 1000LL;
    
    NSString* username = user.username;
    NSString* tcUsed = user.ctUsed;
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString*firt=[userDefault objectForKey:FIRST_INSTALL_APP];
    if(!firt&&firt.length==0)
    {
        firt=@"1";
    }
    else
    {
        firt=@"0";
    }
    
    NSString* url =nil;
    if(user.nickname)
    {
        url = [NSString stringWithFormat:@"%@/%@.json?username=%@&useVal=%@&startQuantity=%.1f&shareQuantity=%.1f&currTime=%lld&platform=%@&osversion=%@&deviceToken=%@&vr=%@&appid=%d&reborn=%@&username=%@",
                   API_BASE, API_LOG_MEMBERINFO,
                   username ? [username encodeAsURIComponent] : @"",
                   tcUsed ? tcUsed : @"",
                   user.dayCapacityDelta, user.monthCapacityDelta, currTime,
                   plateform, version,deviceToken,version1,2, firt,[user.nickname encodeAsURIComponent]];
    }
    else
    {
        url= [NSString stringWithFormat:@"%@/%@.json?username=%@&useVal=%@&startQuantity=%.1f&shareQuantity=%.1f&currTime=%lld&platform=%@&osversion=%@&deviceToken=%@&vr=%@&appid=%d&reborn=%@",
           API_BASE, API_LOG_MEMBERINFO,
           username ? [username encodeAsURIComponent] : @"",
           tcUsed ? tcUsed : @"",
           user.dayCapacityDelta, user.monthCapacityDelta, currTime,
           plateform, version,deviceToken,version1,2, firt];
    }

    url = [self composeURLVerifyCode:url];
    //NSLog(@"url1=%@",url);
    NSHTTPURLResponse* response;
    NSError* error;
    NSObject* obj = [TwitterClient sendSynchronousRequest:url method:@"GET" body:nil response:&response error:&error];
    
    if ( [obj isKindOfClass:[NSDictionary class]] ) {
        NSDictionary* dic = (NSDictionary*) obj;
        [self parseMemberInfo:dic];
        
        user.dayCapacityDelta = 0;
        user.monthCapacityDelta = 0;
    }
}


- (void) getMemberInfo
{
    UserSettings* user = [AppDelegate getAppDelegate].user;
    
    DeviceInfo* device = [DeviceInfo deviceInfoWithLocalDevice];
    NSString* plateform = device.platform;
    NSString* version = device.version;
    
    time_t now;
    time( &now );
    long long currTime = now * 1000LL;
    
    NSString* username = user.username;
    NSString* tcUsed = user.ctUsed;
    
    NSString* url = [NSString stringWithFormat:@"%@/%@.json?username=%@&useVal=%@&startQuantity=%.1f&shareQuantity=%.1f&currTime=%lld%&platform=%@&osversion=%@", 
                     API_BASE, API_LOG_MEMBERINFO, 
                     username ? [username encodeAsURIComponent] : @"", 
                     tcUsed ? tcUsed : @"",
                     user.dayCapacityDelta, user.monthCapacityDelta, currTime,
                     plateform, version ]; 
    url = [TwitterClient composeURLVerifyCode:url];
    [self get:url];
}


+ (void) parseMemberInfo:(NSDictionary*)dic
{
    if ( !dic ) return;
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    
    id value = [dic objectForKey:@"level"];
    if ( value && value != [NSNull null] ) {
        user.level = [value intValue];
    }
    
    value = [dic objectForKey:@"lvxpcur"];
    if ( value && value != [NSNull null] ) {
        user.lvxpcur = [value intValue];
    }
    
    value = [dic objectForKey:@"lvxpmax"];
    if ( value && value != [NSNull null] ) {
        user.lvxpmax = [value intValue];
    }
    
    
    value = [dic objectForKey:@"quantity"];
    if ( value && value != [NSNull null] ) {
        user.capacity = [value floatValue];
    }
    
    value = [dic objectForKey:@"imgq"];
    PictureQsLevel pictureQsLevel = user.pictureQsLevel;
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    [userDefault setObject:@"0" forKey:FIRST_INSTALL_APP];
    if ( value && value != [NSNull null] ) {
        int qs = [value intValue];
        if ( qs == 0 ) {
            pictureQsLevel = PIC_ZL_LOW;
        }
        else if ( qs == 1 ) {
            pictureQsLevel = PIC_ZL_MIDDLE;
        }
        else if ( qs == 2 ) {
            if ( pictureQsLevel!=PIC_ZL_HIGH && pictureQsLevel!=PIC_ZL_NOCOMPRESS ) {
                pictureQsLevel = PIC_ZL_HIGH;
            }
        }
        user.pictureQsLevel = pictureQsLevel;
    }
    
    value = [dic objectForKey:@"proxy"];

    if ( value && [value isKindOfClass:[NSDictionary class]] ) {
        NSDictionary* proxyDic = (NSDictionary*) value;
        value = [proxyDic objectForKey:@"domain"];
        if ( value && value != [NSNull null] ) {
            user.proxyServer = value;
        }
        
        value = [proxyDic objectForKey:@"port"];
        if ( value && value != [NSNull null] ) {
            user.proxyPort = [value intValue];
        }
        
        value = [proxyDic objectForKey:@"svr"];
        if ( value && value != [NSNull null] ) {
            user.idcServer = value;
        }
        value = [proxyDic objectForKey:@"cname"];
        if ( value && value != [NSNull null] ) {
            user.idcName = value;//add jianfei han 
        }
    
        
        
        //hist
    }
    
    [UserSettings saveUserSettings:user];
}


#pragma mark - explain accessLog methods
+(BOOL) getStatsData
{
    NSLock* lock = [AppDelegate getAppDelegate].refreshingLock;
    BOOL result = NO;
    
    if ( [lock tryLock] ) {
        UserSettings* user = [AppDelegate getAppDelegate].user;
        NSString* server = user.idcServer;
        if ( !server || server.length == 0 ) return NO;
        
        if ( !user.proxyServer || user.proxyServer.length == 0 ) return NO;
        if ( user.proxyPort <= 0 ) return NO;
        
        DeviceInfo* device = [DeviceInfo deviceInfoWithLocalDevice];
        NSString* platform = device.platform;

        NSNumber* number = [[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_LOG_LAST_TIME];
        time_t lastDayLong = [AppDelegate getLastAccessLogTime];
        NSString* lastDayString = [DateUtils stringWithDateFormat:lastDayLong format:@"yyyy-MM-dd"];
        
        NSString* url = [NSString stringWithFormat:@"http://%@/api/%@.json?accessTime=%@&host=%@&port=%d&platform=%@&cpi=%lld", user.idcServer, API_LOG_LOG, lastDayString, user.proxyServer, user.proxyPort, [platform encodeAsURIComponent], number?[number longLongValue]:0];
        
        url = [self composeURLVerifyCode:url];
        
        NSHTTPURLResponse* response;
        NSError* error;
        NSObject* obj = [TwitterClient sendSynchronousRequest:url method:@"GET" body:nil response:&response error:&error];
        
        result = [self procecssAccessData:obj time:lastDayLong];

        [lock unlock];
    }
    return result;
}


+ (NSArray*)parseStatsData:(NSObject*)obj
{
    NSMutableArray* resultArr = [NSMutableArray array];
    if ( !obj || ![obj isKindOfClass:[NSArray class]] ) return resultArr;
    
    NSArray* arr = (NSArray*) obj;
    for ( NSDictionary* d in arr ) {
        NSDictionary* dic = [d objectForKey:@"trip"];
        StatsDay* statsObj = [[StatsDay alloc] initWithJSON:dic];
        if ( statsObj ) {
            [resultArr addObject:statsObj];
            [statsObj release];
        }
    }
    
    return resultArr;
}


- (void) getAccessData
{
    
    UserSettings* user = [AppDelegate getAppDelegate].user;

    NSString* server = user.idcServer;
    if ( !server || server.length == 0 ) return;
    if ( !user.proxyServer || user.proxyServer.length == 0 ) return;
    if ( user.proxyPort <= 0 ) return;
    
    DeviceInfo* device = [DeviceInfo deviceInfoWithLocalDevice];
    NSString* platform = device.platform;

    NSNumber* number = [[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_LOG_LAST_TIME];
    time_t lastDayLong = [AppDelegate getLastAccessLogTime];
    NSString* lastDayString = [DateUtils stringWithDateFormat:lastDayLong format:@"yyyy-MM-dd"];
    
    NSString* url = [NSString stringWithFormat:@"http://%@/api/%@.json?accessTime=%@&host=%@&port=%d&platform=%@&cpi=%lld", user.idcServer, API_LOG_LOG, lastDayString, user.proxyServer, user.proxyPort, [platform encodeAsURIComponent], number?[number longLongValue]:0];
    NSLog(@"AAAAAAAAAAAAAA%@",url);
    url = [TwitterClient composeURLVerifyCode:url];
    [self get:url];
}


+ (BOOL) procecssAccessData:(NSObject*)obj time:(time_t)t
{
    if ( !obj || ![obj isKindOfClass:[NSDictionary class]] ) return NO;
    NSDictionary* dic = (NSDictionary*) obj;
    
    //解析数据
    NSDictionary* result = [TwitterClient parseAccessData:dic];
    long long serverTime = [[result objectForKey:@"currTime"] longLongValue]; //cur
    long long lastTime = [[result objectForKey:@"lastTime"] longLongValue]; //cp
    
    NSArray* accessLogs = [result objectForKey:@"accessLog"]; //accesstime
    
    if ( accessLogs && [accessLogs count] > 0 ) {
        //将新下载的数据写入数据库中
        time_t st = (time_t) (serverTime / 1000);//为什么要 除以 1000 ？？
        
        [StatsDayService explainAccessLog:t serverTime:st data:accessLogs];
        
        //保存本次访问时间
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLongLong:lastTime] forKey:ACCESS_LOG_LAST_TIME];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    
    NSObject* value = [result objectForKey:@"proxyFlag"];
    
    NSLog(@"proxyFlag=================%@",[result objectForKey:@"proxyFlag"]);
    
    if ( value && value != [NSNull null] ) {
        NSDecimalNumber* proxyFlag = (NSDecimalNumber*) value;
        ConnectionType connType = [UIDevice connectionType];
        if ( connType == CELL_2G || connType == CELL_3G || connType == CELL_4G ) {
            InstallFlag flag = [proxyFlag intValue];
            if ( flag == INSTALL_FLAG_UNKNOWN ) flag = INSTALL_FLAG_NO;
            user.proxyFlag = flag;
        }
    }
    
    /*
    value = [result objectForKey:@"status"];
    if ( value && value != [NSNull null] ) {
        NSDecimalNumber* status = (NSDecimalNumber*)value;
        user.status = [status intValue];
    }
    
    value = [result objectForKey:@"level"];
    if ( value && value != [NSNull null] ) {
        NSDecimalNumber* level = (NSDecimalNumber*)value;
        user.level = [level intValue];
    }
    
    value = [result objectForKey:@"capacity"];
    if ( value && value != [NSNull null] ) {
        NSDecimalNumber* capacity = (NSDecimalNumber*)value;
        user.capacity = [capacity floatValue];
    }
    
    value = [result objectForKey:@"proxyServer"];
    if ( value && value != [NSNull null] ) {
        NSString* proxyServer = (NSString*)value;
        if ( proxyServer.length > 0 ) user.proxyServer = proxyServer;
    }
    
    value = [result objectForKey:@"proxyPort"];
    if ( value && value != [NSNull null] ) {
        NSString* proxyPort = (NSString*)value;
        if ( proxyPort.length > 0 ) user.proxyPort = [proxyPort integerValue];
    }
    
    user.dayCapacityDelta = 0;
    user.monthCapacityDelta = 0;
     */
    
    [UserSettings saveUserSettings:user];
    
    return accessLogs && [accessLogs count] > 0;
}



+ (NSDictionary*) parseAccessData:(NSDictionary*)dic
{
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    
    id value = [dic objectForKey:@"accessLog"];
    NSArray* accessLogs = [TwitterClient parseStatsData:value];
    [result setObject:accessLogs forKey:@"accessLog"];
    
    value = [dic objectForKey:@"proxyFlag"];
    if ( value && value != [NSNull null] ) {
        [result setObject:value forKey:@"proxyFlag"]; //proxyFlag是表示是否设置上授权文件。也就是服务是否开启         0为未开启，1为开启
    }
    
    value = [dic objectForKey:@"cp"];
    if ( value && value != [NSNull null] ) {
        [result setObject:value forKey:@"lastTime"];
    }
    
    value = [dic objectForKey:@"cur"];
    if ( value && value != [NSNull null] ) {
        [result setObject:value forKey:@"currTime"];
    }

    /*
    value = [dic objectForKey:@"proxyStatus"];
    if ( value && value != [NSNull null] ) {
        [result setObject:value forKey:@"proxyStatus"];
    }
    
    value = [dic objectForKey:@"level"];
    if ( value && value != [NSNull null] ) {
        [result setObject:value forKey:@"level"];
    }
    
    value = [dic objectForKey:@"status"];
    if ( value && value != [NSNull null] ) {
        [result setObject:value forKey:@"status"];
    }
    
    value = [dic objectForKey:@"quantity"];
    if ( value && value != [NSNull null] ) {
        [result setObject:value forKey:@"capacity"];
    }
    
    value = [dic objectForKey:@"device"];
    if ( value && [value isKindOfClass:[NSDictionary class]] ) {
        NSDictionary* deviceDic = (NSDictionary*) value;
        NSString* proxyServer = [deviceDic objectForKey:@"proxyIp"];
        [result setObject:proxyServer forKey:@"proxyServer"];

        NSString* proxyPort = [deviceDic objectForKey:@"proxyPort"];
        [result setObject:proxyPort forKey:@"proxyPort"];
     }
     */
    
    return result;
}


#pragma mark - verify profile
+(BOOL)verifyProfile{
    NSString* deviceId = [OpenUDID value];
    NSString* url = [NSString stringWithFormat:@"%@/%@?uuid=%@",API_BASE,API_LOG_VERIFY,deviceId];
    NSHTTPURLResponse* response;
    NSError* error;
    NSObject* obj = [TwitterClient sendSynchronousRequest:url method:@"GET" body:nil response:&response error:&error];
    BOOL islegal = [Profile verifyProfile:obj];
    return islegal;
}


+(void)getUserService:(Profile*)profile{
     NSString* deviceId = [OpenUDID value];
    DeviceInfo* deviceInfo = [DeviceInfo deviceInfoWithLocalDevice];
    NSString* name= deviceInfo.name;
    NSString* plateform = deviceInfo.platform;
    NSString* version = deviceInfo.version;
    NSString* url = [NSString stringWithFormat:@"%@/%@?deviceId=%@&name=%@&platform=%@&osversion=%@&createIfNeed=Y",API_BASE,API_LOG_GETDEVICE,deviceId,name,plateform,version];
    NSHTTPURLResponse* response;
    NSError* error;
    [TwitterClient sendSynchronousRequest:url method:@"GET" body:nil response:&response error:&error];

}


- (void) registerAtGziWithUserId:(NSString*)userId phone:(NSString*)phone
{
    NSString* url = [NSString stringWithFormat:@"http://gzi.me/api/regist/regist.json?source=ec29c04b4d224fe9a32176b67be1e8fb&userId=%@&username=%@", userId, phone];
    [self get:url];
}


- (void) login:(NSString*)phone password:(NSString*)password
{
    NSString* url = [NSString stringWithFormat:@"http://p.flashapp.cn/api/accesslog/login.json?deviceId=%@&phone=%@&password=%@", [OpenUDID value], phone, password];
    [self get:url];
}


#pragma mark - taocan methods

- (void) getTaocanData:(NSString*)total used:(NSString*)used day:(NSString*)day
{
    NSString* url = [NSString stringWithFormat:@"%@/%@.json", API_BASE, API_COMBO_COMBOINFO];

    total = total ? [NSString stringWithFormat:@"&total=%@", total] : @"";
    used = used ? [NSString stringWithFormat:@"&use=%@", used] : @"";
    day = day ? [NSString stringWithFormat:@"&dat=%@", day] : @"";
    
    NSString* parameters = [NSString stringWithFormat:@"%@%@%@", total, used, day];
    if ( parameters.length > 0 ) {
        url = [NSString stringWithFormat:@"%@?%@", url, [parameters substringFromIndex:1]];
    }
    
    url = [TwitterClient composeURLVerifyCode:url];
    [self get:url];
}


+(BOOL) saveTaocanData:(NSString*)total used:(NSString*)used day:(NSString*)day
{
    NSString* url = [NSString stringWithFormat:@"%@/%@.json", API_BASE, API_COMBO_COMBOINFO];
    
    total = total ? [NSString stringWithFormat:@"&total=%@", total] : @"";
    used = used ? [NSString stringWithFormat:@"&use=%@", used] : @"";
    day = day ? [NSString stringWithFormat:@"&dat=%@", day] : @"";
    
    NSString* parameters = [NSString stringWithFormat:@"%@%@%@", total, used, day];
    if ( parameters.length > 0 ) {
        url = [NSString stringWithFormat:@"%@?%@", url, [parameters substringFromIndex:1]];
    }
    
    url = [TwitterClient composeURLVerifyCode:url];
    
    NSHTTPURLResponse* response;
    NSError* error;
    [TwitterClient sendSynchronousRequest:url method:@"GET" body:nil response:&response error:&error];
    
    if ( response.statusCode != 200 ) {
        return NO;
    }
    else {
        return YES;
    }
}



- (void) getCarrierInfo:(NSString*)tel area:(NSString*)area code:(NSString*)code type:(NSString*)type
{
    NSString* url = [NSString stringWithFormat:@"%@/%@.json?phone=%@", API_BASE, API_COMBO_CARRIERINFO, [tel encodeAsURIComponent]];
    area = area ? [NSString stringWithFormat:@"&acode=%@", area] : @"";
    code = code ? [NSString stringWithFormat:@"&ccode=%@", code] : @"";
    type = type ? [NSString stringWithFormat:@"&ctp=%@", type] : @"";

    url = [NSString stringWithFormat:@"%@%@%@%@", url,area, code, type];
    url = [TwitterClient composeURLVerifyCode:url];
    [self get:url];
}


+ (BOOL) getCarrierInfoSync:(NSString*)tel area:(NSString*)area code:(NSString*)code type:(NSString*)type
{
    NSString* url = [NSString stringWithFormat:@"%@/%@.json?phone=%@", API_BASE, API_COMBO_CARRIERINFO, [tel encodeAsURIComponent]];
    area = area ? [NSString stringWithFormat:@"&acode=%@", area] : @"";
    code = code ? [NSString stringWithFormat:@"&ccode=%@", code] : @"";
    type = type ? [NSString stringWithFormat:@"&ctp=%@", type] : @"";
    
    url = [NSString stringWithFormat:@"%@%@%@%@", url,area, code, type];
    url = [TwitterClient composeURLVerifyCode:url];

    NSHTTPURLResponse* response;
    NSError* error;
    NSObject* obj = [TwitterClient sendSynchronousRequest:url response:&response error:&error];
    if ( response.statusCode != 200 ) return NO;
    if ( !obj || ![obj isKindOfClass:[NSDictionary class]] ) return NO;
    
    [self parseCarrierInfo:obj];
    return YES;
}


+ (void) parseCarrierInfo:(NSObject*)obj
{
    if ( obj && [obj isKindOfClass:[NSDictionary class]] ) {
        NSDictionary* dic = (NSDictionary*) obj;
        
        NSString* areaCode = nil;
        NSObject* o = [dic objectForKey:@"area"];
        if ( o && o!=[NSNull null] ) {
            areaCode = (NSString*)o;
        }
        
        NSString* carrierCode = nil;
        o = [dic objectForKey:@"carrier"];
        if ( o && o!=[NSNull null] ) {
            carrierCode = (NSString*)o;
        }
        
        NSString* carrierType = nil;
        o = [dic objectForKey:@"ctp"];
        if ( o && o!=[NSNull null] ) {
            carrierType = (NSString*)o;
        }
        
        NSString* carrierSmsnum = nil;
        o = [dic objectForKey:@"smsnum"];
        if ( o && o!=[NSNull null] ) {
            carrierSmsnum = (NSString*)o;
        }
        
        NSString* carrierSmstext = nil;
        o = [dic objectForKey:@"smstext"];
        if ( o && o!=[NSNull null] ) {
            carrierSmstext = (NSString*)o;
        }
        
        UserSettings* user = [AppDelegate getAppDelegate].user;
        user.areaCode = areaCode;
        user.carrierCode = carrierCode;
        user.carrierType = carrierType;
        user.carrierSmsnum = carrierSmsnum;
        user.carrierSmstext = carrierSmstext;
        [UserSettings saveCarrier:carrierCode carrierType:carrierType area:areaCode snsnum:carrierSmsnum snstext:carrierSmstext];
    }
}


#pragma mark - IDC methods

- (void) getIDCList
{
    NSString* url = [NSString stringWithFormat:@"%@/%@.json?&desc=%@", API_BASE, API_IDC_ZLIST,@"1"];
    url = [TwitterClient composeURLVerifyCode:url];
    [self get:url];
}


#pragma mark - 增加用户限额，用于91点金

- (void) incrUserCapacityFor91:(float)points currentCapacity:(float)capacity
{
    NSString* url = [NSString stringWithFormat:@"%@/%@.json?currentNum=%.2f&lmtVal=%.2f", API_BASE, API_USER_91_INCRLIMIT, capacity, points];
    url = [TwitterClient composeURLVerifyCode:url appendStr:[NSString stringWithFormat:@"%.2f", points]];
    [self get:url];
}


+ (void) incrUserCapacityFor91Sync:(float)points currentCapacity:(float)capacity
{
    NSString* url = [NSString stringWithFormat:@"%@/%@.json?currentNum=%.2f&lmtVal=%.2f", API_BASE, API_USER_91_INCRLIMIT, capacity, points];
    url = [TwitterClient composeURLVerifyCode:url appendStr:[NSString stringWithFormat:@"%.2f", points]];
    
    NSHTTPURLResponse* response;
    NSError* error;
    NSObject* obj = [TwitterClient sendSynchronousRequest:url method:@"GET" body:nil response:&response error:&error];
    
    if ( [obj isKindOfClass:[NSDictionary class]] ) {
        NSDictionary* dic = (NSDictionary*) obj;
        UserSettings* user = [AppDelegate getAppDelegate].user;
        
        NSObject* value = [dic objectForKey:@"curentNum"];
        if ( value && value != [NSNull null]) {
            NSNumber* number = (NSNumber*) value;
            user.capacity = [number floatValue];
        }

        value = [dic objectForKey:@"level"];
        if ( value && value != [NSNull null]) {
            NSNumber* number = (NSNumber*) value;
            user.level = [number intValue];
        }
        
        [UserSettings saveUserSettings:user];
    }
}


#pragma mark - Installed apps

+ (BOOL) uploadAppInfoSync:(NSString*)apps
{
    apps = [DESCrypter encryptUseDES:apps key:DES_KEY];
    NSString* url = [NSString stringWithFormat:@"%@/%@.json", API_BASE, API_APP_APPS_3DES];
    NSString* body = [NSString stringWithFormat:@"appinfo=%@", [apps encodeAsURIComponent]];
    
    Byte buffer[81920];
    memset(buffer, 0, 81920);
    
    NSRange range;
    range.length = body.length;
    range.location = 0;
    NSUInteger bufferLength;
    
    [body getBytes:buffer maxLength:81920 usedLength:&bufferLength encoding:NSUTF8StringEncoding options:0 range:range remainingRange:NULL];
    NSData* data = [NSData dataWithBytes:buffer length:bufferLength];
    
    NSHTTPURLResponse* response;
    NSError* error;
    [TwitterClient sendSynchronousRequest:url method:@"POST" body:data response:&response error:&error];
    
    if ( response.statusCode == 200 ) {
        return YES;
    }
    else {
        return NO;
    }
}


#pragma mark - http request basic methods

- (void)TFConnectionDidFailWithError:(NSError*)error
{
    hasError = true;
    if (error.code ==  NSURLErrorUserCancelledAuthentication) {
        statusCode = 401;
        [AppDelegate showAlert:@"错误的用户名或者密码"];
    }
    else {
        self.errorMessage = @"现在您的网络无法使用，访问网络失败";
        self.errorDetail  = [error localizedDescription];
        [[AppDelegate getAppDelegate] hideLockView];
        [delegate performSelector:action withObject:self withObject:nil];
    }
    [self autorelease];
}


-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge previousFailureCount] == 0) {
        NSLog(@"Authentication Challenge");
        NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
        NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
        NSURLCredential* cred = [NSURLCredential credentialWithUser:username password:password persistence:NSURLCredentialPersistenceNone];
        [[challenge sender] useCredential:cred forAuthenticationChallenge:challenge];
    } else {
        NSLog(@"Failed auth (%d times)", [challenge previousFailureCount]);
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}


- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    hasError = true;
    [AppDelegate showAlert:@"HttpCode=401, 错误的用户名或者密码"];
    [self autorelease];
}


- (void)TFConnectionDidFinishLoading
{
    NSString* content = [[[NSString alloc] initWithData:buf encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"response:%@", content);
    switch (statusCode) {
        case 401: // Not Authorized: either you need to provide authentication credentials, or the credentials provided aren't valid.
            hasError = true;
            [AppDelegate showAlert:@"HttpCode=401, 错误的用户名或者密码"];
            goto out;
            
        case 304: // Not Modified: there was no new data to return.
            [delegate performSelector:action withObject:self withObject:nil];
            goto out;
            
        case 400: // Bad Request: your request is invalid, and we'll return an error message that tells you why. This is the status code returned if you've exceeded the rate limit
        case 200: // OK: everything went awesome.
        case 403: // Forbidden: we understand your request, but are refusing to fulfill it.  An accompanying error message should explain why.
            break;
                
        case 404: // Not Found: either you're requesting an invalid URI or the resource in question doesn't exist (ex: no such user). 
        case 500: // Internal Server Error: we did something wrong.  Please post to the group about it and the Twitter team will investigate.
        case 502: // Bad Gateway: returned if Twitter is down or being upgraded.
        case 503: // Service Unavailable: the Twitter servers are up, but are overloaded with requests.  Try again later.
        default:
        {
            hasError = true;
            self.errorMessage = @"无法获取最新的统计数据,请稍后再试。";
            self.errorDetail  = [NSHTTPURLResponse localizedStringForStatusCode:statusCode];
            [delegate performSelector:action withObject:self withObject:nil];
            goto out;
        }
    }
#if 0
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *pathStr;
    if (request == 0) {
        pathStr = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"friends_timeline.json"];
    }
    else if (request == 1) {
        pathStr = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"replies.json"];
    }
    else if (request == 2) {
        pathStr = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"direct_messages.json"];
    }
    if (request <= 2) {
        NSData *data = [fileManager contentsAtPath:pathStr];
        content = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    }
#endif

    NSObject *obj = [content JSONValue];
    [delegate performSelector:action withObject:self withObject:obj];
    
  out:
    [self autorelease];
}


+ (NSDictionary*) urlParameters:(NSString*)url
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    if ( !url || [url length] == 0 ) return dic;
    NSRange range = [url rangeOfString:@"?"];
    if ( range.location == NSNotFound ) return dic;
    
    NSString* queryString = [url substringFromIndex:range.location+1];
    if ( [queryString length] == 0 ) return dic;
    
    NSArray* array = [queryString componentsSeparatedByString:@"&"];
    NSString* name;
    NSString* value;
    
    for ( NSString* s in array ) {
        NSArray* arr = [s componentsSeparatedByString:@"="];
        if ( [arr count] == 2 ) {
            name = [arr objectAtIndex:0];
            value = [arr objectAtIndex:1];
            [dic setObject:value forKey:name];
        }
        else if ( [arr count] == 1 ) {
            name = [arr objectAtIndex:0];
            [dic setObject:@"" forKey:name];
        }
    }
    
    return dic;
}

@end
