//
//  Connection.m
//  TwitterFon
//
//  Created by kaz on 7/25/08.
//  Copyright 2008 naan studio. All rights reserved.
//
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>
#include <unistd.h>
#include <netdb.h>
#include <setjmp.h>
#include <errno.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <sys/select.h>
#include <sys/types.h>
#include <sys/time.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/ip.h>
#include <sys/ioctl.h>
#include <net/if.h>
#import "TFConnection.h"
#import "AppDelegate.h"
#import "JSON.h"
#import "StringUtil.h"
#import "OpenUDID.h"


#define NETWORK_TIMEOUT 60.0


@implementation TFConnection

@synthesize buf;
@synthesize statusCode;
@synthesize requestURL;

NSString *TWITTERFON_FORM_BOUNDARY = @"0194784892923";

- (id)initWithDelegate:(id)aDelegate
{
	self = [super init];
	delegate = aDelegate;
    statusCode = 0;
    needAuth = false;
	return self;
}

- (void)dealloc
{
    [requestURL release];
	[connection release];
	[buf release];
	[super dealloc];
}


+ (NSString*) composeURLVerifyCode:(NSString*)url
{
    return [self composeURLVerifyCode:url appendStr:nil];
}


+ (NSString*) composeURLVerifyCode:(NSString*)url appendStr:(NSString*)appendStr
{
    if ( !url ) return url;
    
    srand( time(0) );
    int rd = ((float) rand()) / RAND_MAX * 10000;
    
    NSString* deviceId = [OpenUDID value];
    NSString* code = [[NSString stringWithFormat:@"%@%@%@%d%@", deviceId, CHANNEL, API_KEY, rd, 
                       appendStr?appendStr:@""] md5HexDigest];
    
    NSString* newurl;
    NSRange range = [url rangeOfString:@"?"];
    if ( range.location == NSNotFound ) {
        newurl = [NSString stringWithFormat:@"%@?deviceId=%@&chl=%@&rd=%d&code=%@&ver=%@",
                  url, deviceId, CHANNEL, rd, code, API_VER];
    }
    else {
        newurl = [NSString stringWithFormat:@"%@&deviceId=%@&chl=%@&rd=%d&code=%@&ver=%@",
                  url, deviceId, CHANNEL, rd, code, API_VER];
    }

    
    return newurl;
}



+ (void) connectSocket:(NSString*)host port:(int)port
{
    struct hostent *get_ip_addr;   //网络地址的数据结构hostent
    get_ip_addr = gethostbyname( [host cStringUsingEncoding:NSUTF8StringEncoding] );  //调用gethostbyname获取主机ip地址，放入结构题get_ip_addr
    
    struct sockaddr_in remote_host;  //网络socket结构remote_host
    remote_host.sin_family = AF_INET;  //使用TCP／IP
    remote_host.sin_port = htons(port);  //远程端口
    memcpy(&remote_host.sin_addr.s_addr,get_ip_addr->h_addr_list[0],sizeof(get_ip_addr->h_addr_list[0]));//获取一个IP把他放入remote_host.sin_addr.s_addr的内存空间
    
    int remote_std = socket(AF_INET,SOCK_STREAM,0); //打开socket，并定义套接字remote_std
    connect(remote_std,(struct sockaddr*)&remote_host,sizeof(remote_host)); //连接目标主机
    close( remote_std );
}


