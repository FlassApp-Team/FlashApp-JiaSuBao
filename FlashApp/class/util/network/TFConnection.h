//
//  Connection.h
//  TwitterFon
//
//  Created by kaz on 7/25/08.
//  Copyright 2008 naan studio. All rights reserved.
//

//#define kOAuthConsumerKey				@"3983859935"		//REPLACE ME
//#define kOAuthConsumerSecret			@"201fea7b1e1203a76a10f3be570f5abb"		//REPLACE ME
#define kOAuthConsumerKey				@"ec29c04b4d224fe9a32176b67be1e8fb"		//REPLACE ME
#define kOAuthConsumerSecret			@"f21671577de04b24a126c7c24461f8df"		//REPLACE ME


extern NSString *TWITTERFON_FORM_BOUNDARY;

@interface TFConnection : NSObject
{
	id                  delegate;
    NSString*           requestURL;
	NSURLConnection*    connection;
	NSMutableData*      buf;
    int                 statusCode;
    BOOL                needAuth;
}

@property (nonatomic, readonly) NSMutableData* buf;
@property (nonatomic, assign) int statusCode;
@property (nonatomic, copy) NSString* requestURL;

- (id)initWithDelegate:(id)delegate;
- (void)get:(NSString*)URL;
- (void)post:(NSString*)aURL body:(NSString*)body;
- (void)post:(NSString*)aURL data:(NSData*)data;
- (void)cancel;

- (void)TFConnectionDidFailWithError:(NSError*)error;
- (void)TFConnectionDidFinishLoading;

+ (void) addAuthorizationHeader:(NSMutableURLRequest*)req username:(NSString*)username password:(NSString*)password;

+ (id) sendSynchronousRequest:(NSString*)aURL 
                     response:(NSHTTPURLResponse**)response error:(NSError**)error;
+ (id) sendSynchronousRequest:(NSString *)aURL body:(NSString*)body
                     response:(NSHTTPURLResponse **)response error:(NSError **)error;
+ (id) sendSynchronousRequest:(NSString*)aURL method:(NSString*)method body:(NSData*)body
                     response:(NSHTTPURLResponse**)response error:(NSError**)error;

+ (void) connectSocket:(NSString*)host port:(int)port;
+ (void) socketConnect:(NSString*)host port:(int)port;
+ (NSString*) httpGet:(NSString*)host port:(int)port location:(NSString*)location;
+ (NSString*) httpGet2:(NSString*)host port:(int)port location:(NSString*)location ;
+ (NSString*) composeURLVerifyCode:(NSString*)url;
+ (NSString*) composeURLVerifyCode:(NSString*)url appendStr:(NSString*)appendStr;

@end
