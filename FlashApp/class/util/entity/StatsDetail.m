//
//  StatsDetail.m
//  flashapp
//
//  Created by zhen fang on 11-12-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "StatsDetail.h"

@implementation StatsDetail

@synthesize id;
@synthesize userAgent;
@synthesize before;
@synthesize after;
@synthesize accessDay;
@synthesize createTime;
@synthesize uaId;
@synthesize uaStr;


-(void)dealloc{
    [userAgent release];
    [uaId release];
    [uaStr release];
    [super dealloc];
}


- (NSComparisonResult) compareByBefore:(StatsDetail*)st
{
    if ( self.before < st.before ) {
        return NSOrderedAscending;
    }
    else if ( self.before > st.before ) {
        return NSOrderedDescending;
    }
    else {
        return NSOrderedSame;
    }
}


- (NSComparisonResult) compareByAfter:(StatsDetail*)st
{
    if ( self.after < st.after ) {
        return NSOrderedDescending;
    }
    else if ( self.after > st.after ) {
        return NSOrderedAscending;
    }
    else {
        return NSOrderedSame;
    }
}

- (NSComparisonResult) compareByJieSheng:(StatsDetail*)st
{
    long long num = st.after - st.before;
    
    long long num1 = self.after - self.before;
    
    if (num1 < num) {
        return NSOrderedAscending;
    }else {
        return  NSOrderedSame;
    }

}



- (NSComparisonResult) compareByPercent:(StatsDetail*)st
{
    if ( self.before == 0 ) return NSOrderedDescending;
    if ( st.before == 0 ) return NSOrderedAscending ;
    
    float p = self.after * 1.0f / self.before;
    float p1 = st.after * 1.0f / st.before;
    
    if ( p > p1 ) {
        return NSOrderedDescending;
    }
    else if ( p < p1 ) {
        return NSOrderedAscending;
    }
    else {
        return NSOrderedSame;
    }
}


@end
