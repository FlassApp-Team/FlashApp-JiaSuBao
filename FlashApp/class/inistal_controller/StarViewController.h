//
//  LoadingPageViewController.h
//  FlashApp
//
//  Created by lidiansen on 12-12-26.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGLabel.h"
@class StarOneViewController;
@class StarTwoViewController;
@class StarThreeViewController;
@interface StarViewController: UIViewController<UIScrollViewDelegate>
{


}

@property(assign)float textScrollviewOffset;
@property(assign)float scrollviewOffset;

@property(nonatomic,retain)IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain)IBOutlet UIScrollView *textScrollView;
@property(nonatomic,retain)IBOutlet CGLabel *titleLabel;

@property(nonatomic,retain)StarOneViewController *starOneViewController;
@property(nonatomic,retain)StarTwoViewController *starTwoViewController;
@property(nonatomic,retain)StarThreeViewController *starThreeViewController;
+ (StarViewController*)sharedstarViewController;
-(void)scrollViewAnimation:(float)OffsetX;
-(void)starAnimation;
@end
