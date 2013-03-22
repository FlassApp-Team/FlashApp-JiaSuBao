//
//  DateUtils.m
//  Guazi
//
//  Created by koolearn on 11-7-31.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <sys/types.h>
#import <sys/timeb.h>
#import "DateUtils.h"


@implementation DateUtils

+ (NSString*)diffNowString:(time_t)sinceTime
{
    // Calculate distance time string
    //
    time_t now;
    time(&now);
    
    int distance = (int)difftime(now, sinceTime);
    if (distance < 0) distance = 0;
    
    NSString* timestamp; 
    if (distance < 60) {
        timestamp = [NSString stringWithFormat:@"%d%@", distance, @"秒钟前"];
    }
    else if (distance < 60 * 60) {  
        distance = distance / 60;
        timestamp = [NSString stringWithFormat:@"%d%@", distance, @"分钟前"];
    }  
    else if (distance < 60 * 60 * 24) {
        distance = distance / 60 / 60;
        timestamp = [NSString stringWithFormat:@"%d%@", distance, @"小时前"];
    }
    else if (distance < 60 * 60 * 24 * 7) {
        distance = distance / 60 / 60 / 24;
        timestamp = [NSString stringWithFormat:@"%d%@", distance, @"天前"];
    }
    else if (distance < 60 * 60 * 24 * 7 * 4) {
        distance = distance / 60 / 60 / 24 / 7;
        timestamp = [NSString stringWithFormat:@"%d%@", distance, @"周前"];
    }
    else {
        static NSDateFormatter *dateFormatter = nil;
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            //[dateFormatter setDateStyle:NSDateFormatterShortStyle];
            //[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        }
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:sinceTime];        
        timestamp = [dateFormatter stringFromDate:date];
    }
    return timestamp;
}


+ (NSString*) stringWithDateFormat:(time_t)date format:(NSString*)format
{
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:date];        
    NSString* timestamp = [dateFormatter stringFromDate:d];
    [format release];
    return timestamp;
}


+ (time_t) timeWithDateFormat:(NSString*)date format:(NSString*)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate* d = [dateFormatter dateFromString:date];
    time_t time = [d timeIntervalSince1970];
    [dateFormatter release];
    return time;
}


+ (time_t)getFirstDayOfMonth:(time_t)date 
{
    NSString* dateString = [DateUtils stringWithDateFormat:date format:@"yyyyMM"];
    int year = [[dateString substringToIndex:4] intValue];
    int month = [[dateString substringFromIndex:4] intValue];
    
    dateString = [NSString stringWithFormat:@"%d-%02d-01 00:00:00", year, month];
    time_t day = [DateUtils timeWithDateFormat:dateString format:@"yyyy-MM-dd HH:mm:ss"];
    return day;
}


+ (time_t) getLastDayOfMonth:(time_t)date
{
    NSString* dateString = [DateUtils stringWithDateFormat:date format:@"yyyyMM"];
    int year = [[dateString substringToIndex:4] intValue];
    int month = [[dateString substringFromIndex:4] intValue];
    month++;
    if ( month >= 13 ) {
        month = 1;
        year++;
    }
    
    dateString = [NSString stringWithFormat:@"%d-%02d-01 00:00:00", year, month];
    time_t day = [DateUtils timeWithDateFormat:dateString format:@"yyyy-MM-dd HH:mm:ss"];
    day --;
    return day;
}


+ (long long)millisecondTime
{
    struct timeb timebuffer;
    ftime(&timebuffer);
    long long l = timebuffer.time;
    return l * 1000 + timebuffer.millitm;
}


+ (time_t) getLastTimeOfToday
{
    time_t now;
    time( &now );
    return [self getLastTimeOfDay:now];
}


+ (time_t) getFirstTimeOfDay:(time_t)time
{
    NSString* dateString = [DateUtils stringWithDateFormat:time format:@"yyyy-MM-dd"];
    dateString = [NSString stringWithFormat:@"%@ 00:00:00", dateString];
    time_t t = [DateUtils timeWithDateFormat:dateString format:@"yyyy-MM-dd HH:mm:ss"];
    return t;
}


+ (time_t) getLastTimeOfDay:(time_t)time
{
    NSString* dateString = [DateUtils stringWithDateFormat:time format:@"yyyy-MM-dd"];
    dateString = [NSString stringWithFormat:@"%@ 23:59:59", dateString];
    time_t t = [DateUtils timeWithDateFormat:dateString format:@"yyyy-MM-dd HH:mm:ss"];
    return t;
}


@end
