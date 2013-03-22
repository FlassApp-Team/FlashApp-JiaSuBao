//
//  DetailStatsAppSpeed.h
//  FlashApp
//
//  Created by lidiansen on 13-1-26.
//  Copyright (c) 2013年 lidiansen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PlotItem.h"
@interface DetailStatsAppSpeed :  PlotItem<CPTPlotDataSource>
{
    NSMutableArray* userAgentData;
    NSString* byteUnit;
    float maxUnitValue;
    
    time_t startTime;
    time_t endTime;
    NSString* userAgent;
    
}
@property(nonatomic,retain)UIColor*linColor;
@property(nonatomic,retain)UIColor*PointColor;
@property(nonatomic,retain)UIColor*arColor;

@property(nonatomic,assign)float spaceYY;
@property(nonatomic,assign)float spaceXX;

@property(nonatomic,retain)CPTXYPlotSpace *plotSpace;//设置区间变化量 
@property(nonatomic,retain)NSMutableArray*timeArray;
@property (nonatomic, assign) time_t startTime;
@property (nonatomic, assign) time_t endTime;
@property (nonatomic, retain) NSString* userAgent;
@property (nonatomic, retain) NSMutableArray* userAgentData;

@end
