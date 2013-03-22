//
//  HelpItemView.m
//  flashapp
//
//  Created by Qi Zhao on 12-7-15.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import "HelpItemView.h"

@implementation HelpItemView


@synthesize icon;
@synthesize message;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:iconView];
        
        messageLabel = [[CGLabel alloc] initWithFrame:CGRectZero];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:messageLabel];
        
        indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
        [self addSubview:indicatorView];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void) dealloc
{
    [message release];
    [iconView release];
    [messageLabel release];
    [indicatorView release];
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


- (void) layoutSubviews
{
    [super layoutSubviews];
    iconView.frame = CGRectMake( 7, (self.frame.size.height - 22)/2, 22, 22);
    messageLabel.frame = CGRectMake( 33, 0, self.frame.size.width - 65, self.frame.size.height);
    indicatorView.frame = CGRectMake( 7, (self.frame.size.height - 22)/2, 22, 22);
}


- (void) setIcon:(HelpCellIcon)iconType
{
    icon = iconType;
    if ( iconType == HELP_CELL_ICON_WAIT ) {
        iconView.hidden = NO;
        indicatorView.hidden = YES;
        [indicatorView stopAnimating];
       // iconView.image = [UIImage imageNamed:@"signal-load.png"];
    }
    else if ( iconType == HELP_CELL_ICON_DOING ) {
        iconView.hidden = YES;
        indicatorView.hidden = NO;
        [indicatorView startAnimating];
    }
    else if ( iconType == HELP_CELL_ICON_SLOW ) {
        iconView.hidden = NO;
        indicatorView.hidden = YES;
        [indicatorView stopAnimating];
        iconView.image = [UIImage imageNamed:@"icon_!.png"];
    }
    else if ( iconType == HELP_CELL_ICON_OK ) {
        iconView.hidden = NO;
        indicatorView.hidden = YES;
        [indicatorView stopAnimating];
        iconView.image = [UIImage imageNamed:@"icon_ok.png"];
    }
    else if ( iconType == HELP_CELL_ICON_WRONG ) {
        iconView.hidden = NO;
        indicatorView.hidden = YES;
        [indicatorView stopAnimating];
        iconView.image = [UIImage imageNamed:@"icon_!.png"];
    }
    
    [self setNeedsDisplay];
}


- (void) setMessage:(NSString *)msg
{
    [message release];
    message = [msg retain];
    messageLabel.text = msg;
}


@end
