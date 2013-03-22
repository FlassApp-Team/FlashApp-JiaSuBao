//
//  DBConnection.m
//  client1
//
//  Created by koolearn on 11-3-31.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DBConnection.h"
#import "Statement.h"
#import "AppDelegate.h"

static sqlite3* theDatabase = nil;


@interface DBConnection (private)
+ (void) createDatabase:(NSString *)dbPath;
+ (NSString*) getDBPath;
@end


@implementation DBConnection

#pragma mark - create database file
+ (void) createEditableCopyOfDatabaseIfNeeded: (BOOL) forceCreate 
{
	NSString* dbPath = [DBConnection getDBPath];
	
	NSError* error;
	NSFileManager* fileManager = [NSFileManager defaultManager];
	
    NSLog(@"forceCreate=%d", forceCreate);
	if ( forceCreate ) {
		[fileManager removeItemAtPath:dbPath error:&error];
	}
	
	if ( ![fileManager fileExistsAtPath:dbPath] ) {
        NSLog(@"%@ not exists!", dbPath);
		//create database
		[DBConnection createDatabase : dbPath];
	}
    else {
        NSLog(@"%@ exists!", dbPath);
    }
}


+ (void) createDatabase : (NSString*) dbPath
{
	NSString* defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DATABASE_NAME];
	NSError* error;
	BOOL success = [[NSFileManager defaultManager] copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
	NSAssert1( success, @"Fail to create database, error: %@", [error localizedDescription] );
}


+ (NSString*) getDBPath 
{
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentPath = [paths objectAtIndex:0];
	NSString* dbPath = [documentPath stringByAppendingPathComponent:DATABASE_NAME];
    NSLog(@"dbpath=====%@",dbPath);
	return dbPath;
}


#pragma mark - global database instance operations

+ (sqlite3*) getDatabase
{
	if ( theDatabase != nil ) return theDatabase;
    
    @synchronized([DBConnection class]) {
        if ( theDatabase != nil ) return theDatabase;
        theDatabase = [self openDatabase];
    }
	
	return theDatabase;
}


+ (sqlite3*) openDatabase
{
    sqlite3* db = nil;
	NSString* dbPath = [DBConnection getDBPath];
	int result = sqlite3_open( [dbPath UTF8String], &db );
    //int result = sqlite3_open_v2( [dbPath UTF8String], &theDatabase, SQLITE_OPEN_READWRITE|SQLITE_OPEN_NOMUTEX, NULL);
	if ( result != SQLITE_OK ) {
		sqlite3_close( db );
		NSAssert( 0, @"open database fail" );
	}
	
	return db;
}


+ (int) clearDB
{
    char* sql = "begin transaction;"
                "delete from stats_day;"
                "delete from stats_detail;"
                "delete from stats_month;"
                "delete from stats_month_detail;"
                "commit transaction;"
                "VACUUM";
    char* error;
    int result = [DBConnection execute:sql errmsg:&error];
    return result;
}


+ (void) close:(sqlite3*)db
{
    if ( db != nil ) {
        sqlite3_close(db);
    }
}


+ (void) close
{
    [self close:theDatabase];
}


+ (void) beginTransaction:(sqlite3*)db
{
    char *errmsg;     
    sqlite3_exec(db, "BEGIN immediate", NULL, NULL, &errmsg);     
}

+ (void)beginTransaction
{
    [self beginTransaction:theDatabase];
}


+ (void)commitTransaction:(sqlite3*)db
{
    char *errmsg;     
    sqlite3_exec(db, "COMMIT", NULL, NULL, &errmsg);     
}


+ (void)commitTransaction
{
    [self commitTransaction:theDatabase];
}


+ (void) rollbackTransaction:(sqlite3*)db
{
    char *errmsg;     
    sqlite3_exec(db, "ROLLBACK", NULL, NULL, &errmsg);     
}


+ (void) rollbackTransaction
{
    [self rollbackTransaction:theDatabase];
}


+ (char*) getError:(sqlite3*)db
{
    return (char*) sqlite3_errmsg(db);
}


+ (char*) getError
{
    return [self getError:theDatabase];
}


+ (void) executePrepared:(char*)sql connection:(sqlite3*)db
{
	Statement* stmt = [[Statement alloc] initWithDB:db sql:sql];
	
	if ( [stmt step] != SQLITE_DONE ) {
        NSLog( @"Fail to prepare statement: %s (%s)", sql, sqlite3_errmsg(db) );
		[stmt release];
		NSAssert2( 0, @"Fail to prepare statement: %s (%s)", sql, sqlite3_errmsg(db) );
		return;
	}
	
	[stmt release];
}


+ (void) executePrepared:(char*)sql
{
	sqlite3* db = [DBConnection getDatabase];
    [self executePrepared:sql connection:db];
}


+ (int) execute:(char *)sql connection:(sqlite3*)db errmsg:(char**)errmsg
{
    NSObject* lock = [AppDelegate getAppDelegate].dbWriteLock;
    @synchronized( lock ) {
        return sqlite3_exec( db, sql, NULL, NULL, errmsg);
    }
}


+ (int) execute:(char *)sql errmsg:(char**)errmsg
{
    sqlite3* db = [DBConnection getDatabase];
    return [self execute:sql connection:db errmsg:errmsg];
}


#pragma mark - other methods

+ (long long) createRandomNum:(NSInteger)bit
{
    NSMutableString* s = [NSMutableString string];
    for ( int i=0; i<bit; i++ ) {
        int randNum = arc4random() % 10;
        [s appendString:[NSString stringWithFormat:@"%d", randNum]];
    }
    
    return [s longLongValue];
}




@end
