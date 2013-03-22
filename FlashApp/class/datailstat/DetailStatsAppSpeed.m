//
//  DetailStatsAppLineChart.m
//  flashapp
//
//  Created by Qi Zhao on 12-9-3.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import "DetailStatsAppSpeed.h"
#import "StatsDayDAO.h"
#import "StatsDetail.h"
#import "DateUtils.h"
#import "StringUtil.h"

NSString *const kBeforeLine1	 = @"beforeLine";
NSString *const kAfterLine1	 = @"afterLine";

@implementation DetailStatsAppSpeed

@synthesize startTime;
@synthesize endTime;
@synthesize userAgent;
@synthesize userAgentData;
@synthesize timeArray;
@synthesize plotSpace;
@synthesize spaceYY;
@synthesize spaceXX;
@synthesize linColor;
@synthesize arColor;
@synthesize PointColor;
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
    self.timeArray=nil;
    self.plotSpace=nil;
    [userAgent release];
    self.userAgentData=nil;;
    self.linColor=nil;
    self.PointColor=nil;
    self.arColor=nil;
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
	graph.plotAreaFrame.paddingBottom = -0.5;
	graph.plotAreaFrame.paddingLeft = -1.0;
    

    
	CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
	axisLineStyle.lineWidth = 1.0;
	axisLineStyle.lineColor = [CPTColor redColor];
    
    CPTMutableTextStyle* axisTextStyle = [CPTMutableTextStyle textStyle];
    axisTextStyle.color = [CPTColor blueColor];
    
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
//	NSTimeInterval oneDay = 24 * 60 * 60;
//	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
//	CPTXYAxis *x		  = axisSet.xAxis;
//    x.axisLineStyle = axisLineStyle;
//	//x.majorGridLineStyle = majorGridLineStyle;
//	x.majorIntervalLength		  = CPTDecimalFromFloat(oneDay);
//    x.majorTickLineStyle = axisLineStyle;
//	x.minorTicksPerInterval		  = 0;
//	x.labelingPolicy	 = CPTAxisLabelingPolicyAutomatic;
//    x.labelTextStyle = axisTextStyle;
////
////    
//    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
//    [dateFormatter setDateFormat:@"M/d"];
//	//dateFormatter.dateStyle = kCFDateFormatterShortStyle;
//	CPTTimeFormatter *timeFormatter = [[[CPTTimeFormatter alloc] initWithDateFormatter:dateFormatter] autorelease];
//	timeFormatter.referenceDate = [NSDate dateWithTimeIntervalSince1970:0];
//	x.labelFormatter			= timeFormatter;
//    
//	// Y axis
//	CPTXYAxis *y = axisSet.yAxis;
//	y.labelingPolicy	 = CPTAxisLabelingPolicyAutomatic;
//	//y.majorGridLineStyle = majorGridLineStyle;
//    y.majorTickLineStyle = axisLineStyle;
//	y.labelFormatter	 = labelFormatter;
//    y.axisLineStyle = axisLineStyle;
//    y.labelTextStyle = axisTextStyle;
    
    
	// Before bytes line
	CPTScatterPlot *linePlot = [[[CPTScatterPlot alloc] init] autorelease];
	linePlot.identifier = kBeforeLine1;
    
	CPTMutableLineStyle* lineStyle			   = [CPTMutableLineStyle lineStyle];
	lineStyle.lineWidth	   = 1.0;
    //const CGFloat *lineComponents = CGColorGetComponents(linColor.CGColor);

    lineStyle.lineColor = [CPTColor colorWithCGColor:linColor.CGColor];
	linePlot.dataLineStyle = lineStyle;
    
	linePlot.dataSource = self;
	[graph addPlot:linePlot];
    
	// Put an area gradient under the plot above
    
    CGColorRef color = [arColor CGColor];
    const CGFloat *components = CGColorGetComponents(color);


    
	CPTColor *areaColor		  = [CPTColor colorWithComponentRed:components[0] green:components[1] blue:components[2] alpha:components[3]];
	CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:areaColor];
	areaGradient.angle = 0.0;
	CPTFill *areaGradientFill = [CPTFill fillWithGradient:areaGradient];
	linePlot.areaFill		 = areaGradientFill;
	linePlot.areaBaseValue = CPTDecimalFromString(@"0.0");
    
	// Add plot symbols
    CGColorRef color1 = [linColor CGColor];
    const CGFloat *components1 = CGColorGetComponents(color1);
	CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
	symbolLineStyle.lineColor = [CPTColor colorWithComponentRed:components1[0] green:components1[1] blue:components1[2] alpha:components1[3]];
    
	CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
	plotSymbol.fill		 = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:components1[0] green:components1[1] blue:components1[2] alpha:components1[3]]];
	plotSymbol.lineStyle = symbolLineStyle;
	plotSymbol.size		 = CGSizeMake(3.0, 3.0);
	linePlot.plotSymbol	 = plotSymbol;
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////
//	// After bytes line
//	CPTScatterPlot *afterLinePlot = [[[CPTScatterPlot alloc] init] autorelease];
//	afterLinePlot.identifier = kAfterLine1;
//    
//	CPTMutableLineStyle* afterLineStyle			   = [CPTMutableLineStyle lineStyle];
//	afterLineStyle.lineWidth	   = 1.0;
//    afterLineStyle.lineColor = [CPTColor colorWithCGColor:[UIColor greenColor].CGColor];//line color
//	afterLinePlot.dataLineStyle = afterLineStyle;
//    
//	afterLinePlot.dataSource = self;
//	[graph addPlot:afterLinePlot];
//    
//	// Put an area gradient under the plot above
//	areaColor = [CPTColor colorWithComponentRed:0.0 green:0.0 blue:0.0 alpha:0.4];
//	areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:areaColor];
//	areaGradient.angle = 0.0;
//	areaGradientFill = [CPTFill fillWithGradient:areaGradient];
//	afterLinePlot.areaFill		 = areaGradientFill;
//	afterLinePlot.areaBaseValue = CPTDecimalFromString(@"0.0");
//    
//	// Add plot symbols
//	symbolLineStyle = [CPTMutableLineStyle lineStyle];
//	symbolLineStyle.lineColor = [CPTColor grayColor];//point color
//    
//	plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
//	plotSymbol.fill		 = [CPTFill fillWithColor:[CPTColor grayColor]];
//	plotSymbol.lineStyle = symbolLineStyle;
//	plotSymbol.size		 = CGSizeMake(3.0, 3.0);
//	afterLinePlot.plotSymbol	 = plotSymbol;
    /////////////////////////////////////////////////////////////////////////////////////////////
    
    
	// Auto scale the plot space to fit the plot data
	self.plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
	[self.plotSpace scaleToFitPlots:[NSArray arrayWithObject:linePlot]];

    self.plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(10)];
    self.plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(spaceYY)];
   // NSLog(@"spaceYY=======%f",spaceYY);
