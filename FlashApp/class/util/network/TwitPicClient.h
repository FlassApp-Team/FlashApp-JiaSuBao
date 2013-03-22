#import <UIKit/UIKit.h>
#import "TFConnection.h"

@interface TwitPicClient : TFConnection
{
    id context;
}

@property (nonatomic, retain) id context;

- (id)initWithTarget:(id)delegate;
- (void) upload:(NSString*)url image:(NSData*)image name:(NSString*)imageName params:(NSDictionary*)dic;

@end
