//
//  LoadingView.m
//  flashget
//
//  Created by 李 电森 on 11-11-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LoadingView.h"


@implementation LoadingView

@synthesize activityView;
@synthesize message;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        self.layer.cornerRadius=10.0;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 2.0f;
        self.backgroundColor = [UIColor colorWithRed:0.3f green:0.3f blue:0.3f alpha:0.9f];
        
        // Initialization code
        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityView.frame = CGRectMake( (frame.size.width - 40)/2, (frame.size.height-40)/2 - 10, 40, 40);
        [activityView startAnimating];
        [self addSubview:activityView];
        
        messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, activityView.frame.origin.y + 50, frame.size.width, 20)];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.font = [UIFont systemFontOfSize:14];
        messageLabel.text = @"正在加载中...";
        messageLabel.textAlignment = UITextAlignmentCenter;
        messageLabel.textColor = [UIColor whiteColor];
        [self addSubview:messageLabel];
        [messageLabel release];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void)dealloc
{
    [activityView release];
    [super dealloc];
}


- (void) startActivity
{
    self.hidden = NO;
    [activityView startAnimating];
}


- (void) stopActivity
{
    [activityView stopAnimating];
    self.hidden = YES;
}

- (void) setMessage:(NSString *)m
{
    messageLabel.text = m;
}

@end
