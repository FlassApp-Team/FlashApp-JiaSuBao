//
//  UIDevice-software.h
//  flashapp
//
//  Created by Qi Zhao on 12-8-26.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIDevice (software)
    - (NSDictionary*) getInstallation;
    - (NSMutableDictionary*) getInstalledApps;
@end
