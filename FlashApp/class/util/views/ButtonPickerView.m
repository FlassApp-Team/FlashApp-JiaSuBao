//
//  ButtonPickerView.m
//  flashapp
//
//  Created by 李 电森 on 12-4-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ButtonPickerView.h"

@implementation ButtonPickerView

@synthesize picker;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
        toolbar.barStyle = UIBarStyleBlackOpaque;
        toolbar.tintColor=[UIColor grayColor];
        UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(close)];
        UIBarButtonItem* space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
                                                               target:self action:nil];
        toolbar.items = [NSArray arrayWithObjects:space, item, nil];
        [self addSubview:toolbar];
        [item release];
        [space release];
        
        picker = [[UIPickerView alloc] initWithFrame:CGRectZero];
        picker.showsSelectionIndicator = YES;
        [self addSubview:picker];
    }
    return self;
}


- (void) dealloc
{
    [toolbar release];
    [picker release];
    [super dealloc];
}


- (void) layoutSubviews
{
    [super layoutSubviews];
    toolbar.frame = CGRectMake(0, 0, self.frame.size.width, 44);
    picker.frame = CGRectMake(0, 44, self.frame.size.width, self.frame.size.height - 44);
}


- (void) close
{
    self.hidden = YES;
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