+ (int) createSocket:(NSString*)host port:(int)port
{
    struct hostent *get_ip_addr;   //网络地址的数据结构hostent
    get_ip_addr = gethostbyname( [host cStringUsingEncoding:NSUTF8StringEncoding] );  //调用gethostbyname获取主机ip地址，放入结构题get_ip_addr
    
    struct sockaddr_in serv_addr;  //网络socket结构remote_host
    serv_addr.sin_family = AF_INET;  //使用TCP／IP
    serv_addr.sin_port = htons(port);  //远程端口
    memcpy(&serv_addr.sin_addr.s_addr,get_ip_addr->h_addr_list[0],sizeof(get_ip_addr->h_addr_list[0]));//获取一个IP把他放入remote_host.sin_addr.s_addr的内存空间
    
    int sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if(sockfd < 0) return -1;
    
    int error=-1, len;
    len = sizeof(int);
    struct timeval tm;
    fd_set set;
    
    unsigned long ul = 1;
    ioctl(sockfd, FIONBIO, &ul); //设置为非阻塞模式
    
    bool ret = false;
    if( connect(sockfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) == -1)
    {
        tm.tv_sec  = 10;
        tm.tv_usec = 0;
        FD_ZERO(&set);
        FD_SET(sockfd, &set);
        if( select(sockfd+1, NULL, &set, NULL, &tm) > 0)
        {
            getsockopt(sockfd, SOL_SOCKET, SO_ERROR, &error, (socklen_t *)&len);
            if(error == 0) ret = true;
            else ret = false;
        } else ret = false;
    }
    else ret = true;
    ul = 0;
    ioctl(sockfd, FIONBIO, &ul); //设置为阻塞模式
    
    if(!ret) {
        close( sockfd );
        fprintf(stderr , "Cannot Connect the server!/n");
        return -1;
    }
    else {
        fprintf( stderr , "Connected!/n");
        return sockfd;
    }
}



+ (void) socketConnect:(NSString*)host port:(int)port
{
    int sockfd = [TFConnection createSocket:host port:port];
    if ( sockfd >= 0 ) {
        close( sockfd );
    }
}


//发送GET请求
+ (NSString*) httpGet2:(NSString*)host port:(int)port location:(NSString*)location 
{
    char response[204800],http_request[2048];  //接收数据的缓冲区大小200k 请求内容缓冲区2k
    memset(http_request,'\0',sizeof(http_request));  //将请求内容的内存空间置空
    
    memset(response,'\0',sizeof(response));  //将请求内容的内存空间置空
    
    int remote_std = [TFConnection createSocket:host port:port];
    if ( remote_std == -1 ) return nil;
    
    //    sprintf(http_request,get_format,data); //写入http请求内容
    
    NSString* requestString = [NSString stringWithFormat:@"GET %@ HTTP/1.1\r\nHost: %@\r\nConnection: Close\r\n\r\n", location, host];
    strcpy(http_request, [requestString UTF8String] );
    
    send(remote_std,http_request,strlen(http_request),0);  //发送请求
    recv(remote_std,response,sizeof(response),0);  //接收返回，并把内容放入response
    close( remote_std );
    
    NSString* s = [NSString stringWithCString:response encoding:NSUTF8StringEncoding];
    return s;  //返回ret指针
}



//发送GET请求
+ (NSString*) httpGet:(NSString*)host port:(int)port location:(NSString*)location 
{
    char response[204800],http_request[2048];  //接收数据的缓冲区大小200k 请求内容缓冲区2k
    memset(http_request,'\0',sizeof(http_request));  //将请求内容的内存空间置空
    
    memset(response,'\0',sizeof(response));  //将请求内容的内存空间置空
    
    struct hostent *get_ip_addr;   //网络地址的数据结构hostent
    
    get_ip_addr = gethostbyname( [host cStringUsingEncoding:NSUTF8StringEncoding] );  //调用gethostbyname获取主机ip地址，放入结构题get_ip_addr
    
    struct sockaddr_in remote_host;  //网络socket结构remote_host
    remote_host.sin_family = AF_INET;  //使用TCP／IP
    remote_host.sin_port = htons(port);  //远程端口
    memcpy(&remote_host.sin_addr.s_addr,get_ip_addr->h_addr_list[0],sizeof(get_ip_addr->h_addr_list[0]));//获取一个IP把他放入remote_host.sin_addr.s_addr的内存空间
    
    int remote_std = socket(AF_INET,SOCK_STREAM,0); //打开socket，并定义套接字remote_std
    int ret = connect(remote_std,(struct sockaddr*)&remote_host,sizeof(remote_host)); //连接目标主机
    if ( ret == -1 ) return nil;
    
    //    sprintf(http_request,get_format,data); //写入http请求内容
    
    NSString* requestString = [NSString stringWithFormat:@"GET %@ HTTP/1.1\r\nHost: %@\r\nConnection: Close\r\n\r\n", location, host];
    strcpy(http_request, [requestString UTF8String] );

    send(remote_std,http_request,strlen(http_request),0);  //发送请求
    recv(remote_std,response,sizeof(response),0);  //接收返回，并把内容放入response
    close( remote_std );

    NSString* s = [NSString stringWithCString:response encoding:NSUTF8StringEncoding];
    return s;  //返回ret指针
}


