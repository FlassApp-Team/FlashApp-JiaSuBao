//
//  StatsMonthDAO.m
//  flashapp
//
//  Created by zhen fang on 11-12-15.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "StatsMonthDAO.h"
#import "StatsDetailDAO.h"
#import "DBConnection.h"
#import "Statement.h"
#import "StatsDetail.h"
#import "StatsDay.h"


@implementation StatsMonthDAO
/*删除最后一次月份的统计*/
+ (void) deleteStatsMonth : (time_t)lastMonthTime{    
    sqlite3* conn = [DBConnection getDatabase];
	char* sql = "delete from STATS_MONTH where accessMonth = ?";
	
	Statement* stmt = [[Statement alloc] initWithDB:conn sql:sql];
	[stmt bindInt64:(long long)lastMonthTime forIndex:1];
	if ( [stmt step] != SQLITE_DONE ) {
        [stmt release];
		NSAssert2( 0, @"sql error. %s (%s)", sql, sqlite3_errmsg(conn) );
	}	
    else {
        [stmt release];
    }
}


/*删除最后一次月份的详细统计*/
+ (void) deleteStatsMonthDetail : (time_t)lastMonthTime{    
    sqlite3* conn = [DBConnection getDatabase];
	char* sql = "delete from STATS_MONTH_DETAIL where accessMonth = ?";
	
	Statement* stmt = [[Statement alloc] initWithDB:conn sql:sql];
	[stmt bindInt64:(long long)lastMonthTime forIndex:1];
	if ( [stmt step] != SQLITE_DONE ) {
        [stmt release];
		NSAssert2( 0, @"sql error. %s (%s)", sql, sqlite3_errmsg(conn) );
	}	
    else {
        [stmt release];
    }
}


+ (StageStats*) statForPeriod:(time_t)startTime endTime:(time_t)endTime
{
    sqlite3* conn = [DBConnection getDatabase];
    
    NSMutableString* where = [NSMutableString stringWithString:@""];
    if ( startTime > 0 ) {
        [where appendString:@" and accessDay >= ?"];
    } 
    
    if ( endTime > 0 ) {
        [where appendString:@" and accessDay <= ?"];
    }
    
    NSString* sql = [NSString stringWithFormat:@"select sum(totalBefore), sum(totalAfter) from stats_day %@", [where length] > 0 ? [NSString stringWithFormat:@" where %@", [where substringFromIndex:4]] : @""];
    
    StageStats* stats = nil;
    Statement* stmt = [[Statement alloc] initWithDB:conn sql:(char*)[sql UTF8String]];
    
    int i = 1;
    if ( startTime > 0 ) {
        [stmt bindInt64:(long long)startTime forIndex:i];
        i++;
    }
    
    if ( endTime > 0 ) {
        [stmt bindInt64:(long long)endTime forIndex:i];
    }

    if ( [stmt step] == SQLITE_ROW ) {
        stats = [[[StageStats alloc] init] autorelease];
        stats.bytesBefore = [stmt getInt64:0];
        stats.bytesAfter = [stmt getInt64:1];
        stats.startTime = startTime;
        stats.endTime = endTime;
    }
    
    [stmt release];
    
    //if ( stats.bytesBefore == 0 ) stats = nil;
    
    return stats;
}


+ (NSArray*) userAgentStatsForPeriod:(time_t)startTime endTime:(time_t)endTime orderby:(NSString*)orderby
{
    return [StatsMonthDAO userAgentStatsForPeriod:startTime endTime:endTime orderby:orderby limit:0];
}


