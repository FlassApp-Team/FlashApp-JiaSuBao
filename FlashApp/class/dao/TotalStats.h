//
//  TotalStats.h
//  flashapp
//
//  Created by zhen fang on 11-12-15.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TotalStats : NSObject{
    NSString* userAgent;
    long long totalstats;
    long long totalbefore;
    long long totalafter;
    NSString* uaId;
    NSString* uaStr;
    double divstats;
}
@property(nonatomic,retain) NSString* userAgent;
@property(nonatomic,retain) NSString* uaId;
@property(nonatomic,retain) NSString* uaStr;
@property(nonatomic,assign) long long totalstats;
@property(nonatomic,assign) long long totalbefore;
@property(nonatomic,assign) long long totalafter;
@property(nonatomic,assign) double divstats;

@end
