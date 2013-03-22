//
//  IFData.h
//  flashapp
//
//  Created by 李 电森 on 12-4-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IFData : NSObject 
{
    NSString* ifName;
    long receiveBytes;
    long sendBytes;
    time_t lastchangeTime;
    
    time_t createTime;
}

@property (nonatomic, retain) NSString* ifName;
@property (nonatomic, assign) long receiveBytes;
@property (nonatomic, assign) long sendBytes;
@property (nonatomic, assign) time_t lastchangeTime;
@property (nonatomic, assign) time_t createTime;

@end
