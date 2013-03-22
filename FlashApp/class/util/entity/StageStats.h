//
//  StageStats.h
//  flashapp
//
//  Created by 李 电森 on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StageStats : NSObject
{
    time_t startTime;
    time_t endTime;
    long bytesBefore;
    long bytesAfter;
}

@property (nonatomic, assign) time_t startTime;
@property (nonatomic, assign) time_t endTime;
@property (nonatomic, assign) long bytesBefore;
@property (nonatomic, assign) long bytesAfter;

@end
