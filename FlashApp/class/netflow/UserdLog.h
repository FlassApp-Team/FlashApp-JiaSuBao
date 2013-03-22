//
//  UserdLog.h
//  flashapp
//
//  Created by 李 电森 on 12-5-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserdLog : NSObject
{
    int myId;
    long sendBytes;
    long receiveBytes;
    long totalBytes;
    long deltaBytes;
    time_t lastChangedTime;
    time_t createTime;
    int type;
    NSString* desc;
    int tcDay;
    long tcUsed;
}

@property (nonatomic, assign) int myId;
@property (nonatomic, assign) long sendBytes;
@property (nonatomic, assign) long receiveBytes;
@property (nonatomic, assign) long totalBytes;
@property (nonatomic, assign) long deltaBytes;
@property (nonatomic, assign) time_t lastChangedTime;
@property (nonatomic, assign) time_t createTime;
@property (nonatomic, assign) int type;
@property (nonatomic, retain) NSString* desc;
@property (nonatomic, assign) int tcDay;
@property (nonatomic, assign) long tcUsed;

@end
