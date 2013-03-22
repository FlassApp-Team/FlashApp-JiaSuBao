//
//  UserAgentInfoDAO.h
//  flashapp
//
//  Created by Qi Zhao on 12-9-6.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserAgentLock.h"

@interface UserAgentLockDAO : NSObject
+ (NSDictionary*) getAllUnLockedApps;//add jianfei han

+ (UserAgentLock*) getUserAgentLock:(NSString*)userAgent;
+ (void) updateUserAgentLock:(UserAgentLock*)lock;
+ (void) deleteUserAgentLock:(NSString*)userAgent;
+ (NSDictionary*) getAllLockedApps;
+ (void) deleteAll;

@end
