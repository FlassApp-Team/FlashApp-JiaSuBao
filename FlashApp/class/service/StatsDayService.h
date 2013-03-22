//
//  StatsDayService.h
//  flashapp
//
//  Created by zhen fang on 11-12-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatsDay.h"

@interface StatsDayService : NSObject{
    
}


+ (void) explainURL;
+ (void) explainAccessLog:(time_t)lastDayLong serverTime:(time_t)serverTime data:(NSArray*)statsArray;
+ (void) explainMonthStats:(time_t)startTime endTime:(time_t)endTime;
+ (void) explainMonthDetailStats:(time_t)startTime endTime:(time_t)endTime;

+(void)getMaxStats:(StatsDay *)statsDay;
+(void)deleteLastMonth:(time_t)lastDayLong;
+(void)getThirdUserAgent:(NSMutableArray *)array;
@end
