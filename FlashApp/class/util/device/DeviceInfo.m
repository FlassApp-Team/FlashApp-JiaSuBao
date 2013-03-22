//
//  DeviceInfo.m
//  flashget
//
//  Created by 李 电森 on 11-11-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
#import "DeviceInfo.h"
#import "OpenUDID.h"
#import "UIDevice-Reachability.h"


@implementation DeviceInfo

@synthesize name;
@synthesize deviceId;
@synthesize platform;
@synthesize version;
@synthesize phone;
@synthesize status;
@synthesize quantity;
@synthesize steadyQuantity;
@synthesize proxyflag;
@synthesize hardware;



- (id) initWithJSON:(NSObject*)obj
{
    if ( !obj || ![obj isKindOfClass:[NSDictionary class]] ) return nil;
    
    NSDictionary* dic = (NSDictionary*) obj;
    
    self = [super init];
    if ( self ) {
        NSObject* aobj = [dic objectForKey:@"name"];
        if ( aobj && aobj != [NSNull null] ) {
            self.name = (NSString*) aobj;
        }

        aobj = [dic objectForKey:@"deviceId"];
        if ( aobj && aobj != [NSNull null] ) {
            self.deviceId = (NSString*) aobj;
        }

        aobj = [dic objectForKey:@"platform"];
        if ( aobj && aobj != [NSNull null] ) {
            self.platform = (NSString*) aobj;
        }

        aobj = [dic objectForKey:@"version"];
        if ( aobj && aobj != [NSNull null] ) {
            self.version = (NSString*) aobj;
        }

        aobj = [dic objectForKey:@"phone"];
        if ( aobj && aobj != [NSNull null] ) {
            self.phone = (NSString*) aobj;
        }

        aobj = [dic objectForKey:@"status"];
        if ( aobj && aobj != [NSNull null] ) {
            int i = [((NSString*) aobj) intValue];
            self.status = [NSNumber numberWithInt:i];
        }
        else {
            self.status = 0;
        }

        aobj = [dic objectForKey:@"quantity"];
        if ( aobj && aobj != [NSNull null] ) {
            float i = [((NSString*) aobj) floatValue];
            self.steadyQuantity = [NSNumber numberWithFloat:i];
        }
        
        aobj = [dic objectForKey:@"tempquantity"];
        if ( aobj && aobj != [NSNull null] ) {
            float i = [((NSString*) aobj) floatValue];
            self.quantity = [NSNumber numberWithFloat:i];
        }
        
        aobj = [dic objectForKey:@"proxyFlag"];
        if ( aobj && aobj != [NSNull null] ) {
            int b = [((NSString*) aobj) intValue];
            self.proxyflag = [NSNumber numberWithInt:b];
        }
    }
    
    return self;
}


+ (DeviceInfo*) deviceInfoWithLocalDevice
{
    UIDevice* device = [UIDevice currentDevice];
    NSString* deviceId = [OpenUDID value];
    NSString* name = device.name;
    NSString* platform = device.systemName;
    NSString* version = device.systemVersion;

    DeviceInfo* info = [[[DeviceInfo alloc] init] autorelease];
    info.deviceId = deviceId;
    info.name = name;
    info.platform = platform;
    info.version = version;
    info.hardware = [device hardware];
    return info;
}


- (void) dealloc {
    [name release];
    [deviceId release];
    [platform release];
    [version release];
    [phone release];
    [status release];
    [quantity release];
    [proxyflag release];
    [hardware release];
    [super dealloc];
}

@end
