/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License for anything not specifically marked as developed by a third party.
 Apple's code excluded.
 Use at your own risk
 */

#import <UIKit/UIKit.h>

typedef enum {
    UNKNOWN,
    ETHERNET,
    WIFI,
    CELL_2G,
    CELL_3G,
    CELL_4G,
    NONE
} ConnectionType;


@interface UIDevice (Reachability)
+ (BOOL) networkAvailable;
+ (BOOL) activeWLAN;
+ (BOOL) activeWWAN;
+ (ConnectionType) connectionType;
+ (NSString*) connectionTypeString;
+ (BOOL) reachableToHost:(NSString*)hostname;
- (NSString*) hardware;
- (BOOL)isJailbroken;
@end