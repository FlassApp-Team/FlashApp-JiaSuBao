//
//  UserAgentInfo.h
//  flashapp
//
//  Created by Qi Zhao on 12-9-6.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    LOCK_STATUS_NO,     //没有被暂停
    LOCK_STATUS_EXPIRED,//被暂停，但时间已经到了
    LOCK_STATUS_YES     //被暂停，时间还没有到
} UserAgentLockStatus;

@interface UserAgentLock : NSObject
{
    NSString* userAgent;
    BOOL isLock;
    time_t lockTime;
    long timeLengh;
    time_t resumeTime;
}
@property (nonatomic, retain) NSString* appName;//add jianfei han 2013-02-28

@property (nonatomic, retain) NSString* userAgent;
@property (nonatomic, assign) BOOL isLock;
@property (nonatomic, assign) time_t lockTime;
@property (nonatomic, assign) long timeLengh;
@property (nonatomic, assign) time_t resumeTime;

- (UserAgentLockStatus) lockStatus;

@end
