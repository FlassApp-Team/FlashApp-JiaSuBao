//
//  LocationManager.h
//  flashapp
//
//  Created by Qi Zhao on 12-11-18.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface TCLocationManager : NSObject <CLLocationManagerDelegate>
{
    CLLocationManager* manager;
}


@property (nonatomic, readonly) CLLocationManager* manager;


- (void) startManager;
- (void) stopManager;

@end
