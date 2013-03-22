//
//  BackGroundButton.m
//  FlashApp
//
//  Created by lidiansen on 12-12-28.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import "BackGroundButton.h"

@implementation BackGroundButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
}
- (void)drawRect:(CGRect)rect
{
    UIImage* img1=[UIImage imageNamed:@"opaque_black.png"];
    img1=[img1 stretchableImageWithLeftCapWidth:img1.size.width/2  topCapHeight:img1.size.height/2];
    [self setBackgroundImage:img1 forState:UIControlStateNormal];
}

@end
