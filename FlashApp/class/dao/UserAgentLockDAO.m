//
//  UserAgentInfoDAO.m
//  flashapp
//
//  Created by Qi Zhao on 12-9-6.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import "UserAgentLockDAO.h"
#import "DBConnection.h"
#import "Statement.h"
#import "StringUtil.h"
@implementation UserAgentLockDAO

+ (UserAgentLock*) getUserAgentLock:(NSString*)userAgent
{
    sqlite3* conn = [DBConnection getDatabase];
    char* sql = "select locked, locktime, timeLength, resumetime,appname from user_agent_lock where useragent = ?";
    
    Statement* stmt = [[Statement alloc] initWithDB:conn sql:sql];
    [stmt bindString:userAgent forIndex:1];
    
    UserAgentLock* info = nil;
    if ( [stmt step] == SQLITE_ROW ) {
        info = [[[UserAgentLock alloc] init] autorelease];
        info.userAgent = userAgent;
        info.isLock = [stmt getInt32:0];
        info.lockTime = [stmt getInt64:1];
        info.timeLengh = [stmt getInt64:2];
        info.resumeTime = [stmt getInt64:3];
        info.appName=[stmt getString:4];
    }
    
    [stmt release];
    return info;
}


+ (void) updateUserAgentLock:(UserAgentLock*)lock
{
    sqlite3* conn = [DBConnection getDatabase];
   // char* sql = "insert or replace into user_agent_lock (useragent, locked, locktime, timelength, resumetime) values (?,?,?,?,?)";
    char* sql = "insert or replace into user_agent_lock (useragent, locked, locktime, timelength, resumetime,appname) values (?,?,?,?,?,?)"; //add jianfei han 2013-02-28

    Statement* stmt = [[Statement alloc] initWithDB:conn sql:sql];
    [stmt bindString:lock.userAgent forIndex:1];
    [stmt bindInt32:lock.isLock forIndex:2];
    [stmt bindInt64:(long long)lock.lockTime forIndex:3];
    [stmt bindInt64:(long long)lock.timeLengh forIndex:4];
    [stmt bindInt64:(long long)lock.resumeTime forIndex:5];
    
    [stmt bindString:lock.appName forIndex:6];

	if ( [stmt step] != SQLITE_DONE ) {
        [stmt release];
		NSAssert2( 0, @"sql error. %s (%s)", sql, sqlite3_errmsg(conn) );
	}	
    else {
        [stmt release];
    }
}


+ (void) deleteUserAgentLock:(NSString*)userAgent
{
    sqlite3* conn = [DBConnection getDatabase];
    char* sql = "delete from user_agent_lock where useragent = ?";
    Statement* stmt = [[Statement alloc] initWithDB:conn sql:sql];
    [stmt bindString:userAgent forIndex:1];
	if ( [stmt step] != SQLITE_DONE ) {
        [stmt release];
		NSAssert2( 0, @"sql error. %s (%s)", sql, sqlite3_errmsg(conn) );
	}	
    else {
        [stmt release];
    }
}


+ (NSDictionary*) getAllLockedApps
{
    sqlite3* conn = [DBConnection getDatabase];
    char* sql = "select useragent, locktime, timeLength, resumetime,appname ,locked from user_agent_lock where locked = 1 order by timeLength desc";
    
    Statement* stmt = [[Statement alloc] initWithDB:conn sql:sql];

    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    UserAgentLock* info = nil;
    while ( [stmt step] == SQLITE_ROW ) {
        info = [[[UserAgentLock alloc] init] autorelease];
        info.userAgent = [[stmt getString:0] trim];
        info.isLock = YES;
        info.lockTime = [stmt getInt64:1];
        info.timeLengh = [stmt getInt64:2];
        info.resumeTime = [stmt getInt64:3];
        NSString *strName=[stmt getString:4];//add jianfei han 2013-02-28
        //NSLog(@"GGGGGGAgent===%dTTTTTTTTTTTTTTTT",[stmt getInt32:5]);
       // NSLog(@"info aasdadasdasd%@",info.userAgent);

        info.appName=[strName trim];
        [dic setObject:info forKey:info.userAgent];
    }
    
    [stmt release];
    return dic;
}

+ (NSDictionary*) getAllUnLockedApps
{
    sqlite3* conn = [DBConnection getDatabase];
    char* sql = "select useragent, locktime, timeLength, resumetime,appname from user_agent_lock where locked = 0";
    
    Statement* stmt = [[Statement alloc] initWithDB:conn sql:sql];
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    UserAgentLock* info = nil;
    while ( [stmt step] == SQLITE_ROW ) {
        info = [[[UserAgentLock alloc] init] autorelease];
        info.userAgent = [stmt getString:0];
        info.isLock = YES;
        info.lockTime = [stmt getInt64:1];
        info.timeLengh = [stmt getInt64:2];
        info.resumeTime = [stmt getInt64:3];
        info.appName=[stmt getString:4];//add jianfei han 2013-02-28

        [dic setObject:info forKey:info.userAgent];
    }
    
    [stmt release];
    return dic;
}



+ (void) deleteAll
{
    sqlite3* conn = [DBConnection getDatabase];
    char* sql = "delete from user_agent_lock";
    Statement* stmt = [[Statement alloc] initWithDB:conn sql:sql];
	if ( [stmt step] != SQLITE_DONE ) {
        [stmt release];
		NSAssert2( 0, @"sql error. %s (%s)", sql, sqlite3_errmsg(conn) );
	}
    else {
        [stmt release];
    }
}

@end
