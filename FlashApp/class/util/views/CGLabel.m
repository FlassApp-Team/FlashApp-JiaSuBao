//
//  CGLabel.m
//  FlashApp
//
//  Created by lidiansen on 12-12-21.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import "CGLabel.h"
#include <Quartzcore/Quartzcore.h>
#import<CoreText/CoreText.h>
@implementation CGLabel

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
    [super drawRect:rect];
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOffset = CGSizeMake(0.0, 0);
    self.layer.masksToBounds = NO;
    
    self.layer.shadowRadius = 1.0f;
    self.layer.shadowOpacity =0.95;
    
    
    
    
}
@end
