//
//  ProfileTipView.h
//  flashapp
//
//  Created by 李 电森 on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileTipView : UIView
{
    UILabel* label;
    UIButton* button;
    
    int type;
}

@property (nonatomic, assign) UILabel* label;
@property (nonatomic, assign) UIButton* button;
@property (nonatomic, assign) int type;


- (void) setMessage:(NSString*)msg button:(NSString*)title;

@end
