//
//  AppRecommendDao.m
//  FlashApp
//
//  Created by 朱广涛 on 13-5-6.
//  Copyright (c) 2013年 lidiansen. All rights reserved.
//

#import "AppRecommendDao.h"
#import "DBConnection.h"
#import "Statement.h"
#import "AppClasses.h"

@implementation AppRecommendDao

+ (BOOL)createAppRecommendTable
{
    //创建数据库表
    sqlite3 *database = [DBConnection getDatabase];
    char *error;
    NSString *createtab= @"create table if not exists APP_CLASSES(id integer primary key , icon text, name text , new integer , tim real)";
    if (sqlite3_exec(database, [createtab UTF8String], NULL, NULL, &error) == SQLITE_OK) {
        NSLog(@"create app recommend OK");
        return YES;
    }
    return NO;
}

+ (void)insertAllAppRecommend:(NSArray *)arr
{
    sqlite3 *database = [DBConnection getDatabase];
    char *sql = "insert into APP_CLASSES(id,icon,name,new,tim) values(?,?,?,?,?)";
        for ( int i = 0 ; i < [arr count]; i++) {
        Statement *stat = [[Statement alloc] initWithDB:database sql:sql];
        NSDictionary *dic = [arr objectAtIndex:i];
        [stat bindInt32:[[dic objectForKey:@"id"] integerValue] forIndex:1];
        [stat bindString:[dic objectForKey:@"icon"] forIndex:2];
        [stat bindString:[dic objectForKey:@"name"] forIndex:3];
        [stat bindInt32:[[dic objectForKey:@"new"] integerValue] forIndex:4];
        [stat bindInt64:[[dic objectForKey:@"tim"] longLongValue] forIndex:5];
//        NSLog(@"1 ------ dic is %@",dic);
        if ( [stat step] != SQLITE_DONE ) {
            [stat release];
            NSAssert2( 0, @"sql error. %s (%s)", sql, sqlite3_errmsg(database));
        }
        else {
            [stat release];
        }
    }
}

+ (void)updateAppRecommend:(AppClasses *)appClassess
{
    sqlite3 *database = [DBConnection getDatabase];
    char *sql = "update APP_CLASSES set tim = ? where name = ?";
    Statement *stat = [[Statement alloc] initWithDB:database sql:sql];
    [stat bindInt64:appClassess.appClass_tim forIndex:1];
    [stat bindString:appClassess.appClasses_name forIndex:2];
    if ( [stat step] != SQLITE_DONE ) {
        [stat release];
		NSAssert2( 0, @"sql error. %s (%s)", sql, sqlite3_errmsg(database) );
	}
    else {
        [stat release];
    }
}

+ (NSDictionary *)fondAllAppRecommend
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:3];
     
    sqlite3 *database = [DBConnection getDatabase];
    char* sql = "select * from APP_CLASSES";
    
    Statement *stat = [[Statement alloc] initWithDB:database sql:sql];
    
    while ([stat step] == SQLITE_ROW) {
        AppClasses *appClasses = [[AppClasses alloc] init];
        appClasses.appClasses_id = [stat getInt32:0];
        appClasses.appClasses_icon = [stat getString:1];
        appClasses.appClasses_name = [stat getString:2];
        appClasses.appClass_new = [stat getInt32:3];
        appClasses.appClass_tim = [stat getInt64:4];
        [dic setObject:appClasses forKey:appClasses.appClasses_name];
        [appClasses release];
    }
    [stat release];
    return dic;
}

@end
