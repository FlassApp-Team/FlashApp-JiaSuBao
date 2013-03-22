//
//  UserAgentInfo.m
//  flashapp
//
//  Created by Qi Zhao on 12-9-6.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import "UserAgentLock.h"

@implementation UserAgentLock

@synthesize userAgent;
@synthesize isLock;
@synthesize lockTime;
@synthesize timeLengh;
@synthesize resumeTime;
@synthesize appName;

- (UserAgentLockStatus) lockStatus
{
    if ( !isLock ) return LOCK_STATUS_NO;
    
    time_t now;
    time( &now );
    
    if ( now > lockTime + timeLengh && timeLengh > 0 ) {
        return LOCK_STATUS_EXPIRED;
    }
    else {
        return LOCK_STATUS_YES;
    }
}


- (void) dealloc
{
    self.appName=nil;
    [userAgent release];
    [super dealloc];
}

@end
