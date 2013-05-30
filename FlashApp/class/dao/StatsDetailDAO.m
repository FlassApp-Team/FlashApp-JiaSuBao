//
//  StatsDetailDAO.m
//  flashapp
//
//  Created by zhen fang on 11-12-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "StatsDetailDAO.h"
#import "DBConnection.h"
#import "Statement.h"

@implementation StatsDetailDAO

#pragma delete statsDetail
+ (void) deleteStatsDetail : (long long)accessDay {
    sqlite3* conn = [DBConnection getDatabase];
	char* sql = "delete from  STATS_DETAIL  where accessDay = ?";
	
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


#pragma add statsDetail
+ (void) addStatsDetail : (StatsDetail *)statsDetail
{
    sqlite3* conn = [DBConnection getDatabase];
    char* sql = "INSERT INTO STATS_DETAIL (userAgent, before,after, accessDay,createTime, uaid, uastr) VALUES(?,?,?,?,?,?,?)";
    
	Statement* stmt = [[Statement alloc] initWithDB:conn sql:sql];
	[stmt bindString:statsDetail.userAgent forIndex:1];
	[stmt bindInt64:statsDetail.before forIndex:2];
	[stmt bindInt64:statsDetail.after forIndex:3];    
	[stmt bindInt64:statsDetail.accessDay forIndex:4];
    [stmt bindInt64:statsDetail.createTime forIndex:5];
	[stmt bindString:statsDetail.uaId forIndex:6];
	[stmt bindString:statsDetail.uaStr forIndex:7];
	
	if ( [stmt step] != SQLITE_DONE ) {
        [stmt release];   
		NSAssert2( 0, @"sql error. %s (%s)", sql, sqlite3_errmsg(conn) );
	}	
    else {
        [stmt release];   
    }
}


+ (void) incrStatsDetail:(StatsDetail*)statsDetail
{
    sqlite3* conn = [DBConnection getDatabase];
    char* sql = "update stats_detail set before = before + ?, after = after + ? where id = ?";
    
	Statement* stmt = [[Statement alloc] initWithDB:conn sql:sql];
	[stmt bindInt64:statsDetail.before forIndex:1];
	[stmt bindInt64:statsDetail.after forIndex:2];
	[stmt bindInt32:statsDetail.id forIndex:3];
	
	if ( [stmt step] != SQLITE_DONE ) {
        [stmt release];
		NSAssert2( 0, @"sql error. %s (%s)", sql, sqlite3_errmsg(conn) );
	}
    else {
        [stmt release];
    }
}


+ (NSDictionary*) getStateDetailsForAccessDay:(time_t)accessDay
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    StatsDetail* stats = nil;
    
    sqlite3* conn = [DBConnection getDatabase];
    char* sql = "select id, userAgent,before, after, accessday, createTime, uaid, uastr from stats_detail where accessday = ?";
    Statement* stmt = [[Statement alloc] initWithDB:conn sql:sql];
    [stmt bindInt64:accessDay forIndex:1];
    
    while ( [stmt step] == SQLITE_ROW ) {
        stats = [[StatsDetail alloc] init];
        stats.id = [stmt getInt32:0];
        stats.userAgent = [stmt getString:1];
        stats.before = [stmt getInt64:2];
        stats.after = [stmt getInt64:3];
        stats.accessDay = [stmt getInt64:4];
        stats.createTime = [stmt getInt64:5];
        stats.uaId = [stmt getString:6];
        stats.uaStr = [stmt getString:7];
        [dic setObject:stats forKey:stats.userAgent];
        [stats release];
    }
    [stmt release];
    return dic;
}


