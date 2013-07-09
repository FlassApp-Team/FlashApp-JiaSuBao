#import "PlotItem.h"

@interface ControlChart : PlotItem<CPTPlotDataSource>
{
	NSArray *plotData;
    NSArray* plotData2;
	double meanValue;
	double standardError;
}

@end
