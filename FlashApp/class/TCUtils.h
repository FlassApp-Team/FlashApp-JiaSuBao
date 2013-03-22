//
//  TCUtils.h
//  flashapp
//
//  Created by 李 电森 on 12-4-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCUtils : NSObject

+ (void) getPeriodOfTcMonth:(time_t*)period time:(time_t)now;
+ (void) readIfData:(long)proxyBytes;
+ (void) saveTCUsed:(long long)bytes total:(float)total day:(int)day;
+ (NSString*) monthDescForStartTime:(time_t)startTime endTime:(time_t)endTime;

@end
