//
//  SecondPageViewController.h
//  FlashApp
//
//  Created by lidiansen on 12-12-13.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGLabel.h"
@class ImageModleViewController;
@class WangSuModleViewController;
@class LockNetModleViewController;
@class ZhengDuanModleViewController;
@class WenTiModleViewController;
//@class TellFriendModleViewController;
@interface SecondPageViewController : UIViewController




@property(nonatomic,retain)ImageModleViewController*imageModleViewController;
@property(nonatomic,retain)WangSuModleViewController *wangSuModleViewController;
@property(nonatomic,retain)LockNetModleViewController*lockNetModleViewController;
@property(nonatomic,retain)ZhengDuanModleViewController *zhengDuanModleViewController;
@property(nonatomic,retain)WenTiModleViewController *wenTiModleViewController;
//@property(nonatomic,retain)TellFriendModleViewController*tellFriendModleViewController;


@end
