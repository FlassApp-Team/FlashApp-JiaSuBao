//
//  IFDataService.m
//  flashapp
//
//  Created by 李 电森 on 12-3-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#include <ifaddrs.h>
#include <sys/socket.h>
#include <net/if.h>
#import <CoreTelephony/CTCarrier.h>
#import "AppDelegate.h"
#import "UserSettings.h"
#import "IFDataService.h"
#import "DateUtils.h"
#import "TCUtils.h"
#import "DBConnection.h"
#import "Statement.h"

@implementation IFDataService


+ (IFData*) readCellFlowData
{
    NSDictionary* dic = [IFDataService readInterfacesNetFlow];
    IFData* totalData = [[[IFData alloc] init] autorelease];
    totalData.receiveBytes = 0;
    totalData.sendBytes = 0;
    
    time_t now;
    time( &now );
    totalData.lastchangeTime = now;
    
    if ( !dic || [dic count] == 0 ) return totalData;
    
    NSArray* keys = [dic allKeys];
    for ( NSString* name in keys ) {
        if ( [name hasPrefix:@"pdp_ip"]) {
            IFData*  data = [dic objectForKey:name];
            if ( data ) {
                totalData.receiveBytes += data.receiveBytes;
                totalData.sendBytes += data.sendBytes;
            }
            NSLog(@"name=%@, receiveBytes=%ld, sendBytes=%ld, totalReceiveBytes=%ld, totalsendBytes=%ld", name, data.receiveBytes, data.sendBytes, totalData.receiveBytes, totalData.sendBytes);
        }
    }

    return totalData;
}


+ (IFData*) readWIFIFlowData
{
    NSDictionary* dic = [IFDataService readInterfacesNetFlow];
    if ( [dic count] == 0 ) return nil;
    
    for ( IFData* data in [dic allValues] ) {
        NSString* name = data.ifName;
        NSRange range = [name rangeOfString:@"en0"];
        if ( range.location == NSNotFound ) continue;
        return data;
    }
    return nil;
}



+ (NSDictionary*) readInterfacesNetFlow
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    
    struct ifaddrs *ifa_list = 0, *ifa;
    if (getifaddrs(&ifa_list) == -1) {
        return dic;
    }
    
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next) {
        if (AF_LINK != ifa->ifa_addr->sa_family)
            continue;
        
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
            continue;
        
        if (ifa->ifa_data == 0)
            continue;
        
        char* s = ifa->ifa_name;
        NSString* name = [NSString stringWithFormat:@"%s", s];
        
        /* Not a loopback device. */
        //if ( [[name substringToIndex:2] compare:@"lo"] == NSOrderedSame ) continue;
        
        struct if_data *if_data = (struct if_data *)ifa->ifa_data;
        
        IFData* data = [dic objectForKey:name];
        if ( !data ) {
            data = [[[IFData alloc] init] autorelease];
            [dic setObject:data forKey:name];
        }
        
        data.receiveBytes += if_data->ifi_ibytes;
        data.sendBytes += if_data->ifi_obytes;
        data.ifName = name;
        
        time_t time = if_data->ifi_lastchange.tv_sec;
        if ( time > data.lastchangeTime ) data.lastchangeTime = time;
        
#ifdef NETMETER_DEBUG
        [self insertIFData:data];
#endif
    }
    
    freeifaddrs(ifa_list);
    return dic;
}


#ifdef NETMETER_DEBUG

+ (void) insertIFData:(IFData*)ifData
{
    char* sql = "insert into stats_ifdata (if_name, send_bytes, receive_bytes, total_bytes, last_change_time, create_time) values (?,?,?,?,?,?)";
    
    sqlite3* db = [DBConnection getDatabase];
    Statement* stmt = [[Statement alloc] initWithDB:db sql:sql];
    [stmt bindString:ifData.ifName forIndex:1];
    [stmt bindInt64:ifData.sendBytes forIndex:2];
    [stmt bindInt64:ifData.receiveBytes forIndex:3];
    [stmt bindInt64:(ifData.sendBytes + ifData.receiveBytes) forIndex:4];
    [stmt bindInt64:ifData.lastchangeTime forIndex:5];
    
    time_t now;
    time( &now );
    [stmt bindInt64:now forIndex:6];
    
    [stmt step];
    [stmt release];
}

#endif



@end
