//
//  TotalStats.m
//  flashapp
//
//  Created by zhen fang on 11-12-15.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TotalStats.h"

@implementation TotalStats

@synthesize userAgent;
@synthesize uaId;
@synthesize uaStr;
@synthesize totalafter;
@synthesize totalstats;
@synthesize totalbefore;
@synthesize divstats;

-(void)dealloc{
    [userAgent release];
    [uaId release];
    [uaStr release];
    [super dealloc];
}
@end
