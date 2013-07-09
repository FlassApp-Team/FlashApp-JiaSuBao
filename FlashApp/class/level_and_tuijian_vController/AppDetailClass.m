//
//  AppDetailClass.m
//  flashapp
//
//  Created by 朱广涛 on 13-4-25.
//  Copyright (c) 2013年 Home. All rights reserved.
//

#import "AppDetailClass.h"

@implementation AppDetailClass
@synthesize apid; //应用id
@synthesize apname; //应用名称
@synthesize apdesc; //应用简介
@synthesize rkm; //推荐理由
@synthesize star; //星星
@synthesize beni; //飞币
@synthesize pics; //应用图片
@synthesize fsize; //应用大小
@synthesize icon; //应用图标
@synthesize link; //i-tunse 链接
@synthesize picslen; //图片大小
@synthesize oprice; //原价
@synthesize cprice; //现价
@synthesize limFree; //现免；

+(id)getAppDetailClass
{
    static AppDetailClass *appDetail ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appDetail = [[AppDetailClass alloc] init];
    });
    return appDetail;
}


@end
