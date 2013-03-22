//
//  IFData.m
//  flashapp
//
//  Created by 李 电森 on 12-4-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IFData.h"

@implementation IFData

@synthesize ifName;
@synthesize receiveBytes;
@synthesize sendBytes;
@synthesize lastchangeTime;
@synthesize createTime;


- (id) init
{
    self = [super init];
    if ( self ) {
        self.ifName = nil;
        self.receiveBytes = 0;
        self.sendBytes = 0;
        self.lastchangeTime = 0;
        self.createTime = 0;
    }
    
    return self;
}


- (void) dealloc
{
    [ifName release];
    [super dealloc];
}

@end
