//
//  ApplicationUtils.h
//  FlashApp
//
//  Created by fang zhen on 13-7-4.
//  Copyright (c) 2013年 lidiansen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationUtils : NSObject

@property (retain,nonatomic)NSMutableArray* mArray;
//周推送
-(void)onOrOff:(BOOL)sender;
//周推送数据初始化
-(void)restoreDefault;
//通知收到后，触发该方法
-(void)showNotification:(int)number type:(NSString *)type info:(NSString *)info;
//套餐流量达到80%，100%进行推送
+(void)dataStatsNotification;
@end
