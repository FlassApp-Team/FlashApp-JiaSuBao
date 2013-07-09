//
//  TCStatsAPPSpeed.h
//  FlashApp
//
//  Created by lidiansen on 13-1-30.
//  Copyright (c) 2013年 lidiansen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlotItem.h"

@interface TCStatsAPPSpeed : PlotItem<CPTPlotDataSource>
{
    NSString* byteUnit;
    float maxUnitValue;
    
    time_t startTime;
    time_t endTime;
    NSString* userAgent;
}
@property(nonatomic,retain)NSArray*dateArray;;

@property(nonatomic,retain)UIColor*linColor;
@property(nonatomic,retain)UIColor*PointColor;
@property(nonatomic,retain)UIColor*arColor;
@property (nonatomic, assign) time_t startTime;
@property (nonatomic, assign) time_t endTime;
@property (nonatomic, retain) NSString* userAgent;
@property (nonatomic, retain) NSArray* userAgentData;

@end
