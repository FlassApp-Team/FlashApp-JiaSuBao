//
//  TCUtils.m
//  flashapp
//
//  Created by 李 电森 on 12-4-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TCUtils.h"
#import "AppDelegate.h"
#import "UserSettings.h"
#import "DateUtils.h"
#import "StringUtil.h"
#import "IFData.h"
#import "IFDataService.h"
#import "DBConnection.h"
#import "Statement.h"
#import "NotificationUtils.h"

typedef enum {
    NET_FLOW_TYPE_READ,
    NET_FLOW_TYPE_SET
} NET_FLOW_TYPE;
@interface TCUtils()
+ (time_t) tcDayOfMonth:(int)year month:(int)month;
@end

@implementation TCUtils
+ (void) insertStatsNetFlow:(time_t)lasttime receive:(long)receiveBytes send:(long)sendBytes delta:(long)delta type:(NET_FLOW_TYPE)type desc:(NSString*)desc
{
    char* sql = "insert into stats_netflow (send_bytes, receive_bytes, total, delta, last_change_time, create_time, tc_day, tc_used, type, desc) values (?,?,?,?,?,?,?,?,?,?)";
    sqlite3* db = [DBConnection getDatabase];
    Statement* stmt = [[Statement alloc] initWithDB:db sql:sql];
    [stmt bindInt64:sendBytes forIndex:1];
    [stmt bindInt64:receiveBytes forIndex:2];
    [stmt bindInt64:(sendBytes + receiveBytes) forIndex:3];
    [stmt bindInt64:delta forIndex:4];
    [stmt bindInt64:lasttime forIndex:5];
    
    time_t now;
    time( &now );
    [stmt bindInt64:now forIndex:6];
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    long used = [user getTcUsed];
    int day = [user getTcDay];
    [stmt bindInt32:day forIndex:7];
    [stmt bindInt64:used forIndex:8];
    
    [stmt bindInt32:type forIndex:9];
    [stmt bindString:desc forIndex:10];
    
    if ( [stmt step] != SQLITE_DONE ) {
        
    }
    else {
        
    }
    
    [stmt release];
}



+ (void) readIfData:(long)proxyBytes
{
    IFData* ifData = [IFDataService readCellFlowData];
    if ( !ifData ) return;
    
    //add by fangzhen flow percent notification
    [NotificationUtils dataStatsNotification];
    
    if ( ifData.receiveBytes < 0 || ifData.sendBytes < 0 ) return;
    if ( ifData.lastchangeTime <= 0 || (ifData.receiveBytes==0 && ifData.sendBytes==0) ) return;
    
    long totalBytes = 0;
    long delta = 0;
    NSString* desc;
    
    if ( ifData ) {
        totalBytes = ifData.receiveBytes + ifData.sendBytes;
    }
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    long used = [user getTcUsed];
    
    
    time_t now;
    time( &now );
    
    time_t peroid[2];
    [TCUtils getPeriodOfTcMonth:peroid time:now];
    
    if ( user.ifLastTime > 0 ) {
        //非第一次读取数据
        if ( user.ifLastTime < peroid[0] ) {
            //上次读取不在本结算周期
            NSLog(@"============== 不在本次结算周期内");
            desc = @"新结算周期开始";
            if ( totalBytes > user.ifLastBytesNum ) {
                long ll = (totalBytes - user.ifLastBytesNum) * ((double) (now - peroid[0]) / (now - user.ifLastTime));
                delta = ll;
                used = ll;
            }
            else {
                long ll = totalBytes * ((double) (now - peroid[0]) / (now - user.ifLastTime));
                ll = ll * 2;
                delta = ll;
                used = ll;
            }
        }
        else if ( user.ifLastTime >= peroid[0] && user.ifLastTime <= peroid[1] ) {
            //上次读取在本结算周期
            NSLog(@"============== 在 本次结算周期内");
            desc = @"老结算周期内";
            if ( totalBytes < user.ifLastBytesNum ) {
                //重新启动过
                used += totalBytes;
                delta = totalBytes;
                /*
                if ( used < totalBytes ) {
                    used = totalBytes;
                    delta = totalBytes - used;
                }
                else {
                    delta = 0;
                }*/
            }
            else {
                used += (totalBytes - user.ifLastBytesNum);
                delta = totalBytes - user.ifLastBytesNum;
            } 
        }
        user.ifLastTime = now;
        user.ifLastBytesNum = totalBytes;
        user.ctUsed = [NSString stringWithFormat:@"%ld", used];
        NSLog(@"============== 第二次读取, time=%ld, bytes=%ld, used=%@", user.ifLastTime, user.ifLastBytesNum, user.ctUsed);
        [UserSettings saveUserSettings:user];
        
        [self insertStatsNetFlow:ifData.lastchangeTime receive:ifData.receiveBytes send:ifData.sendBytes delta:delta type:NET_FLOW_TYPE_READ desc:desc];
    }
    else {
        //第一次读取数据，已用流量设置为压缩流量
        if ( proxyBytes >= 0 ) {
            user.ifLastTime = now;
            user.ifLastBytesNum = totalBytes;
            user.ctUsed = [NSString stringWithFormat:@"%ld", proxyBytes];
            NSLog(@"============== 第一次读取, time=%ld, bytes=%ld, used=%@", user.ifLastTime, user.ifLastBytesNum, user.ctUsed);
            [UserSettings saveUserSettings:user];
            delta = proxyBytes;
            desc = @"第一次读取数据";
            
            [self insertStatsNetFlow:ifData.lastchangeTime receive:ifData.receiveBytes send:ifData.sendBytes delta:delta type:NET_FLOW_TYPE_READ desc:desc];
        }
   }

}


