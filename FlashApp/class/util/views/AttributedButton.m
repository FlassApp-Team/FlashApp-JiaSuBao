//
//  AttributedButton.m
//  flashapp
//
//  Created by Qi Zhao on 12-7-28.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#include <QuartzCore/QuartzCore.h>
#import "AttributedButton.h"
#import "QuartzUtils.h"

@implementation AttributedButton

@synthesize titleUnderlined;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if ( titleUnderlined ) {
        CGRect textRect = self.titleLabel.frame;
        // need to put the line at top of descenders (negative value)
        //CGFloat descender = self.titleLabel.font.descender;
        CGFloat descender = -1;
        NSLog(@"descender=%f",descender);
        //CGFloat descender = 2;
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        CGPoint startPoint = CGPointMake(textRect.origin.x, textRect.origin.y + textRect.size.height);
        CGPoint endPoint = CGPointMake(textRect.origin.x + textRect.size.width, textRect.origin.y + textRect.size.height);
        drawLine( contextRef, 1.0, self.titleLabel.textColor.CGColor, startPoint, endPoint );
    }
}

@end
