//
//  ProfileTipView.m
//  flashapp
//
//  Created by 李 电森 on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ProfileTipView.h"
#import "QuartzUtils.h"

#define TEXT_FONT [UIFont systemFontOfSize:14]
#define BUTTON_COLOR [UIColor colorWithRed:81.0/255.0 green:236.0/255.0 blue:92.0/255.0 alpha:1.0f]

@implementation ProfileTipView

@synthesize label;
@synthesize button;
@synthesize type;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //UIImageView* bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        //bgView.image = [[UIImage imageNamed:@"bg_profile.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:0];
        //[self addSubview:bgView];
        //[bgView release];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = TEXT_FONT;
        [self addSubview:label];
        [label release];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectZero;
        button.titleLabel.font = TEXT_FONT;
        button.backgroundColor = [UIColor clearColor];
        [button setTitleColor:BUTTON_COLOR forState:UIControlStateNormal];
        [self addSubview:button];
        
    }
    return self;
}


- (void) setMessage:(NSString*)msg button:(NSString*)title
{
    if ( title ) {
        CGSize size1 = [msg sizeWithFont:TEXT_FONT];
        CGSize size2 = [title sizeWithFont:TEXT_FONT];
        CGFloat width = size1.width + size2.width;
        label.frame = CGRectMake( (self.frame.size.width - width)/2, (self.frame.size.height - size1.height)/2, size1.width, size1.height);
        label.text = msg;
        
        button.frame = CGRectMake( label.frame.origin.x + label.frame.size.width, label.frame.origin.y, size2.width, size2.height);
        [button setTitle:title forState:UIControlStateNormal];
    }
    else {
        label.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        label.textAlignment = UITextAlignmentCenter;
        label.text = msg;
        
        button.frame = CGRectZero;
    }
    
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIImage* image = [[UIImage imageNamed:@"bg_profile.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:0];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat startX = button.frame.origin.x;
    CGFloat endX = startX + button.frame.size.width;
    CGFloat y = button.frame.origin.y + button.frame.size.height;
    drawLine( context, 1, [BUTTON_COLOR CGColor], CGPointMake(startX, y), CGPointMake(endX, y));
}

@end
