//
//  ButtonPickerView.h
//  flashapp
//
//  Created by 李 电森 on 12-4-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonPickerView : UIView
{
    //UIImageView* titleBgImageView;
    //UIButton* okButton;
    UIPickerView* picker;
    UIToolbar* toolbar;
}

@property (nonatomic, retain) UIPickerView* picker;

@end