+ (void) addAuthorizationHeader:(NSMutableURLRequest*)req
{
    NSString* username = [AppDelegate getAppDelegate].user.username;
    NSString* password = [AppDelegate getAppDelegate].user.password;
    [self addAuthorizationHeader:req username:username password:password];
    
}


- (void)addAuthHeader:(NSMutableURLRequest*)req
{
    if (!needAuth) return;
	[TFConnection addAuthorizationHeader:req];
}


+ (void) addAuthorizationHeader:(NSMutableURLRequest*)req username:(NSString*)username password:(NSString*)password
{
    NSString* auth = [NSString stringWithFormat:@"%@:%@", username, password];
    NSString* basicauth = [NSString stringWithFormat:@"Basic %@", [NSString base64encode:auth]];
    [req setValue:basicauth forHTTPHeaderField:@"Authorization"];
}


+ (id) sendSynchronousRequest:(NSString*)aURL
                     response:(NSHTTPURLResponse**)response error:(NSError**)error
{
    return [TFConnection sendSynchronousRequest:aURL method:@"GET" body:nil
                                       response:response error:error];
}


+ (id) sendSynchronousRequest:(NSString *)aURL body:(NSString*)body
                     response:(NSHTTPURLResponse **)response error:(NSError **)error
{
    int contentLength = [body lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSData* data = [NSData dataWithBytes:[body UTF8String] length:contentLength];
    return [TFConnection sendSynchronousRequest:aURL method:@"POST" body:data response:response error:error];
}



+ (id) sendSynchronousRequest:(NSString*)aURL method:(NSString*)method body:(NSData*)body
                     response:(NSHTTPURLResponse**)response error:(NSError**)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *URL = (NSString*)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)aURL, (CFStringRef)@"%", NULL, kCFStringEncodingUTF8);
	[URL autorelease];
    NSLog(@"%@", URL);
	
    NSURL* finalURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@source=%@", 
                                         URL,
                                         ([URL rangeOfString:@"?"].location != NSNotFound) ? @"&" : @"?" , 
                                         kOAuthConsumerKey]];
   // NSLog(@"finsalUrl==%@",URL);
	NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:finalURL
													   cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
												   timeoutInterval:NETWORK_TIMEOUT];
    [req setHTTPMethod:method];
    //[req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    int contentLength = [body length];
    [req setValue:[NSString stringWithFormat:@"%d", contentLength] forHTTPHeaderField:@"Content-Length"];
    
    [req setValue:@"flashapp/1.0 speedit CFNetwork/548.1.4 Darwin/11.0.0" forHTTPHeaderField:@"User-Agent"];

    
    if ( [@"POST" compare:method] == NSOrderedSame && body != nil ) {
        [req setHTTPBody:body];
        //[req setHTTPBodyStream:[NSInputStream inputStreamWithData:body]];
    }
	
	[TFConnection addAuthorizationHeader:req];
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	NSData* data = [NSURLConnection sendSynchronousRequest:req returningResponse:response error:error];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
    NSLog( @"url=%@", URL );
	NSLog(@"Response: %d, length=%d", (*response).statusCode, [data length] );
    //NSString* s = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    //NSLog(@"Response text:%@", s);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
	if ( (*response).statusCode == 200 ) {
		NSString* s = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        NSLog(@"Response text:%@", s);
		NSObject* object = [s JSONValue];
		return object;
	}
	else {
		return nil;
	}
}



- (void)get:(NSString*)aURL
{
    [connection release];
	[buf release];
    statusCode = 0;
    
    self.requestURL = aURL;
    
    NSString *URL = (NSString*)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)aURL, (CFStringRef)@"%", NULL, kCFStringEncodingUTF8);
	
	[URL autorelease];
    NSLog(@"%@", URL);
	
	NSURL *finalURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@source=%@", 
											URL,
											([URL rangeOfString:@"?"].location != NSNotFound) ? @"&" : @"?" , 
											kOAuthConsumerKey]];
	NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:finalURL
                                         cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                     timeoutInterval:NETWORK_TIMEOUT];
    [req setValue:@"flashapp/1.0 speedit CFNetwork/548.1.4 Darwin/11.0.0" forHTTPHeaderField:@"User-Agent"];

    [self addAuthHeader:req];
    
  	buf = [[NSMutableData data] retain];
	connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}


