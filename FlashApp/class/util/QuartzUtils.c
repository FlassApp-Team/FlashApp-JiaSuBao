/*
 *  QuartzUtils.c
 *  TwitterFon
 *
 *  Created by kaz on 11/17/08.
 *  Copyright 2008 naan studio. All rights reserved.
 *
 */

#include "QuartzUtils.h"


void drawLine( CGContextRef context, CGFloat lineWidth, CGColorRef color, CGPoint start, CGPoint end )
{
	CGContextSetLineWidth( context, lineWidth );
    CGContextSetAllowsAntialiasing( context, true );
    
    const CGFloat* components = CGColorGetComponents(color);
    CGFloat red = components[0];
    CGFloat green = components[1];
    CGFloat blue = components[2];
    CGFloat alpha = components[3];
    CGContextSetRGBStrokeColor( context, red, green, blue, alpha);
    CGContextSetStrokeColorWithColor( context, color );
    CGContextBeginPath(context );	
	CGContextMoveToPoint( context, start.x, start.y);
    CGContextAddLineToPoint( context, end.x, end.y);
    CGContextStrokePath( context );
}


void drawRectangle( CGContextRef context, CGFloat lineWidth, CGColorRef lineColor, CGColorRef fillColor, CGRect rect )
{
    CGContextSetLineWidth( context, lineWidth );
    CGContextSetStrokeColorWithColor( context, lineColor );
    CGContextSetFillColorWithColor( context, fillColor );
    CGContextAddRect( context, rect );
    CGContextDrawPath( context, kCGPathFillStroke );
}


void drawArc( CGContextRef context, CGFloat lineWidth, CGColorRef lineColor, CGPoint centerPointer, CGFloat radius, CGFloat startAngle, CGFloat endAngle )
{
    CGContextSetLineWidth( context, lineWidth );
    CGContextSetStrokeColorWithColor( context, lineColor );
    CGContextSetFillColorWithColor( context, lineColor );
    
    CGFloat angle = startAngle;
    CGFloat x = centerPointer.x + cosf(angle) * radius;
    CGFloat y = centerPointer.y + sinf(angle) * radius;

    //CGContextMoveToPoint(context, centerPointer.x - radius, centerPointer.y );
    CGContextMoveToPoint(context, x, y );

    CGContextAddArc(context, centerPointer.x, centerPointer.y, radius, startAngle,  endAngle, 0);
    CGContextStrokePath(context);
}


void drawRoundedRect(CGContextRef context, CGRect rrect)
{
    // Drawing with a white stroke color
    CGContextSetRGBStrokeColor(context, 0.3, 0.3, 0.3, 1.0);
    CGContextSetRGBFillColor(context, 0.3, 0.3, 0.3, 1.0);
    
    // Add Rect to the current path, then stroke it
    //            CGContextAddRect(context, CGRectMake(10.0, 190.0, 290.0, 73.0));
    
    
    CGContextSetLineWidth(context, 1);
    CGFloat radius = 10.0;
    
    CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
    
    // Next, we will go around the rectangle in the order given by the figure below.
    //       minx    midx    maxx
    // miny    2       3       4
    // midy   1 9              5
    // maxy    8       7       6
    // Which gives us a coincident start and end point, which is incidental to this technique, but still doesn't
    // form a closed path, so we still need to close the path to connect the ends correctly.
    // Thus we start by moving to point 1, then adding arcs through each pair of points that follows.
    // You could use a similar tecgnique to create any shape with rounded corners.
    
    // Start at 1
    CGContextMoveToPoint(context, minx, midy);
    // Add an arc through 2 to 3
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    // Add an arc through 4 to 5
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    // Add an arc through 6 to 7
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    // Add an arc through 8 to 9
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    // Close the path
    CGContextClosePath(context);
    // Fill & stroke the path
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 0.0);
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    
    CGContextMoveToPoint(context, minx, midy);
    // Add an arc through 2 to 3
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    // Add an arc through 4 to 5
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    // Add an arc through 6 to 7
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    // Add an arc through 8 to 9
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    // Close the path
    CGContextClosePath(context);
    // Fill & stroke the path
    CGContextDrawPath(context, kCGPathFillStroke);
}
