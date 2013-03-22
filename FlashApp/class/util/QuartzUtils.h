/*
 *  QuartzUtils.h
 *  TwitterFon
 *
 *  Created by kaz on 11/17/08.
 *  Copyright 2008 naan studio. All rights reserved.
 *
 */

#include <QuartzCore/QuartzCore.h>

#define PIE 3.1415926

void drawLine( CGContextRef context, CGFloat lineWidth, CGColorRef color, CGPoint start, CGPoint end );
void drawRoundedRect(CGContextRef context, CGRect rrect);
void drawRectangle( CGContextRef context, CGFloat lineWidth, CGColorRef lineColor, CGColorRef fillColor, CGRect rect );
void drawArc( CGContextRef context, CGFloat lineWidth, CGColorRef lineColor, CGPoint centerPointer, CGFloat radius, CGFloat startAngle, CGFloat endAngle );
