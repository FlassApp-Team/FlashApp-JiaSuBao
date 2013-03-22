//
//  LoadingView.h
//  flashget
//
//  Created by 李 电森 on 11-11-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoadingView : UIView {
    
    UIActivityIndicatorView* activityView;
    UILabel* messageLabel;
}

@property (nonatomic, retain) UIActivityIndicatorView* activityView;
@property (nonatomic, assign) NSString* message;


- (void) startActivity;
- (void) stopActivity;

@end
