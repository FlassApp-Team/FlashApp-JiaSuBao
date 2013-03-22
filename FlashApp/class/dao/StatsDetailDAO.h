//
//  StatsDetailDAO.h
//  flashapp
//
//  Created by zhen fang on 11-12-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatsDetail.h"

@interface StatsDetailDAO : NSObject

+ (void) deleteStatsDetail : (long long)accessDay;
+ (void) addStatsDetail : (StatsDetail *)statsDetail;
+ (StatsDetail*) getFirstStatsDetailAfter:(time_t)time userAgent:(NSString*)userAgent;
+ (StatsDetail*) getLastStatsDetailBefore:(time_t)time userAgent:(NSString*)userAgent;
+ (NSDictionary*) getStateDetailsForAccessDay:(time_t)accessDay;
+ (void) incrStatsDetail:(StatsDetail*)statsDetail;
+ (NSDictionary*) getUserAgentDicFor:(NSArray*)userAgentArr;

@end
