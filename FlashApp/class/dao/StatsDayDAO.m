//
//  StatsDayDAO.m
//  flashapp
//
//  Created by zhen fang on 11-12-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "StatsDayDAO.h"
#import "DBConnection.h"
#import "Statement.h"
#import "StatsDetail.h"
#import "DateUtils.h"
@implementation StatsDayDAO

/*删除最后一天的数据*/
+ (void) deleteStatsDay : (long long)accessDay{
    sqlite3* conn = [DBConnection getDatabase];
	char* sql = "delete from  STATS_DAY  where accessDay = ?";
	
	Statement* stmt = [[Statement alloc] initWithDB:conn sql:sql];
	[stmt bindInt64:accessDay forIndex:1];
	if ( [stmt step] != SQLITE_DONE ) {
        [stmt release];
		NSAssert2( 0, @"sql error. %s (%s)", sql, sqlite3_errmsg(conn) );
	}
	else {
        [stmt release];
    }
}


/*插入数据*/
+ (void) addStatsDay : (StatsDay *)statsDay
{
    if ( statsDay.totalBefore < statsDay.totalAfter ) return;
    
    sqlite3* conn = [DBConnection getDatabase];
    char* sql = "INSERT INTO STATS_DAY (totalBefore, totalAfter, accessDay,createTime) VALUES(?,?,?,?)";
    
	Statement* stmt = [[Statement alloc] initWithDB:conn sql:sql];
	[stmt bindInt64:statsDay.totalBefore forIndex:1];
	[stmt bindInt64:statsDay.totalAfter forIndex:2];
	[stmt bindInt64:statsDay.accessDay forIndex:3];    
	[stmt bindInt64:statsDay.createTime forIndex:4];
	
	if ( [stmt step] != SQLITE_DONE ) {
        [stmt release];
		NSAssert2( 0, @"sql error. %s (%s)", sql, sqlite3_errmsg(conn) );
	}	
    else {
        [stmt release];
    }
}


+ (void) incrStatsDay:(StatsDay*)statsDay
{
    if ( statsDay.totalBefore < statsDay.totalAfter ) return;

    sqlite3* conn = [DBConnection getDatabase];
    char* sql = "update stats_day set totalBefore = totalBefore + ?, totalAfter = totalAfter + ? where accessDay = ?";
    
	Statement* stmt = [[Statement alloc] initWithDB:conn sql:sql];
	[stmt bindInt64:statsDay.totalBefore forIndex:1];
	[stmt bindInt64:statsDay.totalAfter forIndex:2];
	[stmt bindInt64:statsDay.accessDay forIndex:3];
	
	if ( [stmt step] != SQLITE_DONE ) {
        [stmt release];
		NSAssert2( 0, @"sql error. %s (%s)", sql, sqlite3_errmsg(conn) );
	}
    else {
        [stmt release];
    }
}


/*获取第一次访问的时间*/
+ (time_t) getfirstDay
{
    sqlite3* conn = [DBConnection getDatabase];
	char* sql = "SELECT  min(accessDay) lastDay  FROM STATS_DAY";
	time_t firstDay = 0;
	Statement* stmt = [[Statement alloc] initWithDB:conn sql:sql];	
	if ( [stmt step] == SQLITE_ROW ) {
		firstDay = (time_t) [stmt getInt64:0];
	}	
	[stmt release];
	return firstDay;
}


/*获取最后一次访问的时间*/
+ (time_t) getLastDay
{
    sqlite3* conn = [DBConnection getDatabase];
	char* sql = "SELECT  max(accessDay) lastDay  FROM STATS_DAY";
	time_t lastDay = 0;
	Statement* stmt = [[Statement alloc] initWithDB:conn sql:sql];	
	if ( [stmt step] == SQLITE_ROW ) {
		lastDay = (time_t) [stmt getInt64:0];
	}	
	[stmt release];
	return lastDay;
}


/*查询该用户是否有数据*/
+(int)getCount{
    sqlite3* conn = [DBConnection getDatabase];
	char* sql = "select count(*)num from stats_day";
	int count = 0;
	Statement* stmt = [[Statement alloc] initWithDB:conn sql:sql];	
	if ( [stmt step] == SQLITE_ROW ) {
		count = [stmt getInt64:0];
	}	
	[stmt release];
	return count;
}


