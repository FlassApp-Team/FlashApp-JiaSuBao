//
//  LocationManager.m
//  flashapp
//
//  Created by Qi Zhao on 12-11-18.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import "TCLocationManager.h"
#import "AppDelegate.h"
#import "TCUtils.h"


@implementation TCLocationManager


@synthesize manager;


- (void) dealloc
{
    if ( manager ) [manager release];
    manager = nil;
    [super dealloc];
}


- (void) startManager
{
    if ( !manager ) {
        manager = [[CLLocationManager alloc] init];
        manager.delegate = self;
        manager.distanceFilter = 10.0f;
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        [manager startMonitoringSignificantLocationChanges];
    }
}


- (void) stopManager
{
    [manager stopMonitoringSignificantLocationChanges];
}


- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"locationManager didUpdateLocation!!!!");
    [TCUtils readIfData:-1];
    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshNotification object:nil];
}


- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"locationManager didFailWithError!!!!");
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:UD_LOCATION_ENABLED];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"locationManager didChangeAuthorizationStatus!!!!");
}

@end
