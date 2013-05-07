//
//  BannerImageUtil.h
//  FlashApp
//
//  Created by 七 叶 on 13-1-30.
//  Copyright (c) 2013年 lidiansen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BannerImageUtil : NSObject

+(NSInteger)getTimeStamp;
+(BannerImageUtil *)getBanerImageUtil;
-(void)saveBannerWithImage1:(NSData *)data1 Link:(NSString *)link;
+(NSMutableArray *)getBanners;
+(void)saveTimeStamp:(NSInteger)timestamp;
@end
