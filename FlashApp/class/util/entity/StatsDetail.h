//
//  StatsDetail.h
//  flashapp
//
//  Created by zhen fang on 11-12-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatsDetail : NSObject{
    NSInteger id;
    NSString* userAgent;
    long long before;
    long long after;
    long long accessDay;
    long long createTime;
    
    NSString* uaId;
    NSString* uaStr;

}
@property(nonatomic,assign) NSInteger id;
@property(nonatomic,retain) NSString* userAgent;
@property(nonatomic,assign) long long before;
@property(nonatomic,assign) long long after;
@property(nonatomic,assign) long long accessDay;
@property(nonatomic,assign) long long createTime;
@property(nonatomic,retain) NSString* uaId;
@property(nonatomic,retain) NSString* uaStr;

- (NSComparisonResult) compareByBefore:(StatsDetail*)st;
- (NSComparisonResult) compareByAfter:(StatsDetail*)st;
- (NSComparisonResult) compareByPercent:(StatsDetail*)st;
- (NSComparisonResult) compareByJieSheng:(StatsDetail*)st;

@end
