//
//  DBConnection.h
//  xueci
//
//  Created by koolearn on 11-4-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define DATABASE_NAME @"db-1.0.sqlite"

#define kPKBitNumberGroup 19
#define kPKBitNumberPerson 12

@interface DBConnection : NSObject {

	
}

+ (void) createEditableCopyOfDatabaseIfNeeded: (BOOL) forceCreate ;
+ (sqlite3*) getDatabase;
+ (sqlite3*) openDatabase;
+ (void) close:(sqlite3*)db;
+ (void) close;
+ (void) beginTransaction:(sqlite3*)db;
+ (void)beginTransaction;
+ (void)commitTransaction:(sqlite3*)db;
+ (void)commitTransaction;
+ (void) rollbackTransaction:(sqlite3*)db;
+ (void) rollbackTransaction;
+ (char*) getError:(sqlite3*)db;
+ (char*) getError;
+ (void) executePrepared:(char*)sql connection:(sqlite3*)db;
+ (void) executePrepared:(char*)sql;
+ (int) execute:(char *)sql connection:(sqlite3*)db errmsg:(char**)errmsg;
+ (int) execute:(char *)sql errmsg:(char**)errmsg;
+ (long long) createRandomNum:(NSInteger)bit;
+ (int) clearDB;

@end
