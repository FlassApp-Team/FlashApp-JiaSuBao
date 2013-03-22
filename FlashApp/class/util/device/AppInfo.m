//
//  AppInfo.m
//  flashapp
//
//  Created by Qi Zhao on 12-8-26.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import "AppInfo.h"
@interface AppInfo()
- (NSString*) escapeCharForJson:(NSString*)str;

@end
@implementation AppInfo

@synthesize name;
@synthesize version;
@synthesize path;
@synthesize icon;
@synthesize bundleID;
@synthesize displayName;


- (BOOL) isSame:(AppInfo*)other
{
    if ( !other ) return NO;
    if ( [bundleID compare:other.bundleID] != NSOrderedSame ) return NO;
    if ( [version compare:other.version] != NSOrderedSame ) return NO;
    if ( [displayName compare:other.displayName] != NSOrderedSame ) return NO;
    return YES;
}


- (NSString*) briefJsonString
{
    return [NSString stringWithFormat:@"id:'%@',name:'%@',ver:'%@'", 
            [self escapeCharForJson:bundleID], [self escapeCharForJson:displayName ], 
            [self escapeCharForJson:version] ];
}


- (NSString*) escapeCharForJson:(NSString*)str
{
    str = [str stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
    str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    str = [str stringByReplacingOccurrencesOfString:@"{" withString:@"\\{"];
    str = [str stringByReplacingOccurrencesOfString:@"}" withString:@"\\}"];
    str = [str stringByReplacingOccurrencesOfString:@"[" withString:@"\\["];
    str = [str stringByReplacingOccurrencesOfString:@"]" withString:@"\\]"];
    return str;
}


- (void) dealloc
{
    [name release];
    [version release];
    [path release];
    [icon release];
    [bundleID release];
    [displayName release];
    [super dealloc];
}

@end
