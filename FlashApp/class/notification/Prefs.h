

#import <Foundation/Foundation.h>

@interface Prefs : NSObject
+(NSUserDefaults*)defaults;
+(NSMutableArray*)array;
+(void)setArray:(NSArray*)array;
+(int)badgeNumber;
+(void)setBadgeNumber:(int)number;

@end