+ (NSArray*) userAgentStatsForPeriod:(time_t)startTime endTime:(time_t)endTime orderby:(NSString*)orderby limit:(NSInteger)rows
{
    sqlite3* conn = [DBConnection getDatabase];
    
    NSMutableString* where = [NSMutableString stringWithString:@" where before > 0"];
    if ( startTime > 0 ) {
        [where appendString:@" and accessDay >= ?"];
    }
    
    if ( endTime > 0 ) {
        [where appendString:@" and accessDay <= ?"];
    }
    
    NSMutableString* sql = [NSMutableString stringWithFormat:@"select userAgent, sum(before) total_before, sum(after) total_after from stats_detail %@", where];
    [sql appendString:@" group by userAgent"];
    
    if ( [@"compress" compare:orderby] == NSOrderedSame ) {
        [sql appendString:@" order by total_after * 1.0 / total_before"];
    }
    else if ( [@"totalBefore" compare:orderby] == NSOrderedSame ) {
        [sql appendString:@" order by total_before"];
    }
    
    if ( rows > 0 ) {
        [sql appendString:@" limit ?"];
    }

    NSMutableArray* array = [NSMutableArray array];
    
    Statement* stmt = [[Statement alloc] initWithDB:conn sql:(char*)[sql UTF8String]];
    
    int index = 1;
    if ( startTime > 0 ) {
        [stmt bindInt64:(long long)startTime forIndex:index];
        index++;
    }
    
    if ( endTime > 0 ) {
        [stmt bindInt64:(long long)endTime forIndex:index];
        index++;
    }
    
    if ( rows > 0 ) {
        [stmt bindInt32:rows forIndex:index];
    }
    
    NSMutableArray* userAgentArr = [NSMutableArray array];
    while ( [stmt step] == SQLITE_ROW ) {
        StatsDetail* stats = [[StatsDetail alloc] init];
        stats.userAgent = [stmt getString:0];
        stats.before = [stmt getInt64:1];
        stats.after = [stmt getInt64:2];
        stats.accessDay = startTime;
//        [array addObject:stats];
//        [userAgentArr addObject:stats.userAgent];
    //add jianfei han 2013-03-04
        if(![stats.userAgent isEqualToString:@"网页"])
        {
            [array addObject:stats];
            [userAgentArr addObject:stats.userAgent];
        }
     //end

        [stats release];
    }
    
    [stmt release];
    
    //设置useragent和uaId, uaStr的对应关系
    NSDictionary* dic = [StatsDetailDAO getUserAgentDicFor:userAgentArr];
    for ( StatsDetail* stats in array ) {
        NSArray* arr = [dic objectForKey:stats.userAgent];
        if ( arr ) {
            stats.uaId = [arr objectAtIndex:0];
            stats.uaStr = [arr objectAtIndex:1];
        }
    }
    return array;
}


+ (void) addStatsMonth:(time_t)accessDay bytesBefore:(long)before bytesAfter:(long)after
{
    long now;
    time(&now);
    
    sqlite3* conn = [DBConnection getDatabase];
    char* sql = "insert into stats_month (totalStats, accessMonth, createTime, totalBefore, totalAfter) values (?,?,?,?,?)";
    
    Statement* stmt = [[Statement alloc] initWithDB:conn sql:sql];
    [stmt bindInt64:(long long)(before - after) forIndex:1];
    [stmt bindInt64:(long long)accessDay forIndex:2];
    [stmt bindInt64:(long long)now forIndex:3];
    [stmt bindInt64:(long long)before forIndex:4];
    [stmt bindInt64:(long long)after forIndex:5];
    
	if ( [stmt step] != SQLITE_DONE ) {
        [stmt release];
		NSAssert2( 0, @"sql error. %s (%s)", sql, sqlite3_errmsg(conn) );
	}	
    else {
        [stmt release];
    }
}


