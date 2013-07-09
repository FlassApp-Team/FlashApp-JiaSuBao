//
//  DetailStatsAppLineChart.h
//  flashapp
//
//  Created by Qi Zhao on 12-9-3.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlotItem.h"

@interface DetailStatsAppLineChart : PlotItem<CPTPlotDataSource>
{
    NSArray* userAgentData;
    NSString* byteUnit;
    float maxUnitValue;
    
    time_t startTime;
    time_t endTime;
    NSString* userAgent;
}
@property(nonatomic,retain)UIColor*linColor;
@property(nonatomic,retain)UIColor*PointColor;
@property(nonatomic,retain)UIColor*arColor;
@property (nonatomic, assign) time_t startTime;
@property (nonatomic, assign) time_t endTime;
@property (nonatomic, retain) NSString* userAgent;
@property (nonatomic, retain) NSArray* userAgentData;

@end
