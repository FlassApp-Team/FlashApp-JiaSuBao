//
//  Statement.m
//  client1
//
//  Created by koolearn on 11-4-3.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Statement.h"
#import "AppDelegate.h"

@implementation Statement

@synthesize stmt;

- (id) initWithDB : (sqlite3*) db sql : (char*) sql
{
    self=[super init];
	if ( self ) {
		if ( sqlite3_prepare_v2(db, sql, -1, &stmt, nil)!=SQLITE_OK ) {
			NSAssert2( 0, @"Fail to prepare statement: %s (%s)", sql, sqlite3_errmsg(db) );
		}
	}
	return self;
}


- (void) bindString : (NSString*) value forIndex : (int) index
{
	sqlite3_bind_text( stmt, index, [value UTF8String], -1, SQLITE_TRANSIENT );
}


- (void) bindInt32 : (int) value forIndex: (int) index
{
	sqlite3_bind_int( stmt, index, value );
}


- (void) bindInt64 : (long long) value forIndex : (int) index
{
	sqlite3_bind_int64( stmt, index, value );
}


- (void) bindData : (NSData*) data forIndex : (int) index
{
	sqlite3_bind_blob( stmt, index, data.bytes, data.length, SQLITE_TRANSIENT );
}


- (int) step
{
    NSObject* lock = [AppDelegate getAppDelegate].dbWriteLock;
    @synchronized(lock) {
        int result = sqlite3_step(stmt);
        if ( result != SQLITE_OK && result != SQLITE_ROW && result != SQLITE_DONE ){
            NSLog(@"Statement.step, result=%d", result);
        }
        return result;
    }
}


- (NSString*) getString : (int) index
{
	char* value = (char*) sqlite3_column_text( stmt, index );
	if (value == NULL ) return @"";
	else return [NSString stringWithUTF8String:value];
}


- (int) getInt32 : (int) index
{
	int value = sqlite3_column_int( stmt, index );
	return value;
}


- (long long) getInt64: (int) index
{
	long long value = sqlite3_column_int64( stmt, index );
	return value;
}


- (NSData*) getData : (int) index
{
	const void* value = sqlite3_column_blob( stmt, index );
	int len = sqlite3_column_bytes( stmt, index );
	return [NSData dataWithBytes:value length:len];
}


- (void) dealloc
{
	sqlite3_finalize( stmt );
	[super dealloc];
}

@end
