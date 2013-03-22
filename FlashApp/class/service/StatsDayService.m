//
//  StatsDayService.m
//  flashapp
//
//  Created by zhen fang on 11-12-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "StatsDayService.h"
#import "StatsDayDAO.h"
#import "StatsDetailDAO.h"
#import "TwitterClient.h"
#import "StatsDay.h"
#import "StatsDetail.h"
#import "StatsMonthDAO.h"
#import "JSON.h"
#import "DateUtils.h"
#import "DBConnection.h"
#import "StageStats.h"

@implementation StatsDayService

#pragma mark - explain accessLog methods
+ (void)explainURL {
    /*time_t lastDayLong = [StatsDayDAO getLastDay];
    NSString* lastDayString = [DateUtils stringWithDateFormat:lastDayLong format:@"yyyy-MM-dd"];
    NSArray* statsArray = [TwitterClient getStatsData:lastDayString];
    [StatsDayService explainAccessLog:lastDayLong data:statsArray];*/
}


//如果取的数据是当天的数据，则为增量数据。 增量处理当天的数据
+ (void) explainAccessLogOnlyToday:(time_t)lastDayLong data:(StatsDay*)statsDay
{
    if ( statsDay.totalBefore <= 0 ) return;
    if ( statsDay.totalBefore < statsDay.totalAfter ) return;
    
    NSArray* statsDetailList = statsDay.statsDetailArray;
    if ( !statsDetailList || [statsDetailList count] == 0 ) return;

    //更新stats_day表
    [StatsDayDAO incrStatsDay:statsDay];
    
    //更新stats_detail表
    NSDictionary* dic = [StatsDetailDAO getStateDetailsForAccessDay:statsDay.accessDay];
    for(StatsDetail* detail in statsDetailList) {
        StatsDetail* d = [dic objectForKey:detail.userAgent];
        if ( d ) {
            detail.id = d.id;
            [StatsDetailDAO incrStatsDetail:detail];
        }
        else {
            [StatsDetailDAO addStatsDetail:detail];
        }
    }
}


//如果取的数据非今天数据，则不是增量数据。删除最后一天的数据后，全量更新
+ (void) explainAccessLogHistory:(time_t)lastDayLong data:(NSArray*)statsArray
{
    if ( !statsArray || [statsArray count] == 0 ) return;
    
    NSMutableDictionary* totalCompressDic = [NSMutableDictionary dictionary];
    NSMutableDictionary* userAgentDic = [NSMutableDictionary dictionary];
    
    time_t firstDayOfMonth = 0;
    time_t lastDayOfMonth = 0;
    if ( lastDayLong > 0 ) {
        firstDayOfMonth = [DateUtils getFirstDayOfMonth:lastDayLong];
        lastDayOfMonth = [DateUtils getLastDayOfMonth:lastDayLong];
    }
    
    if ( lastDayLong > 0 ) {
        [StatsDayDAO deleteStatsDay:lastDayLong];
        [StatsDetailDAO deleteStatsDetail:lastDayLong];
    }
    
    for ( StatsDay* statsDay in statsArray ) {
        NSMutableArray* statsDetailList = statsDay.statsDetailArray;
        if ( statsDay.totalBefore < statsDay.totalAfter || statsDay.totalBefore <= 0 ) continue;
        if ( !statsDetailList || [statsDetailList count] == 0 ) continue;
        
        [StatsDayDAO addStatsDay:statsDay];
        
        time_t monthDay = [DateUtils getFirstDayOfMonth:statsDay.accessDay];
        if ( monthDay != firstDayOfMonth ) {
            //不是当月的数据
            //当月的数据通过数据库直接统计
            NSNumber* key = [NSNumber numberWithLong:monthDay];
            TotalStats* value = [totalCompressDic objectForKey:key];
            if ( value ) {
                value.totalbefore += statsDay.totalBefore;
                value.totalafter += statsDay.totalAfter;
            }
            else {
                value = [[TotalStats alloc] init];
                value.totalbefore = statsDay.totalBefore;
                value.totalafter = statsDay.totalAfter;
                [totalCompressDic setObject:value forKey:key];
            }
        }
        
        for(StatsDetail* detail in statsDetailList){
            [StatsDetailDAO addStatsDetail:detail];
            
            if ( monthDay != firstDayOfMonth ) {
                //不是当月的数据
                //当月的数据通过数据库直接统计
                NSString* userAgentKey = [NSString stringWithFormat:@"%ld_%@", monthDay, detail.userAgent];
                StatsDetail* stats = [userAgentDic objectForKey:userAgentKey];
                if ( stats ) {
                    stats.before += detail.before;
                    stats.after += detail.after;
                }
                else {
                    stats = [[[StatsDetail alloc] init] autorelease];//add jianfei han 2013-03-01
                    stats.accessDay = monthDay;
                    stats.before = detail.before;
                    stats.after = detail.after;
                    stats.userAgent = detail.userAgent;
                    stats.uaId = detail.uaId;
                    stats.uaStr = detail.uaStr;
                    [userAgentDic setObject:stats forKey:userAgentKey];
                }
            }
        }
    }
    
    //更新stats_month表
    for ( NSNumber* key in [totalCompressDic allKeys] ) {
        TotalStats* value = [totalCompressDic objectForKey:key];
        if ( value.totalbefore > 0 && value.totalbefore >= value.totalafter ) {
            [StatsMonthDAO addStatsMonth:[key longValue] bytesBefore:value.totalbefore bytesAfter:value.totalafter];
        }
    }
    
    //更新stats_month_detail表
    for ( NSString* key in [userAgentDic allKeys] ) {
        StatsDetail* stats = [userAgentDic objectForKey:key];
        if ( stats.before > 0 && stats.before - stats.after >= 0 ) {
            [StatsMonthDAO addStatMonthDetail:stats];
        }
    }
}