//
//	// Adjust visible ranges so plot symbols along the edges are not clipped
//	CPTMutablePlotRange *xRange = [[plotSpace.xRange mutableCopy] autorelease];
//	CPTMutablePlotRange *yRange = [[plotSpace.yRange mutableCopy] autorelease];
    
//	x.orthogonalCoordinateDecimal = yRange.location;
//	y.orthogonalCoordinateDecimal = xRange.location;
//    
//	x.visibleRange = xRange;
//	y.visibleRange = yRange;
//    
//	x.gridLinesRange = yRange;
//	y.gridLinesRange = xRange;
//    
//	[xRange expandRangeByFactor:CPTDecimalFromDouble(1.05)];
//	[yRange expandRangeByFactor:CPTDecimalFromDouble(1.05)];
//	plotSpace.xRange = xRange;
//	plotSpace.yRange = yRange;
}



#pragma mark - load data

- (void) generateData
{
    //    NSArray* data = [StatsDayDAO getUserAgentData:userAgent start:startTime end:endTime];
    //    userAgentData = [data retain];
//    if([self.timeArray count]==0)
//    {
//        self.timeArray=[[[NSMutableArray alloc]init]autorelease];
//        for(int i=0;i<20;i++)
//        {
//            NSNumber *numberX=[NSNumber numberWithInt:i];
//            [self.timeArray addObject:numberX];
//
//            
//        }
//    }
//    if([self.userAgentData count]==0)
//       {
//        
//           self.userAgentData=[[[NSMutableArray alloc]init] autorelease];
//           for(int i=0;i<20;i++)
//           {
//               NSNumber *numberY=[NSNumber numberWithInt:0];
//               [self.userAgentData addObject:numberY];
//               
//           }
//       }
  
    long long maxBytes = 0;
    for ( NSNumber *number in userAgentData ) {
        float floatValue = [number floatValue];

        maxBytes = MAX( maxBytes, floatValue );
    }
    
    NSArray* arr = [NSString bytesAndUnitString:maxBytes];
    maxUnitValue = [[arr objectAtIndex:0] floatValue];
    byteUnit = [[arr objectAtIndex:1] retain];
}


#pragma mark -
#pragma mark Plot Data Source Methods

- (NSUInteger) numberOfRecordsForPlot:(CPTPlot *)plot
{
//    if([userAgentData count]>10)
//        return 10;
    return [userAgentData count];
}


- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{

    NSNumber* number = (NSNumber*) [userAgentData objectAtIndex:index];
    //    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(10.0)];
    //    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(10.0)];
    int numberInt=[number intValue];
	switch ( fieldEnum ) {
		case CPTScatterPlotFieldX:
            ;
            //NSDate *date = [NSDate date];
            //NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:date];
            //return [NSNumber numberWithInt:comps.day];
            //NSLog(@"FFFFFFFFFFFF%@",[NSNumber numberWithFloat:[[self.timeArray objectAtIndex:index] floatValue]]);
            return [NSNumber numberWithInt:[[self.timeArray objectAtIndex:index] intValue]];
            //return [NSNumber numberWithInt:index];

        case CPTScatterPlotFieldY:
            if ( plot.identifier == kBeforeLine1 ) {
                float f =[NSString bytesNumberByUnit:numberInt unit:byteUnit];
               // NSLog(@"btyteFFFFFFFFFFFFF%f",f);
                return [NSNumber numberWithFloat:f];
            }
            else {
                float f =[NSString bytesNumberByUnit:numberInt unit:byteUnit];
                     //NSLog(@"RRRRRRRRRRRRRRRRRRRR%f",f);
                return [NSNumber numberWithFloat:f];
           

            }
    }
    
    return nil;
}


@end
