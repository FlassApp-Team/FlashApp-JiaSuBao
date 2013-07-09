//
//  AppButton.m
//  FlashApp
//
//  Created by 七 叶 on 13-1-30.
//  Copyright (c) 2013年 lidiansen. All rights reserved.
//

#import "AppButton.h"

@implementation AppButton

@synthesize linkUrl;
@synthesize appDescibe;
@synthesize appIcon;
@synthesize appName;
@synthesize appSize;
@synthesize appStar;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)dealloc{
    self.linkUrl=nil;
    self. appDescibe=nil;
    self.appIcon=nil;
    self. appName=nil;
    self. appSize=nil;
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

@end
