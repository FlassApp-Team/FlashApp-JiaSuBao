//
//  TuiJianModleViewController.h
//  FlashApp
//
//  Created by lidiansen on 12-12-26.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBUtton.h"
@class RecommendViewController;
@interface TuiJianModleViewController : UIViewController
@property(nonatomic,retain)RecommendViewController *recommendViewController;
@property (nonatomic ,retain)UIImageView *animationImgView ;
@property(nonatomic,retain)IBOutlet CustomBUtton *tuijianBtn;

@end
