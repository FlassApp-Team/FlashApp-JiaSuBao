//
//  StatsDay.h
//  flashapp
//
//  Created by zhen fang on 11-12-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatsDay : NSObject{
    NSInteger id;
    long long totalBefore;
    long long totalAfter;
    time_t accessDay;
    time_t createTime;
    NSMutableArray* statsDetailArray;
    long long totalStats;
    long long monthTotalStats;
    long long monthTotalBefore;
   
}
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) long long totalBefore;
@property (nonatomic, assign) long long totalAfter;
@property (nonatomic, assign) time_t accessDay;
@property (nonatomic, assign) time_t createTime;
@property(nonatomic,retain) NSMutableArray* statsDetailArray;
@property (nonatomic, assign) long long totalStats;
@property (nonatomic, assign) long long monthTotalStats;
@property (nonatomic, assign) long long monthTotalBefore;


- (id) initWithJSON:(NSDictionary*)dic;

@end
