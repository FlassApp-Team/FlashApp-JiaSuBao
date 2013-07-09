//
//  DetailStatsAppLineChart.m
//  flashapp
//
//  Created by Qi Zhao on 12-9-3.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import "TCStatsAPPSpeed.h"
#import "StatsDayDAO.h"
#import "StatsDay.h"
#import "DateUtils.h"
#import "StringUtil.h"

NSString *const kBeforeLine22	 = @"beforeLine";
NSString *const kAfterLine22	 = @"afterLine";

@implementation TCStatsAPPSpeed

@synthesize startTime;
@synthesize endTime;
@synthesize userAgent;
@synthesize userAgentData;
@synthesize linColor;
@synthesize PointColor;
@synthesize arColor;
@synthesize dateArray;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void) dealloc
{
    self.linColor=nil;
    self.PointColor=nil;
    self.arColor=nil;
    [userAgent release];
    [userAgentData release];
    [byteUnit release];
    [super dealloc];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */


-(void)renderInLayer:(CPTGraphHostingView *)layerHostingView withTheme:(CPTTheme *)theme
{
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
	CGRect bounds = layerHostingView.bounds;
#else
	CGRect bounds = NSRectToCGRect(layerHostingView.bounds);
#endif
    
	CPTGraph *graph = [[[CPTXYGraph alloc] initWithFrame:bounds] autorelease];
    graph.backgroundColor = [UIColor clearColor].CGColor;
    
	[self addGraph:graph toHostingView:layerHostingView];
    if ( theme ) {
        [self applyTheme:theme toGraph:graph withDefault:theme];
    }
    //[graph setBackgroundColor:[UIColor whiteColor].CGColor];
    
	[self setTitleDefaultsForGraph:graph withBounds:bounds];
	[self setPaddingDefaultsForGraph:graph withBounds:bounds];
    
    graph.paddingLeft = 0 ;
    graph.paddingTop = 0 ;
    graph.paddingRight = 0 ;
    graph.paddingBottom = 0 ;
    
	graph.plotAreaFrame.paddingTop	  = 5.0;
	graph.plotAreaFrame.paddingRight  = 5.0;
	graph.plotAreaFrame.paddingBottom = 20.0;
	graph.plotAreaFrame.paddingLeft	  = 23.0;
    
	// Grid line styles
    //	CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    //	majorGridLineStyle.lineWidth = 0.75;
    //	majorGridLineStyle.lineColor = [[CPTColor colorWithGenericGray:0.2] colorWithAlphaComponent:0.75];
    //
    //	CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
    //	minorGridLineStyle.lineWidth = 0.25;
    //	minorGridLineStyle.lineColor = [[CPTColor blackColor] colorWithAlphaComponent:0.5];
    
	CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
	axisLineStyle.lineWidth = 1.0;
	axisLineStyle.lineColor = [CPTColor grayColor];
    
    CPTMutableTextStyle* axisTextStyle = [CPTMutableTextStyle textStyle];
    axisTextStyle.color = [CPTColor grayColor];
    
	NSNumberFormatter *labelFormatter = [[[NSNumberFormatter alloc] init] autorelease];
	labelFormatter.maximumFractionDigits = 1;
    if ( maxUnitValue < 10 ) {
        [labelFormatter setPositiveFormat:@"0.0"];
    }
    else {
        [labelFormatter setPositiveFormat:@"0"];
    }
    
    
	// Axes
	// X axis
	NSTimeInterval oneDay = 24 * 60 * 60;
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
	CPTXYAxis *x		  = axisSet.xAxis;
    x.axisLineStyle = axisLineStyle;
	//x.majorGridLineStyle = majorGridLineStyle;
	x.majorIntervalLength		  = CPTDecimalFromFloat(oneDay);
    x.majorTickLineStyle = axisLineStyle;
	x.minorTicksPerInterval		  = 0;
	x.labelingPolicy	 = CPTAxisLabelingPolicyAutomatic;
    x.labelTextStyle = axisTextStyle;
    
    

    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"d"];
	//dateFormatter.dateStyle = kCFDateFormatterShortStyle;
	CPTTimeFormatter *timeFormatter = [[[CPTTimeFormatter alloc] initWithDateFormatter:dateFormatter] autorelease];
	timeFormatter.referenceDate = [NSDate dateWithTimeIntervalSince1970:0];
	x.labelFormatter			= timeFormatter;
    
	// Y axis
	CPTXYAxis *y = axisSet.yAxis;
	y.labelingPolicy	 = CPTAxisLabelingPolicyAutomatic;
	//y.majorGridLineStyle = majorGridLineStyle;
    y.majorTickLineStyle = axisLineStyle;
	y.labelFormatter	 = labelFormatter;
    y.axisLineStyle = axisLineStyle;
    y.labelTextStyle = axisTextStyle;
    
    
	// Before bytes line
	CPTScatterPlot *linePlot = [[[CPTScatterPlot alloc] init] autorelease];
	linePlot.identifier = kBeforeLine22;
    
	CPTMutableLineStyle* lineStyle			   = [CPTMutableLineStyle lineStyle];
	lineStyle.lineWidth	   = 1.0;
    lineStyle.lineColor = [CPTColor colorWithCGColor:[UIColor greenColor].CGColor];
	linePlot.dataLineStyle = lineStyle;
    
	linePlot.dataSource = self;
	[graph addPlot:linePlot];
    
	// Put an area gradient under the plot above
	CPTColor *areaColor		  = [CPTColor colorWithComponentRed:0.0 green:1.0 blue:0.0 alpha:0.5];
	CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:areaColor];
	areaGradient.angle = -90.0;
	CPTFill *areaGradientFill = [CPTFill fillWithGradient:areaGradient];
	linePlot.areaFill		 = areaGradientFill;
	linePlot.areaBaseValue = CPTDecimalFromString(@"0.0");
    
	// Add plot symbols
	CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
	symbolLineStyle.lineColor = [CPTColor greenColor];
    
	CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
	plotSymbol.fill		 = [CPTFill fillWithColor:[CPTColor greenColor]];
	plotSymbol.lineStyle = symbolLineStyle;
	plotSymbol.size		 = CGSizeMake(3.0, 3.0);
	linePlot.plotSymbol	 = plotSymbol;
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////
	// After bytes line
	CPTScatterPlot *afterLinePlot = [[[CPTScatterPlot alloc] init] autorelease];
	afterLinePlot.identifier = kAfterLine22;
    
	CPTMutableLineStyle* afterLineStyle			   = [CPTMutableLineStyle lineStyle];
	afterLineStyle.lineWidth	   = 1.0;
    
    afterLineStyle.lineColor = [CPTColor colorWithCGColor:self.linColor.CGColor];//line color
	afterLinePlot.dataLineStyle = afterLineStyle;
    
	afterLinePlot.dataSource = self;
	[graph addPlot:afterLinePlot];
    
	// Put an area gradient under the plot above
    CGColorRef color = [arColor CGColor];
    const CGFloat *componentss = CGColorGetComponents(color);
	areaColor = [CPTColor colorWithComponentRed:componentss[0] green:componentss[1] blue:componentss[2] alpha:componentss[3]];
	areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:areaColor];
	areaGradient.angle = -90.0;
	areaGradientFill = [CPTFill fillWithGradient:areaGradient];
	afterLinePlot.areaFill		 = areaGradientFill;
	afterLinePlot.areaBaseValue = CPTDecimalFromString(@"0.0");
    
	// Add plot symbols
	symbolLineStyle = [CPTMutableLineStyle lineStyle];
    CGColorRef color1 = [linColor CGColor];
    const CGFloat *components = CGColorGetComponents(color1);
	symbolLineStyle.lineColor = [CPTColor colorWithComponentRed:components[0] green:components[1] blue:components[2] alpha:components[3]];//point color
    
	plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
	plotSymbol.fill		 = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:components[0] green:components[1] blue:components[2] alpha:components[3]]];
	plotSymbol.lineStyle = symbolLineStyle;
	plotSymbol.size		 = CGSizeMake(3.0, 3.0);
	afterLinePlot.plotSymbol	 = plotSymbol;
    /////////////////////////////////////////////////////////////////////////////////////////////
    
    
	// Auto scale the plot space to fit the plot data
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
	[plotSpace scaleToFitPlots:[NSArray arrayWithObject:linePlot]];
    
	// Adjust visible ranges so plot symbols along the edges are not clipped
	CPTMutablePlotRange *xRange = [[plotSpace.xRange mutableCopy] autorelease];
	CPTMutablePlotRange *yRange = [[plotSpace.yRange mutableCopy] autorelease];
    
	x.orthogonalCoordinateDecimal = yRange.location;
	y.orthogonalCoordinateDecimal = xRange.location;
    
	x.visibleRange = xRange;
	y.visibleRange = yRange;
    
	x.gridLinesRange = yRange;
	y.gridLinesRange = xRange;
    
	[xRange expandRangeByFactor:CPTDecimalFromDouble(1.05)];
	[yRange expandRangeByFactor:CPTDecimalFromDouble(1.05)];
	plotSpace.xRange = xRange;
	plotSpace.yRange = yRange;
}



