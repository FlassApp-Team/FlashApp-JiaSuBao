//
//  UserdLog.m
//  flashapp
//
//  Created by 李 电森 on 12-5-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserdLog.h"

@implementation UserdLog

@synthesize myId;
@synthesize  sendBytes;
@synthesize  receiveBytes;
@synthesize  totalBytes;
@synthesize  deltaBytes;
@synthesize  lastChangedTime;
@synthesize  createTime;
@synthesize  type;
@synthesize  desc;
@synthesize  tcDay;
@synthesize  tcUsed;


- (void) dealloc
{
    [desc release];
    [super dealloc];
}

@end
