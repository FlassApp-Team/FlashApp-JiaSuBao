//
//  GetAddress.h
//  flashapp
//
//  Created by Zhao Qi on 13-3-24.
//  Copyright (c) 2013年 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MAXADDRS 20

#define min(a,b)    ((a) < (b) ? (a) : (b))
#define max(a,b)    ((a) > (b) ? (a) : (b))

#define BUFFERSIZE  4000


@interface GetAddress : NSObject
{
    NSMutableArray* ifNames;
    NSMutableArray* ipNames;
    NSMutableArray* hwAddrs;
    NSMutableArray* ipAddrs;
    int count;
    
//    @public char *if_names[MAXADDRS];
//    @public char *ip_names[MAXADDRS];
//    @public char *hw_addrs[MAXADDRS];
//    @public unsigned long ip_addrs[MAXADDRS];
//    @public int nextAddr;
}


@property (nonatomic, retain) NSMutableArray* ifNames;
@property (nonatomic, retain) NSMutableArray* ipNames;
@property (nonatomic, retain) NSMutableArray* hwAddrs;
@property (nonatomic, retain) NSMutableArray* ipAddrs;
@property (nonatomic, assign) int count;

- (void) getIPAddress;

//- (void) InitAddresses;
//- (void) FreeAddresses;
//- (void) GetIPAddresses;
//- (void) GetHWAddresses;

@end
