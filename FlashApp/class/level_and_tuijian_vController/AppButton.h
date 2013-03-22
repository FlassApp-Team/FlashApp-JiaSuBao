//
//  AppButton.h
//  FlashApp
//
//  Created by 七 叶 on 13-1-30.
//  Copyright (c) 2013年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppButton : UIButton
@property(nonatomic,retain)NSString *linkUrl;
@property(nonatomic,retain)NSString *appName;
@property(nonatomic,retain)NSString *appSize;
@property(nonatomic,retain)NSString *appDescibe;
@property(nonatomic,assign)NSInteger appStar;
@property(nonatomic,retain)NSString *appIcon;
@end
