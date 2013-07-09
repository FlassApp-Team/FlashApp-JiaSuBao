//
//  BannerImageUtil.m
//  FlashApp
//
//  Created by 七 叶 on 13-1-30.
//  Copyright (c) 2013年 lidiansen. All rights reserved.
//

#import "BannerImageUtil.h"

@interface BannerImageUtil()

@property(nonatomic,retain) NSRecursiveLock *saveLock;

@end

@implementation BannerImageUtil
@synthesize saveLock;


-(void)dealloc{
    self.saveLock=nil;
    [super dealloc];
}
-(id)init{
    if(self=[super init]){
        self.saveLock=[[[NSRecursiveLock alloc] init] autorelease];
    }
    return self;
}


+(BannerImageUtil *)getBanerImageUtil{
    static id sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}


+(NSInteger)getTimeStamp{
    return [[NSUserDefaults standardUserDefaults]integerForKey:@"bannertimestamp"];
}

+(void)saveTimeStamp:(NSInteger)timestamp{
    [[NSUserDefaults standardUserDefaults] setInteger:timestamp forKey:@"bannertimestamp"];
}

+(NSMutableArray *)getBanners{
    NSMutableArray *arr=[[NSUserDefaults standardUserDefaults] valueForKey:@"BannerImageUtil"];
    return arr;
}

-(void)saveBannerWithImage1:(NSData *)data1 Link:(NSString *)link{

    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:data1,@"imageData",link,@"link", nil];
    
    NSMutableArray *arr=[[NSUserDefaults standardUserDefaults] objectForKey:@"BannerImageUtil"];
    NSMutableArray *arr1=[[[NSMutableArray alloc]init] autorelease];
    [arr1 addObject:dic];
    if([arr count])
        [arr1 addObjectsFromArray:arr];

//    NSLog(@"banfnfnfnffn===%d",[arr count]);

    [[NSUserDefaults standardUserDefaults] setValue:arr1 forKey:@"BannerImageUtil"];
    [[NSUserDefaults  standardUserDefaults]synchronize];
}

@end