+ (void)explainAccessLog:(time_t)lastDayLong serverTime:(time_t)serverTime data:(NSArray*)statsArray
{
    if ( !statsArray || [statsArray count] == 0 ) return;
    
    [DBConnection beginTransaction];
    
    //如果取的数据是当天的数据，则为增量数据，不需要删除本地数据；
    //否则删除本地数据
    BOOL isToday = NO;
    if ( lastDayLong > 0 ) {
        time_t t1 = [DateUtils getFirstTimeOfDay:serverTime];
        time_t t2 = [DateUtils getFirstTimeOfDay:lastDayLong];
        if ( t1 == t2 ) {
            isToday = YES;
        }
    }
    
    if ( isToday ) {
        //本地最后一条数据的时间，与服务器的当前时间是同一天
        StatsDay* statsDay = [statsArray objectAtIndex:0];
        [self explainAccessLogOnlyToday:lastDayLong data:statsDay];
    }
    else {
        [self explainAccessLogHistory:lastDayLong data:statsArray];
    }
    
    //更新本月的统计数据
    if ( lastDayLong > 0 ) {
        time_t firstDayOfMonth = [DateUtils getFirstDayOfMonth:lastDayLong];
        time_t lastDayOfMonth = [DateUtils getLastDayOfMonth:lastDayLong];
        
        [StatsDayService explainMonthStats:firstDayOfMonth endTime:lastDayOfMonth];
        [StatsDayService explainMonthDetailStats:firstDayOfMonth endTime:lastDayOfMonth];
    }

    [DBConnection commitTransaction];
}



