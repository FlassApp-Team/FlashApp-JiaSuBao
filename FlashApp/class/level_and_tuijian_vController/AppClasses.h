//
//  AppClasses.h
//  FlashApp
//
//  Created by 朱广涛 on 13-5-7.
//  Copyright (c) 2013年 lidiansen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppClasses : NSObject

@property (nonatomic ,assign) int appClasses_id;

@property (nonatomic ,copy)NSString *appClasses_icon;

@property (nonatomic ,copy)NSString *appClasses_name;

@property (nonatomic ,assign)int appClass_new;

@property (nonatomic ,assign)long long appClass_tim;

@end
