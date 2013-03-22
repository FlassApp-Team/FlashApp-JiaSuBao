//
//  IFDataViewController.h
//  flashapp
//
//  Created by 李 电森 on 12-4-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <ifaddrs.h>
#include <sys/socket.h>
#include <net/if.h>


@interface IFDataViewController : UITableViewController
{
    NSMutableArray* ifNames;
    NSMutableDictionary* ifDataDic;
}

@end
