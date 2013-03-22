//
//  FirstPageViewController.h
//  FlashApp
//
//  Created by lidiansen on 12-12-13.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGLabel.h"
@class ModleOneViewController;
@class GoLineModleViewController;
@class TaoCanModleViewController;
@class YouHuaModleViewController;
@class TuiJianModleViewController;
@class TellFriendModleViewController;
@interface FirstPageViewController : UIViewController


@property(nonatomic,retain)ModleOneViewController*modleOneViewController;
@property(nonatomic,retain)GoLineModleViewController*goLineModleViewController;

@property(nonatomic,retain)TaoCanModleViewController*taoCanModleViewController;

@property(nonatomic,retain)YouHuaModleViewController *youHuaModleViewController;
@property(nonatomic,retain)TuiJianModleViewController *tuiJianModleViewController;
@property(nonatomic,retain)TellFriendModleViewController*tellFriendModleViewController;





@end