-(void)post:(NSString*)aURL body:(NSString*)body
{
    [connection release];
	[buf release];
    statusCode = 0;
    
    self.requestURL = aURL;
    
    NSString *URL = (NSString*)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)aURL, (CFStringRef)@"%", NULL, kCFStringEncodingUTF8);
    [URL autorelease];
	NSURL *finalURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@source=%@", 
											URL,
											([URL rangeOfString:@"?"].location != NSNotFound) ? @"&" : @"?" , 
											kOAuthConsumerKey]];
	NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:finalURL
                                                       cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                   timeoutInterval:NETWORK_TIMEOUT];
    
    
    [req setHTTPMethod:@"POST"];
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [self addAuthHeader:req];
    
    int contentLength = [body lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    [req setValue:[NSString stringWithFormat:@"%d", contentLength] forHTTPHeaderField:@"Content-Length"];
    [req setValue:@"flashapp/1.0 speedit CFNetwork/548.1.4 Darwin/11.0.0" forHTTPHeaderField:@"User-Agent"];

    [req setHTTPBody:[NSData dataWithBytes:[body UTF8String] length:contentLength]];
    
	buf = [[NSMutableData data] retain];
	connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)post:(NSString*)aURL data:(NSData*)data
{
    [connection release];
	[buf release];
    statusCode = 0;

    self.requestURL = aURL;

    NSString *URL = (NSString*)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)aURL, (CFStringRef)@"%", NULL, kCFStringEncodingUTF8);
    [URL autorelease];
	NSURL *finalURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@source=%@", 
											URL,
											([URL rangeOfString:@"?"].location != NSNotFound) ? @"&" : @"?" , 
											kOAuthConsumerKey]];
	NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:finalURL
                                                       cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                   timeoutInterval:NETWORK_TIMEOUT];
    

    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", TWITTERFON_FORM_BOUNDARY];
    [req setHTTPMethod:@"POST"];
    [req setValue:contentType forHTTPHeaderField:@"Content-Type"];
    [req setValue:[NSString stringWithFormat:@"%d", [data length]] forHTTPHeaderField:@"Content-Length"];
    [req setValue:@"flashapp/1.0 speedit CFNetwork/548.1.4 Darwin/11.0.0" forHTTPHeaderField:@"User-Agent"];

    [req setHTTPBody:data];
    [self addAuthHeader:req];
    
	buf = [[NSMutableData data] retain];
	connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)cancel
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;    
    if (connection) {
        [connection cancel];
        [connection autorelease];
        connection = nil;
    }
}

- (void)connection:(NSURLConnection *)aConnection didReceiveResponse:(NSURLResponse *)aResponse
{
    NSHTTPURLResponse *resp = (NSHTTPURLResponse*)aResponse;
    if (resp) {
        statusCode = resp.statusCode;
        NSLog(@"Response: %d", statusCode);
    }
	[buf setLength:0];
}

- (void)connection:(NSURLConnection *)aConn didReceiveData:(NSData *)data
{
	[buf appendData:data];
}

- (void)connection:(NSURLConnection *)aConn didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
	[connection autorelease];
	connection = nil;
	[buf autorelease];
	buf = nil;
    
    UIDevice* device = [UIDevice currentDevice];
    float version = [device.systemVersion floatValue];
    if ( version >= 4.0 ) {
        [self TFConnectionDidFailWithError:error];
    }
    else {
        [self TFConnectionDidFailWithError:nil];
    }
}


- (void)TFConnectionDidFailWithError:(NSError*)error
{
    // To be implemented in subclass
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConn
{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    //NSString* s = [[[NSString alloc] initWithData:buf encoding:NSUTF8StringEncoding] autorelease];
    //NSLog(@"response: %@", s);
    [self TFConnectionDidFinishLoading];

    [connection autorelease];
    connection = nil;
    [buf autorelease];
    buf = nil;
}

- (void)TFConnectionDidFinishLoading
{
    // To be implemented in subclass
}

@end
