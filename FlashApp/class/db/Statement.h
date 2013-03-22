//
//  Statement.h
//  client1
//
//  Created by koolearn on 11-4-3.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface Statement : NSObject {

	sqlite3_stmt* stmt;
	
}

@property (nonatomic, assign) sqlite3_stmt* stmt;

- (id) initWithDB:(sqlite3 *)db sql:(char *)sql;

- (void) bindString:(NSString *)value forIndex:(int)index;
- (void) bindInt32:(int)value forIndex:(int)index;
- (void) bindInt64:(long long)value forIndex:(int)index;
- (void) bindData:(NSData *)data forIndex:(int)index;

- (int) step;

- (NSString*) getString:(int)index;
- (int) getInt32:(int)index;
- (long long) getInt64:(int)index;
- (NSData*) getData:(int)index;

@end
