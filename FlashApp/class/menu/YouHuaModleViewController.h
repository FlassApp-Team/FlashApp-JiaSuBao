//
//  YouHuaModleViewController.h
//  FlashApp
//
//  Created by lidiansen on 12-12-26.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBUtton.h"
#import "CGLabel.h"
@interface YouHuaModleViewController : UIViewController
@property(nonatomic,retain)IBOutlet CustomBUtton *traOpBtn;
@property(nonatomic,retain)IBOutlet CGLabel*messageLabel;
@property(nonatomic,assign)long long jieshengCountStr;
@property(nonatomic,retain)IBOutlet CGLabel *titleLabel;
@property(nonatomic,retain)IBOutlet UIImageView *bigIconImageView;
@property(nonatomic,retain)IBOutlet UIImageView*smallIconImageView;
-(void)showMessage;
@end