//+ (void)explainAccessLog:(time_t)lastDayLong serverTime:(time_t)serverTime data:(NSArray*)statsArray
//{
//    if ( !statsArray || [statsArray count] == 0 ) return;
//
//    NSMutableDictionary* totalCompressDic = [NSMutableDictionary dictionary];
//    NSMutableDictionary* userAgentDic = [NSMutableDictionary dictionary];
//    
//    time_t firstDayOfMonth = 0;
//    time_t lastDayOfMonth = 0;
//    if ( lastDayLong > 0 ) {
//        firstDayOfMonth = [DateUtils getFirstDayOfMonth:lastDayLong];
//        lastDayOfMonth = [DateUtils getLastDayOfMonth:lastDayLong];
//    }
//    
//    [DBConnection beginTransaction];
//
//    //如果取的数据是当天的数据，则为增量数据，不需要删除本地数据；
//    //否则删除本地数据
//    if ( lastDayLong > 0 ) {
//        time_t t1 = [DateUtils getFirstTimeOfDay:serverTime];
//        time_t t2 = [DateUtils getFirstTimeOfDay:lastDayLong];
//        if ( t1 != t2 ) {
//            //本地最后一条数据的时间，与服务器的当前时间是同一天
//            [StatsDayDAO deleteStatsDay:lastDayLong];
//            [StatsDetailDAO deleteStatsDetail:lastDayLong];
//        }
//    }
//    
//    for ( StatsDay* statsDay in statsArray ) {
//        if ( statsDay.totalBefore < statsDay.totalAfter || statsDay.totalBefore <= 0 ) continue;
//        [StatsDayDAO addStatsDay:statsDay];
//        
//        time_t monthDay = [DateUtils getFirstDayOfMonth:statsDay.accessDay];
//        if ( monthDay != firstDayOfMonth ) {
//            NSNumber* key = [NSNumber numberWithLong:monthDay];
//            TotalStats* value = [totalCompressDic objectForKey:key];
//            if ( value ) {
//                value.totalbefore += statsDay.totalBefore;
//                value.totalafter += statsDay.totalAfter;
//            }
//            else {
//                value = [[TotalStats alloc] init];
//                value.totalbefore = statsDay.totalBefore;
//                value.totalafter = statsDay.totalAfter;
//                [totalCompressDic setObject:value forKey:key];
//            }
//        }
//        
//        NSMutableArray* statsDetailList = statsDay.statsDetailArray;
//        for(StatsDetail* detail in statsDetailList){
//            [StatsDetailDAO addStatsDetail:detail];
//            
//            if ( monthDay != firstDayOfMonth ) {
//                NSString* userAgentKey = [NSString stringWithFormat:@"%ld_%@", monthDay, detail.userAgent];
//                StatsDetail* stats = [userAgentDic objectForKey:userAgentKey];
//                if ( stats ) {
//                    stats.before += detail.before;
//                    stats.after += detail.after;
//                }
//                else {
//                    stats = [[StatsDetail alloc] init];
//                    stats.accessDay = monthDay;
//                    stats.before = detail.before;
//                    stats.after = detail.after;
//                    stats.userAgent = detail.userAgent;
//                    [userAgentDic setObject:stats forKey:userAgentKey];
//                }
//            }
//        }
//    }
//    
//    if ( lastDayLong > 0 ) {
//        [StatsDayService explainMonthStats:firstDayOfMonth endTime:lastDayOfMonth];
//        [StatsDayService explainMonthDetailStats:firstDayOfMonth endTime:lastDayOfMonth];
//    }
//    
//    for ( NSNumber* key in [totalCompressDic allKeys] ) {
//        TotalStats* value = [totalCompressDic objectForKey:key];
//        if ( value.totalbefore > 0 && value.totalbefore >= value.totalafter ) {
//            [StatsMonthDAO addStatsMonth:[key longValue] bytesBefore:value.totalbefore bytesAfter:value.totalafter];
//        }
//    }
//    
//    for ( NSString* key in [userAgentDic allKeys] ) {
//        StatsDetail* stats = [userAgentDic objectForKey:key];
//        if ( stats.before > 0 && stats.before - stats.after >= 0 ) {
//            [StatsMonthDAO addStatMonthDetail:stats];
//        }
//    }
//    [DBConnection commitTransaction];
//}


+ (void) explainMonthStats:(time_t)startTime endTime:(time_t)endTime
{
    [StatsMonthDAO deleteStatsMonth:startTime];
    
    StageStats* stats = [StatsMonthDAO statForPeriod:startTime endTime:endTime];
    if ( stats ) {
        if ( stats.bytesAfter >= 0 && stats.bytesBefore > stats.bytesAfter ) {
            [StatsMonthDAO addStatsMonth:startTime bytesBefore:stats.bytesBefore bytesAfter:stats.bytesAfter];
        }
    }
}


+ (void) explainMonthDetailStats:(time_t)startTime endTime:(time_t)endTime
{
    [StatsMonthDAO deleteStatsMonthDetail:startTime];
    
    NSArray* userAgentStatsList = [StatsMonthDAO userAgentStatsForPeriod:startTime endTime:endTime orderby:nil];
    if ( userAgentStatsList && [userAgentStatsList count] > 0 ) {
        for ( StatsDetail* stats in userAgentStatsList ) {
            if ( stats.before > 0 && stats.before - stats.after >= 0 ) {
                [StatsMonthDAO addStatMonthDetail:stats];
            }
        }
    }
}


#pragma mark - get max stats
+(void)getMaxStats:(StatsDay *)statsDay{
    NSDate* nowDay = [NSDate date];       
    time_t nowtime = (time_t) [nowDay timeIntervalSince1970];    
    time_t nowMinMonth = [DateUtils getFirstDayOfMonth:nowtime];
    [StatsDayDAO getMaxStats:statsDay nowDayLong:nowtime nowMinMonthLong:nowMinMonth];

}

#pragma mark - delete last month stats
+(void)deleteLastMonth:(time_t)lastDayLong {
    time_t firstDayOfMonth = [DateUtils getFirstDayOfMonth:lastDayLong];
    [StatsMonthDAO deleteStatsMonth:firstDayOfMonth];
    [StatsMonthDAO deleteStatsMonthDetail:firstDayOfMonth];
}


#pragma mark - get third userAgent
+(void)getThirdUserAgent:(NSMutableArray *)array{
    [StatsDayDAO getThirdUserAgent:array];
}

@end
