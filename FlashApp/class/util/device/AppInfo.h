//
//  AppInfo.h
//  flashapp
//
//  Created by Qi Zhao on 12-8-26.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppInfo : NSObject
{
    NSString* name;
    NSString* displayName;
    NSString* version;
    NSString* path;
    NSString* icon;
    NSString* bundleID;
}

@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* displayName;
@property (nonatomic, retain) NSString* version;
@property (nonatomic, retain) NSString* path;
@property (nonatomic, retain) NSString* icon;
@property (nonatomic, retain) NSString* bundleID;

- (BOOL) isSame:(AppInfo*)other;
- (NSString*) briefJsonString;

@end
