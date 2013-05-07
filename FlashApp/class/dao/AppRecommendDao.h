//
//  AppRecommendDao.h
//  FlashApp
//
//  Created by 朱广涛 on 13-5-6.
//  Copyright (c) 2013年 lidiansen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AppClasses;

@interface AppRecommendDao : NSObject

+ (BOOL)createAppRecommendTable;

+ (void)insertAllAppRecommend:(NSArray *)arr;

+ (void)updateAppRecommend:(AppClasses *)appClassess;

+ (NSDictionary *)fondAllAppRecommend;

@end
