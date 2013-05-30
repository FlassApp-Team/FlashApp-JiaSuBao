//
//  StatsMonthDAO.h
//  flashapp
//
//  Created by zhen fang on 11-12-15.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TotalStats.h"
#import "StatsDay.h"
#import "StatsDetail.h"
#import "StageStats.h"

@interface StatsMonthDAO : NSObject{
    
}

+ (void) deleteStatsMonth : (time_t)lastMonthTime;
+ (void) deleteStatsMonthDetail : (time_t)lastMonthTime;

+ (StageStats*) statForPeriod:(time_t)startTime endTime:(time_t)endTime;
+ (NSArray*) userAgentStatsForPeriod:(time_t)startTime endTime:(time_t)endTime orderby:(NSString*)orderby;
+ (NSArray*) userAgentStatsForPeriod:(time_t)startTime endTime:(time_t)endTime orderby:(NSString*)orderby limit:(NSInteger)rows;

+ (void) addStatsMonth:(time_t)accessDay bytesBefore:(long)before bytesAfter:(long)after;
+ (void) addStatMonthDetail:(StatsDetail*)stat;

+ (StatsDay*) getStatsMonth:(time_t)month;
+ (StatsDay*) getStatsMonth:(time_t)month option:(NSString*)option;
+ (NSArray*) getDetailStatsMonth:(time_t)month limit:(NSInteger)limit;
+ (time_t) getFirstStatsMonth;


@end