/*查询所有已节省流量总和以及本月节省的流量(返回值为statsDay)*/
+(void)getMaxStats:(StatsDay *)statsDay nowDayLong:(time_t)nowDayLong nowMinMonthLong:(time_t)nowMinMonthLong{
     
    sqlite3* conn = [DBConnection getDatabase];
	char* sql = "select (sum(totalbefore) - sum(totalafter)) totalMonthStats,sum(totalbefore) monthTotalBefore,(select (sum(totalbefore) - sum(totalafter))totalStats from stats_day)totalStats from stats_day where accessDay<=? and accessDay >= ?";
	Statement* stmt = [[Statement alloc] initWithDB:conn sql:sql];
	[stmt bindInt64:(long long)nowDayLong forIndex:1];
	[stmt bindInt64:(long long)nowMinMonthLong forIndex:2];

	if ( [stmt step] == SQLITE_ROW ) {
        statsDay.totalStats = [stmt getInt64:0];
		statsDay.monthTotalStats = [stmt getInt64:1];
        statsDay.monthTotalBefore = [stmt getInt64:2];
	}
	[stmt release];
}


/*获取前3名的流量应用*/
+(void)getThirdUserAgent:(NSMutableArray *)array{
    
    sqlite3* conn = [DBConnection getDatabase];
	char* sql = "SELECT userAgent,(SUM(before)-sum(after)) totalstats,sum(before) totalbefore ,((SUM(before)-sum(after))*1.0/sum(before)) divstats,sum(after) totalafter  FROM  stats_detail  GROUP BY userAgent order by divstats desc limit 0,3";
	Statement* stmt = [[Statement alloc] initWithDB:conn sql:sql];
    TotalStats *totalStats;
	while ( [stmt step] == SQLITE_ROW ) {
		totalStats = [[TotalStats alloc] init];	
		totalStats.userAgent = [stmt getString:0];
        totalStats.totalstats = [stmt getInt64:1];
        totalStats.totalbefore = [stmt getInt64:2];
        totalStats.divstats = [[stmt getString:3] doubleValue];
        totalStats.totalafter = [stmt getInt64:4];
		[array addObject:totalStats];
		[totalStats release];
		
	}
    [stmt release];//add jianfei han 2013-03-01
}


+ (NSArray*) getUserAgentData:(NSString*)userAgent start:(time_t)start end:(time_t)end
{
    sqlite3* conn = [DBConnection getDatabase];
    
    char* sql = "select before, after, accessday from stats_detail where userAgent = ? and accessDay between ? and ? order by accessDay";
    Statement* stmt = [[Statement alloc] initWithDB:conn sql:sql];
    [stmt bindString:userAgent forIndex:1];
    [stmt bindInt64:start forIndex:2];
    [stmt bindInt64:end forIndex:3];
    
    NSMutableArray* array = [NSMutableArray array];
    StatsDetail* stats;
    
    while ( [stmt step] == SQLITE_ROW ) {
        stats = [[StatsDetail alloc] init];
        stats.before = [stmt getInt64:0];
        stats.after = [stmt getInt64:1];
        stats.accessDay = [stmt getInt64:2];
        [array addObject:stats];
        [stats release];
    }

    [stmt release];
    return array;
    
 

    
}
+ (NSArray*) getDayOfMonthData:(time_t)start end:(time_t)end//add jianfei han 2013-01-30
{
    sqlite3* conn = [DBConnection getDatabase];
    
    char* sql = "select id, totalBefore, totalAfter, accessDay from stats_day where accessDay >= ? and accessDay <= ?";
    Statement* stmt = [[Statement alloc] initWithDB:conn sql:sql];
    [stmt bindInt64:start forIndex:1];
    [stmt bindInt64:end forIndex:2];
    
    NSMutableArray* array = [NSMutableArray array];
    StatsDay* stats;
    
    while ( [stmt step] == SQLITE_ROW ) {
        stats = [[StatsDay alloc] init];
        stats.totalBefore = [stmt getInt64:1];
        stats.totalAfter = [stmt getInt64:2];
        stats.accessDay = [stmt getInt64:3];
       // NSLog(@"GGGGGGG%lld", stats.accessDay);
        [array addObject:stats];
        [stats release];
    }
    
    [stmt release];
    return array;
    
    
    
}
@end