+ (StatsDetail*) getLastStatsDetailBefore:(time_t)time userAgent:(NSString*)userAgent
{
    StatsDetail* stats = nil;
    
    sqlite3* conn = [DBConnection getDatabase];
    char* sql = "select id, before, after, accessday, createTime, uaid, uastr from stats_detail where useragent = ? and accessday < ? order by accessday desc limit 1";
    Statement* stmt = [[Statement alloc] initWithDB:conn sql:sql];
    [stmt bindString:userAgent forIndex:1];
    [stmt bindInt64:time forIndex:2];
    if ( [stmt step] == SQLITE_ROW ) {
        stats = [[[StatsDetail alloc] init] autorelease];
        stats.id = [stmt getInt32:0];
        stats.before = [stmt getInt64:1];
        stats.after = [stmt getInt64:2];
        stats.accessDay = [stmt getInt64:3];
        stats.createTime = [stmt getInt64:4];
        stats.uaId = [stmt getString:5];
        stats.uaStr = [stmt getString:6];
    }
    
    [stmt release];
    return stats;
}


+ (StatsDetail*) getFirstStatsDetailAfter:(time_t)time userAgent:(NSString*)userAgent
{
    StatsDetail* stats = nil;
    
    sqlite3* conn = [DBConnection getDatabase];
    char* sql = "select id, before, after, accessday, createTime, uaid, uastr from stats_detail where useragent = ? and accessday > ? order by accessday limit 1";
    Statement* stmt = [[Statement alloc] initWithDB:conn sql:sql];
    [stmt bindString:userAgent forIndex:1];
    [stmt bindInt64:time forIndex:2];
    if ( [stmt step] == SQLITE_ROW ) {
        stats = [[[StatsDetail alloc] init] autorelease];
        stats.id = [stmt getInt32:0];
        stats.userAgent = userAgent;
        stats.before = [stmt getInt64:1];
        stats.after = [stmt getInt64:2];
        stats.accessDay = [stmt getInt64:3];
        stats.createTime = [stmt getInt64:4];
        stats.uaId = [stmt getString:5];
        stats.uaStr = [stmt getString:6];
    }
    
    [stmt release];
    return stats;
}


+ (NSDictionary*) getUserAgentDicFor:(NSArray*)userAgentArr
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    if ( !userAgentArr || [userAgentArr count] == 0 ) return dic;
    
    sqlite3* conn = [DBConnection getDatabase];
    
    NSMutableString* sql = [NSMutableString stringWithString:@"select userAgent, uaid, uastr from stats_detail where userAgent in ("];
    for ( NSString* ua in userAgentArr ) {
        [sql appendFormat:@"'%@',", ua];
    }
    NSRange range;
    range.location = [sql length] - 1;
    range.length = 1;
    [sql deleteCharactersInRange:range];
    [sql appendString:@") group by userAgent, uaid, uastr"];
    
    Statement* stmt = [[Statement alloc] initWithDB:conn sql:(char*)[sql UTF8String]];
    NSString* ua;
    NSString* uaId;
    NSString* uaStr;
    
    while ( [stmt step] == SQLITE_ROW ) {
        ua = [stmt getString:0];
        uaId = [stmt getString:1];
        uaStr = [stmt getString:2];
        
        if ( uaStr ) {
            [dic setObject:[NSArray arrayWithObjects:uaId, uaStr, nil] forKey:ua];
        }
    }
    
    [stmt release];
    return dic;
}

+ (NSMutableDictionary *)getUserAgentAnduaStr
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:3];
    
    time_t now;
    time( &now );
    time_t createtime = now - 24*60*60*90; //得到用户从今天开始到90天前的时间。
    
    sqlite3 *conn = [DBConnection getDatabase];
    NSString *sql = [NSString stringWithFormat:@"select distinct useragent, uastr from stats_detail where useragent != 'iOS(系统服务、通知等)'  and uastr is not null and uastr <> ''  and createtime > %ld",createtime ];
    NSLog(@"sql is ------------ %@",sql);
    
    Statement* stmt = [[Statement alloc] initWithDB:conn sql:(char *)[sql UTF8String]];
    [stmt bindInt64:createtime forIndex:1];
    while ( [stmt step] == SQLITE_ROW ) {
        [dic setObject:[stmt getString:0] forKey:[stmt getString:1]];
    }
    NSLog(@"dic is :%@",dic);
    return dic;
}

@end
