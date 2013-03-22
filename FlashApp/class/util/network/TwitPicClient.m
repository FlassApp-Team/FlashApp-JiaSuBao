//
//  TwitterClient.m
//  TwitterFon
//
//  Created by kaz on 7/13/08.
//  Copyright naan studio 2008. All rights reserved.
//

#import "TwitPicClient.h"
#import "StringUtil.h"
#import "REString.h"

@interface NSObject (TwitterClientDelegate)
- (void)twitPicClientDidPost:(TwitPicClient*)sender mediaId:(NSString*)mediaId;
- (void)twitPicClientDidFail:(TwitPicClient*)sender error:(NSString*)error detail:(NSString*)detail;
- (void)twitPicClientDidDone:(TwitPicClient*)sender content:(NSString*)content;
@end

@implementation TwitPicClient

@synthesize context;

- (id)initWithTarget:(id)aDelegate
{
    [super initWithDelegate:aDelegate];
    return self;
}

+ (NSString*) nameValString: (NSDictionary*) dict {
	NSArray* keys = [dict allKeys];
	NSString* result = [NSString string];
	int i;
	for (i = 0; i < [keys count]; i++) {
        result = [result stringByAppendingString:
                  [@"--" stringByAppendingString:
                   [TWITTERFON_FORM_BOUNDARY stringByAppendingString:
                    [@"\r\nContent-Disposition: form-data; name=\"" stringByAppendingString:
                     [[keys objectAtIndex: i] stringByAppendingString:
                      [@"\"\r\n\r\n" stringByAppendingString:
                       [[dict valueForKey: [keys objectAtIndex: i]] stringByAppendingString: @"\r\n"]]]]]]];
	}

	return result;
}

- (void) upload:(NSString*)url image:(NSData*)image name:(NSString*)imageName params:(NSDictionary*)dic
{
    NSString *param = [TwitPicClient nameValString:dic];
    NSString *footer = [NSString stringWithFormat:@"\r\n--%@--\r\n", TWITTERFON_FORM_BOUNDARY];
    
    param = [param stringByAppendingString:[NSString stringWithFormat:@"--%@\r\n", TWITTERFON_FORM_BOUNDARY]];

    param = [param stringByAppendingFormat:@"Content-Disposition: form-data; name=\"%@\";filename=\"image.jpg\"\r\nContent-Type: image/jpeg\r\n\r\n", imageName];
    NSLog(@"jpeg size: %d", [image length]);
    
    NSMutableData *data = [NSMutableData data];
    [data appendData:[param dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:image];
    [data appendData:[footer dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self post:url data:data];
}


- (void)TFConnectionDidFailWithError:(NSError*)error
{
    [delegate twitPicClientDidFail:self error:@"Connection Failed" detail:[error localizedDescription]];
}


- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    [delegate twitPicClientDidFail:self error:@"Authentication Failed" detail:@"Wrong username/Email and password combination."];
}


- (void)TFConnectionDidFinishLoading
{
    NSString* content = [[[NSString alloc] initWithData:buf encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"%@", content);
    
    if (statusCode != 200) {
        NSString *error = [NSString stringWithFormat:@"TwitPic Error: %d", statusCode];
        [delegate twitPicClientDidFail:self error:error detail:@"Failed to upload photo to TwitPic."];
        return;
    }
    else {
        [delegate twitPicClientDidDone:self content:content];
    }
}


- (void) dealloc
{
    [context release];
    [super dealloc];
}


@end