+ (void) addStatMonthDetail:(StatsDetail*)stat
{
    long now;
    time(&now);
    
    sqlite3* conn = [DBConnection getDatabase];
    char* sql = "insert into stats_month_detail (userAgent, totalBefore, totalAfter, totalStats, accessMonth, createTime, uaid, uastr) values (?,?,?,?,?,?,?,?)";
    
    Statement* stmt = [[Statement alloc] initWithDB:conn sql:sql];
    [stmt bindString:stat.userAgent forIndex:1];
    [stmt bindInt64:(long long)stat.before forIndex:2];
    [stmt bindInt64:(long long)stat.after forIndex:3];
    [stmt bindInt64:(long long)(stat.before - stat.after) forIndex:4];
    [stmt bindInt64:(long long)stat.accessDay forIndex:5];
    [stmt bindInt64:(long long)now forIndex:6];
    [stmt bindString:stat.uaId forIndex:7];
    [stmt bindString:stat.uaStr forIndex:8];
    
	if ( [stmt step] != SQLITE_DONE ) {
        [stmt release];
		NSAssert2( 0, @"sql error. %s (%s)", sql, sqlite3_errmsg(conn) );
	}	
    else {
        [stmt release];
    }
}


+ (StatsDay*) getStatsMonth:(time_t)month option:(NSString*)option
{
    sqlite3* conn = [DBConnection getDatabase];
    NSMutableString* sql = [NSMutableString stringWithString:@"select totalStats, accessMonth, totalBefore, totalAfter from stats_month"];
    
    if ( [@"prev" compare:option] == NSOrderedSame ) {
        [sql appendString:@" where accessMonth < ? order by accessMonth desc limit 1"];
    }
    else if ( [@"next" compare:option] == NSOrderedSame ) {
        [sql appendString:@" where accessMonth > ? order by accessMonth limit 1"];
    }
    else {
        [sql appendString:@" where accessMonth = ?"];
    }
    
    Statement* stmt = [[Statement alloc] initWithDB:conn sql:(char*)[sql UTF8String]];
    
    StatsDay* stats = nil;
    [stmt bindInt64:(long long)month forIndex:1];
    if ( [stmt step] == SQLITE_ROW ) {
        stats = [[[StatsDay alloc] init] autorelease];
        stats.totalStats = [stmt getInt64:0];
        stats.accessDay = [stmt getInt32:1];
        stats.totalBefore = [stmt getInt64:2];
        stats.totalAfter = [stmt getInt64:3];
    }
    
    [stmt release];
    return stats;
}


+ (time_t) getFirstStatsMonth
{
    sqlite3* conn = [DBConnection getDatabase];
    NSMutableString* sql = [NSMutableString stringWithString:@"select min(accessMonth) from stats_month"];
    Statement* stmt = [[Statement alloc] initWithDB:conn sql:(char*)[sql UTF8String]];

    time_t t = 0;
    if ( [stmt step] == SQLITE_ROW ) {
        t = [stmt getInt64:0];
    }
    
    [stmt release];
    return t;
}


+ (StatsDay*) getStatsMonth:(time_t)month
{
    return [StatsMonthDAO getStatsMonth:month option:nil];
}


+ (NSArray*) getDetailStatsMonth:(time_t)month limit:(NSInteger)limit
{
    sqlite3* conn = [DBConnection getDatabase];
    NSMutableString* sql = [NSMutableString stringWithString:@"select userAgent, totalStats, totalBefore, totalAfter, uaid, uastr from stats_month_detail where accessMonth = ? order by totalAfter desc"];
    if ( limit > 0 ) {
        [sql appendString:@" limit ?"];
    }
    
    NSMutableArray* array = [NSMutableArray array];
    Statement* stmt = [[Statement alloc] initWithDB:conn sql:(char*)[sql UTF8String]];
    [stmt bindInt64:(long long)month forIndex:1];
    if ( limit > 0 ) [stmt bindInt32:limit forIndex:2];
    
    TotalStats* stats;
    while ( [stmt step] == SQLITE_ROW ) {
        stats = [[TotalStats alloc] init];
        stats.userAgent = [stmt getString:0];
        stats.totalstats = [stmt getInt64:1];
        stats.totalbefore = [stmt getInt64:2];
        stats.totalafter = [stmt getInt64:3];
        stats.uaId = [stmt getString:4];
        stats.uaStr = [stmt getString:5];
        [array addObject:stats];
        [stats release];
    }
    
    [stmt release];
    return array;
    
}

@end
