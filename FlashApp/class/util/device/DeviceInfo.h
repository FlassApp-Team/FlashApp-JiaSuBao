//
//  DeviceInfo.h
//  flashget
//
//  Created by 李 电森 on 11-11-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DeviceInfo : NSObject 
{
    NSString* name;
    
    NSString* deviceId;
    
    NSString* platform;
    
    NSString* version;
    
    NSString* phone;
    
    NSString* hardware;
    
    NSNumber* status;
    
    NSNumber* quantity;
    
    NSNumber* steadyQuantity;
    
    NSNumber* proxyflag;
}


@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* deviceId;
@property (nonatomic, retain) NSString* platform;
@property (nonatomic, retain) NSString* version;
@property (nonatomic, retain) NSString* phone;
@property (nonatomic, retain) NSNumber* status;
@property (nonatomic, retain) NSNumber* quantity;
@property (nonatomic, retain) NSNumber* steadyQuantity;
@property (nonatomic, retain) NSNumber* proxyflag;
@property (nonatomic, retain) NSString* hardware;

- (id) initWithJSON:(NSObject*)obj;
+ (DeviceInfo*) deviceInfoWithLocalDevice;

@end
