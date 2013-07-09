//
//  CustomBUtton.m
//  FlashApp
//
//  Created by lidiansen on 13-1-21.
//  Copyright (c) 2013年 lidiansen. All rights reserved.
//

#import "CustomBUtton.h"

@implementation CustomBUtton
@synthesize controller;
-(void)dealloc
{
    self.controller=nil;
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) buttonPress {
    UIView *view=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width  , self.frame.size.height)] autorelease];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.3];
    view.tag=101;
    [controller.view addSubview:view];
    controller.view.transform = CGAffineTransformMakeScale(0.9, 0.9);
}

// Scale down on button release
-(void)dragFinish
{
    upflag=YES;
    controller.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
    UIView *view=(UIView*)[controller.view viewWithTag:101];
    if(view)
        [view removeFromSuperview];
}
- (void) buttonRelease {
    if(upflag)
    {
        upflag=NO;
        controller.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
        UIView *view=(UIView*)[controller.view viewWithTag:101];
        [view removeFromSuperview];
        return;
    }
    else
    {
        [controller performSelector:@selector(nextContorller) withObject:nil afterDelay:0.1];
        
    }
}
-(void)scrollviewEnd
{
    [self dragFinish];
    upflag=NO;
}
- (void)drawRect:(CGRect)rect
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollviewEnd) name:@"scrollEnd" object: nil];

    [self addTarget:self action:@selector(dragFinish) forControlEvents:UIControlEventTouchDragOutside];
    [self addTarget:self action:@selector(buttonPress) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(buttonRelease) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
}

@end
