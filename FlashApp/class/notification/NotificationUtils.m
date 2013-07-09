//
//  ApplicationUtils.m
//  FlashApp
//
//  Created by fang zhen on 13-7-4.
//  Copyright (c) 2013年 lidiansen. All rights reserved.
//

#import "NotificationUtils.h"
#import "Prefs.h"

@implementation NotificationUtils
@synthesize mArray;

#pragma mark-week notification
//发送推送或者取消推送方法(周推送)
- (void)onOrOff:(BOOL)sender{
	if(sender){
        [self restoreDefault];
        [NotificationUtils cancelNofitication];
        for(NSDictionary* each in mArray){
            int index=((NSNumber*)[each objectForKey:@"number"]).intValue;
            [self scheduleNotification:index-1];
        }        
    }else {
		// 取消所有通知
        [mArray removeAllObjects];
        [NotificationUtils cancelNofitication];
		//[[UIApplication sharedApplication] cancelAllLocalNotifications];
	}
}
+(void)cancelNofitication{
    // 获得 UIApplication
    UIApplication *app = [UIApplication sharedApplication];
    //获取本地推送数组
    NSArray *localArray = [app scheduledLocalNotifications];
    //声明本地通知对象
    
    if (localArray) {
        for (UILocalNotification *noti in localArray) {
            NSDictionary *dict = noti.userInfo;
            if (dict) {
                NSString *inKey = [dict objectForKey:@"type"];
               // NSLog(@"inkey:%@",inKey);
                if ([inKey isEqualToString:@"weekPost"]) {
                    UILocalNotification *localNotification= [[UILocalNotification alloc] init];
                    localNotification = [noti retain];
                    [app cancelLocalNotification:localNotification];
                    [localNotification release];

                }
            }
        }
    }
}
//构造推送内容(周推送)
-(void)restoreDefault{
    mArray=[[NSMutableArray alloc]init];
    NSArray* arr=[Prefs array];
    int number=[Prefs badgeNumber];
    if (number!=0) {
        [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    }
    if (arr==nil || arr.count==0) {
        NSDate *nowDate = [NotificationUtils getCurrentDate];
        for (int i=1; i<5; i++) {
            NSTimeInterval interval = i*7*24*60*60; //隔一周推一次，总共推四周
            //NSTimeInterval interval = i*1*1*1*20;
            NSDate *date1 = [nowDate dateByAddingTimeInterval:interval];
          
            NSMutableDictionary* d=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:i],@"number",
                                    date1,@"time",
                                    @"NO",@"didRead",
                                    @"weekPost",@"type",
                                    [NSString stringWithFormat:@"你已经离开加速宝%d周了，没有使用我的日子我很伤心:-(。赶快回来吧!",i],@"info",nil];
            [mArray addObject:d];
            
            
        }
       
    }else{
        for (NSDictionary* each in arr) {
            [mArray addObject:[each mutableCopy]];
        }
    }
}
//本地推送(周推送)
-(void)scheduleNotification:(int)index{
    assert([mArray objectAtIndex:index]);
    NSMutableDictionary* dictionary=[mArray objectAtIndex:index];
    if ([@"YES" isEqualToString:[dictionary objectForKey:@"didRead"]]) {
        return;
    }
    [NotificationUtils sendNotification:dictionary];
}

//套餐流量达到80%，100%进行推送
+(void)dataStatsNotification{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    float total=[user.ctTotal floatValue];
    long long byte=[user.ctUsed longLongValue];
    int persent= byte / 1024.0f / 1024.0f/total*100; //套餐使用百分比
    NSString *tcUsed = nil;
    NSString *info = nil;
    //NSLog(@"persent:%d",persent);
    //NSLog(@"dataStatsNotification:%@,%@",[userDefault objectForKey:@"eightStats"],[userDefault objectForKey:@"hundredStats"]);
    if(( persent> 0 && persent < 80) && [@"YES" isEqualToString:[userDefault objectForKey:@"eightStats"]]){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"eightStats"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"hundredStats"];
    }
    else if (( persent >= 80 && persent < 100) && ![@"YES" isEqualToString:[userDefault objectForKey:@"eightStats"]]  ){
        float count=byte / 1024.0f / 1024.0f;
        if(count/1000>1||count/1000<-1)
        {
            tcUsed =  [NSString stringWithFormat:@"%.2f%@",byte / 1024.0f / 1024.0f/1024.0f,@"GB"];
            
        }else{
            tcUsed =  [NSString stringWithFormat:@"%.0f%@",byte / 1024.0f / 1024.0f,@"MB"];
        }
        
        info = [NSString stringWithFormat:@"你好,你的套餐流量已使用%@.所剩流量不多,注意节省哦.",tcUsed];
        [NotificationUtils scheduleStatsNotification:info type:@"eightStats"  number:5];

    }else if((persent >= 100) && ![@"YES" isEqualToString:[userDefault objectForKey:@"hundredStats"]] ){
        info = @"你好,你的流量套餐已经用完.从现在开始就要过紧巴巴的日子了,真伤心啊.";
        [NotificationUtils scheduleStatsNotification:info type:@"hundredStats" number:6];
    }  
   }

//套餐百分比推送
+(void)scheduleStatsNotification:(NSString *)info type:(NSString *)type number:(int)number{
    NSDate *pushDate = [NSDate dateWithTimeIntervalSinceNow:5];//5秒后推
    NSMutableDictionary* dictionary=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithInt:number],@"number",
                                     pushDate,@"time",
                                     @"NO",@"didRead",
                                     type,@"type",
                                     info,@"info",nil];
    [NotificationUtils sendNotification:dictionary];
    
}

//构造本地推送
+(void)sendNotification:(NSMutableDictionary* )dictionary{
    // 构造本地通知对象
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    // 设置通知对象的属性
    notification.timeZone=[NSTimeZone defaultTimeZone];//时区
    notification.repeatInterval=0;//重复周期,0-不重复
    notification.alertBody=[dictionary objectForKey:@"info"];//告警消息文本
    [notification setSoundName:UILocalNotificationDefaultSoundName];//声音
    notification.fireDate=[dictionary objectForKey:@"time"];
    [dictionary setObject:notification.fireDate forKey:@"fire_date"];
    notification.hasAction = YES;
    [notification setUserInfo:dictionary];
    
    // 调度本地通知
    [[UIApplication sharedApplication]scheduleLocalNotification:notification];
    
//    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
//    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//    NSString *dateStr = [dateformatter stringFromDate:notification.fireDate];
//    [dateformatter release];
  //  NSLog(@"datedatedatedatedate:%@,%@",dateStr, notification.alertBody);
  
    
    [notification release];
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:[dictionary objectForKey:@"type"]];
}
//接收通知后触发
-(void)showNotification:(int)number type:(NSString *)type info:(NSString *)info{
    if ([@"weekPost" isEqualToString:type] ) {
        NSMutableDictionary* dic=(NSMutableDictionary*)[mArray objectAtIndex:number-1];
        if ([@"NO" isEqualToString:[dic objectForKey:@"didRead"]]) {
            [dic setObject:@"YES" forKey:@"didRead"];
        }
    }
   
 }

//获取当前时间
+(NSDate*)getCurrentDate{
    NSDate *date = [NSDate date];
        
    NSUInteger unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:unitFlags fromDate:date];
    [comps setHour:10];
    [comps setMinute:0];
    [comps setSecond:0];
     NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    //[gregorian setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSDate *date1 = [gregorian dateFromComponents:comps];
    [gregorian release];
 
    return date1;
}

- (void)dealloc {
    [mArray release];
    [super dealloc];
}
@end
