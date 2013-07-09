//
//  boundPhoneiewController.h
//  FlashApp
//
//  Created by lidiansen on 12-12-26.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMTextFieldNumberPad.h"
@interface BoundPhoneiewController : UIViewController<UITextFieldDelegate >
{
    CGRect rect;
}
@property(nonatomic,retain)IBOutlet UIButton *cancleBtn;
@property(nonatomic,retain)IBOutlet UIButton *sureBtn;
@property(nonatomic,retain)IBOutlet UIImageView *bgImageView;
@property(nonatomic,retain)IBOutlet UIImageView *bottomImageView;
@property(nonatomic,retain)IBOutlet AMTextFieldNumberPad*changeDoneField;
@property(nonatomic,retain)IBOutlet UIView *bgView;
-(IBAction)canclebtnPress:(id)sender;
-(IBAction)textFiledDoneEditing:(id)sender;
@end
