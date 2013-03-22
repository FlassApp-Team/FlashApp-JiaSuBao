//
//  DateUtils.h
//  Guazi
//
//  Created by koolearn on 11-7-31.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DateUtils : NSObject {
    
}

+ (NSString*)diffNowString:(time_t)sinceTime;
+ (NSString*) stringWithDateFormat:(time_t)date format:(NSString*)format;
+ (time_t) timeWithDateFormat:(NSString*)date format:(NSString*)format;

+ (time_t)getFirstDayOfMonth:(time_t)date ;
+ (time_t) getLastDayOfMonth:(time_t)date;
+ (time_t) getFirstTimeOfDay:(time_t)time;
+ (time_t) getLastTimeOfDay:(time_t)time;
+ (time_t) getLastTimeOfToday;

+ (long long)millisecondTime;

@end
