//
//  Profile.m
//  flashapp
//
//  Created by zhen fang on 11-12-15.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Profile.h"

@implementation Profile
+(BOOL)verifyProfile:(NSObject*)obj{
    Boolean islegal = false;
    if ( !obj || ![obj isKindOfClass:[NSDictionary class]] ) return false;
    NSDictionary* dic = (NSDictionary*) obj;
    islegal = [[dic objectForKey:@"ip"] boolValue];
    return islegal;
}
@end
