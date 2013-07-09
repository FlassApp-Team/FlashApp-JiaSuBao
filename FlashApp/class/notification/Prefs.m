

#import "Prefs.h"


@implementation Prefs
+(NSUserDefaults*)defaults{
    return [NSUserDefaults standardUserDefaults];
}
+(NSMutableArray*)array{
    NSArray* array=[[Prefs defaults]objectForKey:@"todo_list"];
    if (array) {
        return [NSMutableArray arrayWithArray:array];
    }else{
        return nil;
    }
}
+(void)setArray:(NSArray*)array{
    [[Prefs defaults]setObject:array forKey:@"todo_list"];
    [[Prefs defaults]synchronize];
}
+(int)badgeNumber{
    NSNumber* number=[[Prefs defaults]objectForKey:@"badge_number"];
    if (number) {
        return number.intValue;
    }else
        return 0;
}
+(void)setBadgeNumber:(int)number{
    [[Prefs defaults]setObject:[NSNumber numberWithInt:number]
                        forKey:@"badge_number"];
    [[Prefs defaults]synchronize];
}
@end




