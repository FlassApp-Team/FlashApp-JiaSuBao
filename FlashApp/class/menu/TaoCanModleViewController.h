//
//  TaoCanModleViewController.h
//  FlashApp
//
//  Created by lidiansen on 12-12-26.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBUtton.h"
#import "CGLabel.h"
@interface TaoCanModleViewController : UIViewController
@property(nonatomic,retain)IBOutlet CustomBUtton *taocanBtn;
@property(nonatomic,retain)IBOutlet CGLabel* tcCountLabel;
@property(nonatomic,retain)IBOutlet CGLabel* tcUnitLabel;

@property(nonatomic,retain)IBOutlet CGLabel* tcUseLabel;
@property(nonatomic,retain)IBOutlet CGLabel* messageLabel;

@end