#pragma mark - load data

- (void) generateData
{
    //    NSArray* data = [StatsDayDAO getUserAgentData:userAgent start:startTime end:endTime];
    //    userAgentData = [data retain];
    long long maxBytes = 0;
    for ( StatsDay* stats in userAgentData ) {
        maxBytes = MAX( maxBytes, stats.totalBefore );
    }
    self.dateArray=[[NSArray arrayWithObjects:@"0",@"5",@"10",@"15",@"20",@"25",@"30" ,nil] autorelease];
    NSArray* arr = [NSString bytesAndUnitString:maxBytes];
    maxUnitValue = [[arr objectAtIndex:0] floatValue];
    byteUnit = [[arr objectAtIndex:1] retain];
}


#pragma mark -
#pragma mark Plot Data Source Methods
-(NSString *)dateInFormat:(time_t)dateTime format:(NSString*) stringFormat //time_t to string
{

    char buffer[80];
    
    const char *format = [stringFormat UTF8String];
    
    struct tm * timeinfo;
    
    timeinfo = localtime(&dateTime);
    
    strftime(buffer, 80, format, timeinfo);
    
    return [NSString  stringWithCString:buffer encoding:NSUTF8StringEncoding];
    
}

-(int)judgeDayOfMonth:(int )index
{
    StatsDay* dayData=(StatsDay*) [userAgentData objectAtIndex:index];
     NSString  *str = @"%d";
    int time=[[self dateInFormat:dayData.accessDay format:str] intValue];
    NSLog(@"str=======%d",time);
    int day=time/5;
    switch (day) {
        case 0:
            return 0;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 2;
            break;
        case 3:
            return 3;
            break;
        case 4:
            return 4;
            break;
        case 5:
            return 5;
            break;
        case 6:
            return 6;
            break;
        default:
            return 7;
            break;
    }
    
}

- (NSUInteger) numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [self.userAgentData count];
}


- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    StatsDay* dayData=(StatsDay*) [userAgentData objectAtIndex:index];
//    if([userAgentData count]>index)
//    {
//         dayData=(StatsDay*) [userAgentData objectAtIndex:index];
//        int aa= [self judgeDayOfMonth:index];
//    }
    NSString  *dayStr = @"%d";
    int time=[[self dateInFormat:dayData.accessDay format:dayStr] intValue];
	switch ( fieldEnum ) {
		case CPTScatterPlotFieldX:
            return [NSNumber numberWithLongLong:dayData.accessDay];
        case CPTScatterPlotFieldY:
            if ( plot.identifier == kBeforeLine22 ) {
                float f = [NSString bytesNumberByUnit:dayData.totalAfter unit:byteUnit];
                
                return [NSNumber numberWithFloat:f];
            }
            else {
                float f = [NSString bytesNumberByUnit:dayData.totalAfter unit:byteUnit];
                return [NSNumber numberWithFloat:f];
            }
    }
    
    return nil;
}


@end
