//
//  UIDevice-software.m
//  flashapp
//
//  Created by Qi Zhao on 12-8-26.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import "UIDevice-software.h"
#import "AppInfo.h"

@implementation UIDevice (software)

- (NSDictionary*) getInstallation
{
    static NSString *const cacheFileName = @"com.apple.mobile.installation.plist";
    NSString *relativeCachePath = [[@"Library" stringByAppendingPathComponent: @"Caches"] stringByAppendingPathComponent: cacheFileName];
    NSDictionary *cacheDict = nil;
    NSString *path = nil;
    // Loop through all possible paths the cache could be in
    for (short i = 0; 1; i++)
    {
        
        switch (i) {
            case 0: // Jailbroken apps will find the cache here; their home directory is /var/mobile
                path = [NSHomeDirectory() stringByAppendingPathComponent: relativeCachePath];
                break;
            case 1: // App Store apps and Simulator will find the cache here; home (/var/mobile/) is 2 directories above sandbox folder
                path = [[NSHomeDirectory() stringByAppendingPathComponent: @"../.."] stringByAppendingPathComponent: relativeCachePath];
                break;
            case 2: // If the app is anywhere else, default to hardcoded /var/mobile/
                path = [@"/var/mobile" stringByAppendingPathComponent: relativeCachePath];
                break;
            default: // Cache not found (loop not broken)
                return NO;
                break; 
        }
        
        BOOL isDir = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath: path isDirectory: &isDir] && !isDir) // Ensure that file exists
            cacheDict = [NSDictionary dictionaryWithContentsOfFile: path];
        
        if ( cacheDict ) break;
    }
    
    return cacheDict;
}


- (NSMutableDictionary*) getInstalledApps
{
    NSDictionary* installationDic = [self getInstallation];
    NSDictionary * tempDict = [installationDic objectForKey:@"User"];
    NSMutableDictionary* apps = [NSMutableDictionary dictionary];

    for (id key in tempDict) {
        NSDictionary *appDict = [tempDict objectForKey:key];
        
        NSString* bundleId = [appDict objectForKey:@"CFBundleIdentifier"];
        NSString* name = [appDict objectForKey:@"CFBundleName"];
        NSString *displayName = [appDict objectForKey:@"CFBundleDisplayName"];
        NSString *path = [appDict objectForKey:@"Path"];
        
        if (displayName == nil) {
            displayName = name;
        }
        
        if ( displayName == nil ) {
            displayName = [[path lastPathComponent] stringByDeletingPathExtension];
        }
        

        NSString *version = [appDict objectForKey:@"CFBundleShortVersionString"];
        if (version == nil) {
            version = [appDict objectForKey:@"CFBundleVersion"];
        }
        
        NSString *icon = [appDict objectForKey:@"CFBundleIconFile"];
        
        if (icon == nil) {
            icon = [path stringByAppendingPathComponent:@"icon.png"];
        } 
        else {
            icon = [path stringByAppendingPathComponent:icon];
        }
        
        AppInfo* app = [[AppInfo alloc] init];
        app.bundleID = bundleId;
        app.name = name;
        app.displayName = displayName;
        app.version = version;
        app.path = path;
        app.icon = icon;
        [apps setObject:app forKey:app.bundleID];
        [app release];
    }

    return apps;
}

@end
