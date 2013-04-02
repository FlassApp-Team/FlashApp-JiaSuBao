//
//  ShareToSNSViewController.m
//  flashapp
//
//  Created by 李 电森 on 12-5-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShareToSNSViewController.h"
#import "OpenUDID.h"
#import "AppDelegate.h"
#import "JSON.h"
#import "DateUtils.h"
#import "StringUtil.h"

@interface ShareToSNSViewController ()
- (void) shareToSNS;
@end

@implementation ShareToSNSViewController

@synthesize webView;
@synthesize textLabel;
@synthesize indicatorView;
@synthesize image;
@synthesize content;
@synthesize sns;
@synthesize loaded;

@synthesize imageName;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) dealloc
{
    self.imageName=nil;
    [textLabel release];
    [indicatorView release];
    [webView release];
    [image release];
    [content release];
    [sns release];
    [super dealloc];
}


#pragma mark - view lifecircle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.view.backgroundColor = [UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1.0f];

    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.title = NSLocalizedString(@"shareToSNS.navItem.title", nil);
    
    UIBarButtonItem* button = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"closeName", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(close)];
    self.navigationItem.rightBarButtonItem = [button autorelease];
    
    loaded = NO;
    [indicatorView startAnimating];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.textLabel = nil;
    self.indicatorView = nil;
    self.webView = nil;
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ( !loaded ) {
        loaded = YES;
        [self shareToSNS];
    }
}


- (void) viewWillDisappear:(BOOL)animated
{
    if (picClient) {
        [picClient cancel];
        [picClient release];
        picClient = nil;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void) close
{
    if([AppDelegate  deviceSysVersion]>=6.0f)
    {
        [[[AppDelegate getAppDelegate] navController] dismissViewControllerAnimated:YES completion:nil];
        
    }
    else
    {
        [[[AppDelegate getAppDelegate] navController] dismissModalViewControllerAnimated:YES];
        
    }}


#pragma mark - share methods

- (void) shareToSNS
{
    if (picClient) return;
    
    self.textLabel.text = NSLocalizedString(@"shareToSNS.share.label.text", nil);

    NSString* deviceId = [OpenUDID value];
    NSString* title = NSLocalizedString(@"shareToSNS.share.title", nil);
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:deviceId forKey:@"deviceId"];
    [dic setObject:title forKey:@"title"];
    [dic setObject:content forKey:@"content"];
    [dic setObject:sns forKey:@"sns"];
    [dic setObject:@"2" forKey:@"appid"];

    NSString* url = [NSString stringWithFormat:@"http://%@/loginsns/share/device.jsp", P_HOST];
    picClient = [[TwitPicClient alloc] initWithDelegate:self];
    if(imageName)
    {
        imageName=nil;
    }
    else
    {
        imageName=@"file";

    }

    [picClient upload:url image:image name:imageName params:dic];
}


- (void) incrCapacity
{
    //给用户增加限额
    UserSettings* user = [AppDelegate getAppDelegate].user;
    
    time_t now;
    time( &now );
    NSString* month = [DateUtils stringWithDateFormat:now format:@"MM"];
    
    BOOL flag = YES;
    if ( user.month ) {
        if ( [month compare:user.month] == NSOrderedSame ) {
            if ( user.monthCapacity < QUANTITY_MONTH_SHARE_LIMIT ) {
                user.monthCapacity += 1;
                user.monthCapacityDelta += 1;
                user.capacity += QUANTITY_PER_SHARE;
            }
            else {
                flag = NO;
            }
        }
        else {
            user.month = month;
            user.monthCapacity = 1;
            user.monthCapacityDelta = 1;
            user.capacity += QUANTITY_PER_SHARE;
        }
    }
    else {
        user.month = month;
        user.monthCapacity = 1;
        user.monthCapacityDelta = 1;
        user.capacity += QUANTITY_PER_SHARE;
    }
    
    if ( flag ) {
        [UserSettings saveUserSettings:user];
        
        //刷新Datasave页面
        [AppDelegate getAppDelegate].refreshDatasave = YES;

        //发送服务器请求getMemberInfo
        //client = [[TwitterClient alloc] initWithTarget:self action:@selector(didGetMemberInfo:obj:)];
        //[client getMemberInfo];
        [TwitterClient getMemberInfoSync];
    }
}


