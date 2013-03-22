#import <UIKit/UIKit.h>
#import "TFConnection.h"
#import "DeviceInfo.h"
#import "StatsDay.h"

@interface TwitterClient : TFConnection
{
    id          context;
    SEL         action;
    BOOL        hasError;
    NSString*   errorMessage;
    NSString*   errorDetail;
}

@property(nonatomic, retain) id context;
@property(nonatomic, assign) BOOL hasError;
@property(nonatomic, copy) NSString* errorMessage;
@property(nonatomic, copy) NSString* errorDetail;

- (id)initWithTarget:(id)delegate action:(SEL)action;
+ (NSDictionary*) urlParameters:(NSString*)url;

+ (DeviceInfo*) getRegisteredDevice;
+ (void) getMemberInfoSync;
- (void) getMemberInfo;
+ (void) parseMemberInfo:(NSDictionary*)dic;

- (void) incrUserCapacityFor91:(float)points currentCapacity:(float)capacity;//增加用户限额，用于91点金
+ (void) incrUserCapacityFor91Sync:(float)points currentCapacity:(float)capacity;

+ (BOOL) modifyUserInfo:(NSString*)username nickname:(NSString*)nickname password:(NSString*)password;
+ (BOOL) modifyPassword:(NSString*)password oldPasswd:(NSString*)oldPassword forUser:(NSString*)username;
+ (BOOL) forgetPasswd:(NSString*)username vericode:(NSString*)vericode password:(NSString*)password;

- (void) registerAtGziWithUserId:(NSString*)userId phone:(NSString*)phone;
- (void) login:(NSString*)phone password:(NSString*)password;
+ (BOOL) doLogin:(NSObject*)obj passwd:(NSString*)passwd;
+ (void) doLogin:(NSDictionary*)dic;

+ (BOOL) getStatsData;
+ (NSArray*)parseStatsData:(NSObject*)obj;
+ (BOOL) procecssAccessData:(NSObject*)obj time:(time_t)t;
- (void) getAccessData;
+ (NSDictionary*) parseAccessData:(NSDictionary*)obj;

- (void) getTaocanData:(NSString*)total used:(NSString*)used day:(NSString*)day;
- (void) getCarrierInfo:(NSString*)tel area:(NSString*)area code:(NSString*)code type:(NSString*)type;
+ (BOOL) getCarrierInfoSync:(NSString*)tel area:(NSString*)area code:(NSString*)code type:(NSString*)type;
+ (void) parseCarrierInfo:(NSObject*)obj;
+ (BOOL) saveTaocanData:(NSString*)total used:(NSString*)used day:(NSString*)day;

- (void) getIDCList;

+ (BOOL) uploadAppInfoSync:(NSString*)apps;

@end
