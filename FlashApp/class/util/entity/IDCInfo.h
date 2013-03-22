//
//  IDCInfo.h
//  flashapp
//
//  Created by 李 电森 on 12-6-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDCInfo : NSObject
{
    NSString* code;
    NSString* name;
    NSString* host;
    float speed;
}

@property (nonatomic, retain) NSString* code;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* host;
@property (nonatomic, retain) NSString* desc;//add jianfie han

@property (nonatomic, assign) float speed;

+ (NSArray*) parseIDCList:(NSString*)idcString;

@end