- (void) didGetMemberInfo:(TwitterClient*)tc obj:(NSObject*)obj
{
    client = nil;
    if ( !obj || ![obj isKindOfClass:[NSDictionary class]] ) return;
    
    NSDictionary* dic = (NSDictionary*)obj;
    [TwitterClient parseMemberInfo:dic];
}


#pragma mark - TwitPicClient Delegate

- (void)twitPicClientDidFail:(TwitPicClient*)sender error:(NSString*)error detail:(NSString*)detail
{
    picClient =nil;
    self.image = nil;
    [indicatorView stopAnimating];
    [AppDelegate showAlert:error];
}

- (void)twitPicClientDidDone:(TwitPicClient*)sender content:(NSString*)response
{
    picClient = nil;
    self.image = nil;
    
    if ( !response ) return;
    
    NSObject* obj = [response JSONValue];
    if ( !obj || ![obj isKindOfClass:[NSDictionary class]] ) return;
    
    NSDictionary* dic = (NSDictionary*) obj;
    NSString* errorCode = [dic objectForKey:@"error_code"];
    if ( errorCode ) {
        [AppDelegate showAlert:NSLocalizedString(@"shareToSNS.share.error", nil)];
        return;
    }
    
    NSString* url = [dic objectForKey:@"redirect"];
    if ( !url ) return;
    
    self.textLabel.text = NSLocalizedString(@"shareToSNS.share.loading", nil);
   // NSLog(@"AAAAAAAAAAAAAAAAA%@",url);
    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setValue:@"flashapp/1.0 speedit CFNetwork/548.1.4 Darwin/11.0.0" forHTTPHeaderField:@"User-Agent"];

    [webView loadRequest:request];
}


#pragma mark - Webview Delegate

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [indicatorView stopAnimating];
    indicatorView.hidden = YES;
    textLabel.hidden = YES;
}


- (BOOL) webView:(UIWebView *)webView1 shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* url = request.URL.absoluteString;
    NSString* scheme = request.URL.scheme;
    NSString* host = request.URL.host;
    NSDictionary* params = [TwitterClient urlParameters:url];
    
    if ( [@"alert" compare:scheme] == NSOrderedSame ) {
        NSString* s = [url substringFromIndex:8];
        s = [s decodeFromPercentEscapeString];
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"promptName", nil) message:s delegate:nil cancelButtonTitle:NSLocalizedString(@"defineName", nil) otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        return NO;
    }
    else if ( [@"logout" compare:scheme] == NSOrderedSame ) {
        NSHTTPCookie *cookie;
        NSRange range;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies]) {
            range = [cookie.domain rangeOfString:host];
            if ( range.location != NSNotFound ) {
                [storage deleteCookie:cookie];
            }
        }
        
        NSString* redirect = [params objectForKey:@"redirect"];
        if ( redirect ) {
            redirect = [redirect decodeFromPercentEscapeString];
            NSMutableURLRequest*req=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:redirect]];
            [req setValue:@"flashapp/1.0 speedit CFNetwork/548.1.4 Darwin/11.0.0" forHTTPHeaderField:@"User-Agent"];
            [webView1 loadRequest:req];
            return NO;
        }
    }
    else if ( [@"fail" compare:scheme] == NSOrderedSame ) {
        NSString* errorPage = [[NSBundle mainBundle] pathForResource:@"faq/erro" ofType:@"html"];
        NSMutableURLRequest*req=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:errorPage]];
        [req setValue:@"flashapp/1.0 speedit CFNetwork/548.1.4 Darwin/11.0.0" forHTTPHeaderField:@"User-Agent"];
        
        [webView1 loadRequest:req];
        [self performSelector:@selector(close) withObject:nil afterDelay:3.0f];
        return NO;
    }
    else if ( [@"succe" compare:scheme] == NSOrderedSame ) {
        //[self close];
        return NO;
    }
    else if ( [@"finish" compare:scheme] == NSOrderedSame ) {
        time_t startTime;
        time( &startTime );
        
        [self incrCapacity];
        
        time_t endTime;
        time( &endTime );
        
        time_t d = endTime - startTime;
        if ( d < 3 ) {
            sleep( 3 - d );
        }
        [self close];
        
        return NO;
    }
    
    return YES;
    
}


@end
