/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License for anything not specifically marked as developed by a third party.
 Apple's code excluded.
 Use at your own risk
 */

#import <SystemConfiguration/SystemConfiguration.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#include <ifaddrs.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#import "UIDevice-Reachability.h"
#import "Reachability.h"

@implementation UIDevice (Reachability)
SCNetworkConnectionFlags connectionFlags;

// Matt Brown's get WiFi IP addy solution
// http://mattbsoftware.blogspot.com/2009/04/how-to-get-ip-address-of-iphone-os-v221.html
+ (NSString *) localWiFiIPAddress
{
	BOOL success;
	struct ifaddrs * addrs;
	const struct ifaddrs * cursor;
	
	success = getifaddrs(&addrs) == 0;
	if (success) {
		cursor = addrs;
		while (cursor != NULL) {
			// the second test keeps from picking up the loopback address
			if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0) 
			{
				NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
				if ([name isEqualToString:@"en0"])  // Wi-Fi adapter
					return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
			}
			cursor = cursor->ifa_next;
		}
		freeifaddrs(addrs);
	}
	return nil;
}

#pragma mark Checking Connections

+ (void) pingReachabilityInternal
{
	BOOL ignoresAdHocWiFi = NO;
	struct sockaddr_in ipAddress;
	bzero(&ipAddress, sizeof(ipAddress));
	ipAddress.sin_len = sizeof(ipAddress);
	ipAddress.sin_family = AF_INET;
	ipAddress.sin_addr.s_addr = htonl(ignoresAdHocWiFi ? INADDR_ANY : IN_LINKLOCALNETNUM);
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (struct sockaddr *)&ipAddress);    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &connectionFlags);
    CFRelease(defaultRouteReachability);
	if (!didRetrieveFlags) 
        printf("Error. Could not recover network reachability flags\n");
}

+ (BOOL) networkAvailable
{
	[self pingReachabilityInternal];
	BOOL isReachable = ((connectionFlags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((connectionFlags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}


+ (BOOL) reachableToHost:(NSString*)hostname
{
    Reachability* reachability = [Reachability reachabilityWithHostName:hostname];
    NetworkStatus status = [reachability currentReachabilityStatus];
    if ( status == NotReachable ) {
        return NO;
    }
    else {
        return YES;
    }
}


+ (BOOL) activeWWAN
{
	if (![self networkAvailable]) return NO;
	return ((connectionFlags & kSCNetworkReachabilityFlagsIsWWAN) != 0);
}

+ (BOOL) activeWLAN
{
	return ([UIDevice localWiFiIPAddress] != nil);
}

+ (ConnectionType) connectionType
{
    if ( [UIDevice activeWLAN] ) {
        return WIFI;
    }
    else if ( [UIDevice activeWWAN] ) {
        return CELL_2G;
    }
    else if ( [UIDevice networkAvailable] ) {
        return UNKNOWN;
    }
    else {
        return NONE;
    }
}


+ (NSString*) connectionTypeString
{
    ConnectionType type = [UIDevice connectionType];
    switch (type) {
        case UNKNOWN:
            return @"unknown";
        case CELL_2G:
            return @"2g";
        case CELL_3G:
            return @"3g";
        case CELL_4G:
            return @"4g";
        case WIFI:
            return @"wifi";
        case NONE:
            return @"none";
        case ETHERNET:
            return @"ethernet";
        default:
            return @"unknown";
    }
}


- (NSString *) hardware
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);

    if ([platform isEqualToString:@"iPhone1,1"])   return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])   return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])   return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])   return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])   return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPod1,1"])     return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])     return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])     return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])     return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPad1,1"])     return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])     return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])     return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])     return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"i386"])        return @"Simulator";

    return platform;
}


//- (BOOL)isJailbroken 
//{
//    BOOL jailbroken = NO;  
//    NSString *cydiaPath = @"/Applications/Cydia.app";  
//    NSString *aptPath = @"/private/var/lib/apt/";  
//    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]) {  
//        jailbroken = YES;  
//    }  
//    if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath]) {  
//        jailbroken = YES;  
//    }  
//    return jailbroken;  
//}  


@end