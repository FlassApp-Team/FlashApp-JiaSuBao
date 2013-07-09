//
//  HelpItemView.h
//  flashapp
//
//  Created by Qi Zhao on 12-7-15.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGLabel.h"
typedef enum {
    HELP_CELL_ICON_WAIT,
    HELP_CELL_ICON_DOING,
    HELP_CELL_ICON_SLOW,
    HELP_CELL_ICON_OK,
    HELP_CELL_ICON_WRONG
}
HelpCellIcon;


@interface HelpItemView : UIView
{
    NSString* message;
    HelpCellIcon icon;
    
    UIImageView* iconView;
    CGLabel* messageLabel;
    
    UIActivityIndicatorView* indicatorView;
}


@property (nonatomic, retain) NSString* message;
@property (nonatomic, assign) HelpCellIcon icon;


@end