+ (void) saveTCUsed:(long long)bytes total:(float)total day:(int)day
{
    UserSettings* user = [AppDelegate getAppDelegate].user;
    if ( total > 0 ) {
        user.ctTotal = [NSString stringWithFloatTrim:total decimal:2];
    }
    
    if ( day > 0 ) {
        user.ctDay = [NSString stringWithFormat:@"%d", day];
    }
    
    if ( bytes >= 0 ) {
        IFData* ifData = [IFDataService readCellFlowData];
        long totalBytes = ifData.sendBytes + ifData.receiveBytes;
        
        user.ctUsed = [NSString stringWithFormat:@"%lld", bytes];
        
        time_t now;
        time( &now );
        user.ifLastTime = now;
        user.ifLastBytesNum = totalBytes;

#ifdef NETMETER_DEBUG
        [self insertStatsNetFlow:user.ifLastTime receive:ifData.receiveBytes send:ifData.sendBytes delta:0 type:NET_FLOW_TYPE_SET desc:@"用户设置套餐流量"];
#endif
    }
    
    [UserSettings saveUserSettings:user];
    
}


+ (void) getPeriodOfTcMonth:(time_t*)period time:(time_t)now
{
    NSString* str = [DateUtils stringWithDateFormat:now format:@"yyyy-MM-dd-HH-mm-ss"];
    NSArray* arr = [str componentsSeparatedByString:@"-"];
    NSString* s = [arr objectAtIndex:0];
    int year = [s intValue];
    
    s = [arr objectAtIndex:1];
    int month = [s intValue];
    
    s = [arr objectAtIndex:2];
    int day = [s intValue];
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    int tcDay = [user getTcDay];
    
    time_t first;
    time_t last;
    if ( tcDay > day ) {
        //当前日期在结算日之前
        last = [self tcDayOfMonth:year month:month];
        last--;
        
        month --;
        if ( month == 0 ) {
            year --;
            month = 12;
        }
        first = [self tcDayOfMonth:year month:month];
    }
    else {
        //当前日期在结算日之后，开始时间为结算日
        first = [self tcDayOfMonth:year month:month];
        
        month ++;
        if ( month == 13 ) {
            month = 1;
            year++;
        }
        
        last = [self tcDayOfMonth:year month:month];
        last--;

    }
    
    period[0] = first;
    period[1] = last;
}


+ (time_t) tcDayOfMonth:(int)year month:(int)month
{
    UserSettings* user = [AppDelegate getAppDelegate].user;
    int tcDay = [user getTcDay];
    
    NSString* date = [NSString stringWithFormat:@"%d-%d-%d", year, month, tcDay];
    time_t time = [DateUtils timeWithDateFormat:date format:@"yyyy-MM-dd"];
    if ( time == 0 ) {
        //结算日在本月是非法日期，则取下月的第一天
        month ++;
        if ( month == 13 ) {
            year++;
            month = 1;
        }
        date = [NSString stringWithFormat:@"%d-%d-1", year, month];
        time = [DateUtils timeWithDateFormat:date format:@"yyyy-MM-dd"];
    }
    return time;
}


+ (NSString*) monthDescForStartTime:(time_t)startTime endTime:(time_t)endTime
{
//    NSCalendar* calendar = [NSCalendar currentCalendar];
    
//    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:startTime];
//    NSDateComponents *compsStart = [calendar components:unitFlags fromDate:date];
    
    date = [NSDate dateWithTimeIntervalSince1970:endTime];
//    NSDateComponents* compsEnd = [calendar components:unitFlags fromDate:date];
    
//    NSString* format1 = NSLocalizedString(@"datastats.DatastatsScrollViewController.dateFormat1", nil); //"YY/M/d"
//    NSString* format2 = NSLocalizedString(@"datastats.DatastatsScrollViewController.dateFormat2", nil); //"YYYY年M月d日"
//    NSString* format3 = NSLocalizedString(@"datastats.DatastatsScrollViewController.dateFormat3", nil); //"M月d日"
    NSString* format4 = NSLocalizedString(@"datastats.DatastatsScrollViewController.dateFormat4", nil); //"YYYY年M月"
    NSString* desc = nil;
    
//    if ( compsStart.year != compsEnd.year ) {
//        desc = [NSString stringWithFormat:@"%@ - %@", [DateUtils stringWithDateFormat:startTime format:format1],[DateUtils stringWithDateFormat:endTime format:format1]];
//    }
//    else if ( compsStart.month != compsEnd.month ) {
//        desc = [NSString stringWithFormat:@"%@ - %@", [DateUtils stringWithDateFormat:startTime format:format2],[DateUtils stringWithDateFormat:endTime format:format3]];
//    }
//    else {
        desc = [NSString stringWithFormat:@"%@", [DateUtils stringWithDateFormat:startTime format:format4]];
//    }
    
    return desc;
}


@end
