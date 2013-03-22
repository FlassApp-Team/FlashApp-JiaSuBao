//
//  StatsDay.m
//  flashapp
//
//  Created by zhen fang on 11-12-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "StatsDay.h"
#import "StatsDetail.h"
#import "DateUtils.h"

@implementation StatsDay

@synthesize id;
@synthesize accessDay;
@synthesize totalBefore;
@synthesize totalAfter;
@synthesize createTime;
@synthesize statsDetailArray;
@synthesize totalStats;
@synthesize monthTotalStats;
@synthesize monthTotalBefore;


- (id) initWithJSON:(NSDictionary*)dic
{
    self = [super init];
    
    if ( self ) {
        id obj = [dic objectForKey:@"accesstime"];
        if ( obj && obj != [NSNull null] ) {
            NSString* s = [NSString stringWithFormat:@"%@ 00:00:00", obj];
            self.accessDay = [DateUtils timeWithDateFormat:s format:@"yyyy-MM-dd HH:mm:ss"];
        }

        time_t now;
        time( &now );
        self.createTime = now;
        
        self.totalBefore = 0;
        self.totalAfter = 0;
        
        obj = [dic objectForKey:@"totlestats"];
        if ( obj && obj != [NSNull null] ) {
            NSDictionary* totalstatsDic = (NSDictionary*)obj;
            
            obj = [totalstatsDic objectForKey:@"total_before"];
            if ( obj && obj != [NSNull null] ) {
                self.totalBefore = [obj longLongValue];
            }
            
            obj = [totalstatsDic objectForKey:@"total_after"];
            if ( obj && obj != [NSNull null] ) {
                self.totalAfter = [obj longLongValue];
            }
            
            obj = [totalstatsDic objectForKey:@"stats"];
            if ( obj && obj != [NSNull null] ) {
                NSDictionary* statsDic = (NSDictionary*) obj;
                NSArray* statsKeyArray = [statsDic allKeys];
                NSMutableArray* statsDetailList = [NSMutableArray array];
                
                for(NSString* key in statsKeyArray){
                    NSDictionary* userAgentDic = [statsDic objectForKey:key];
                    
                    StatsDetail* detail = [[StatsDetail alloc]init];
                    detail.userAgent = key;
                    long long before = [[userAgentDic objectForKey:@"before"] longLongValue];
                    long long after =  [[userAgentDic objectForKey:@"after"] longLongValue];
                    detail.before = before;
                    detail.after = after;
                    
                    detail.uaId = [userAgentDic objectForKey:@"id"];
                    detail.uaStr = [userAgentDic objectForKey:@"ua"];
                    
                    detail.accessDay = self.accessDay;
                    detail.createTime = self.createTime;
                    [statsDetailList addObject:detail];
                    [detail release];
                }
                self.statsDetailArray = statsDetailList;
            }
        }
    }
    
    return self;
}



-(void)dealloc{
    [statsDetailArray release];
    [super dealloc];
}
@end
