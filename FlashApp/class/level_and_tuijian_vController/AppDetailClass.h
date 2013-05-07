//
//  AppDetailClass.h
//  flashapp
//
//  Created by 朱广涛 on 13-4-25.
//  Copyright (c) 2013年 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppDetailClass : NSObject

@property (nonatomic ,copy) NSString *apid; //应用id

@property (nonatomic ,copy) NSString *apname; //应用名称

@property (nonatomic ,copy) NSString *apdesc; //应用简介

@property (nonatomic ,copy) NSString *rkm; //推荐理由

@property (nonatomic ,assign)int star; //星星

@property (nonatomic ,retain)NSMutableDictionary *beni; //飞币

@property (nonatomic ,retain) NSMutableArray *pics; //应用图片

@property (nonatomic ,copy) NSString *fsize; //应用大小

@property (nonatomic ,copy) NSString *icon; //应用图标

@property (nonatomic ,copy) NSString *link; //i-tunse 链接

@property (nonatomic ,copy) NSString *picslen; //图片大小

@property (nonatomic ,copy) NSString *oprice; //原价

@property (nonatomic ,copy) NSString *cprice; //现价

@property (nonatomic ,copy) NSString *limFree; //是否现免

+(id)getAppDetailClass;

@end
