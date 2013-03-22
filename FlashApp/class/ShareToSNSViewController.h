//
//  ShareToSNSViewController.h
//  flashapp
//
//  Created by 李 电森 on 12-5-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitPicClient.h"
#import "TwitterClient.h"

@interface ShareToSNSViewController : UIViewController <UIWebViewDelegate>
{
    UIWebView* webView;
    UILabel* textLabel;
    UIActivityIndicatorView* indicatorView;

    NSData* image;
    NSString* content;
    NSString* sns;
    
    TwitPicClient* picClient;
    TwitterClient* client;
    BOOL loaded;
    BOOL success;
}

@property (nonatomic, retain) NSString* imageName;

@property (nonatomic, retain) NSData* image;
@property (nonatomic, retain) NSString* content;
@property (nonatomic, retain) NSString* sns;
@property (nonatomic, assign) BOOL loaded;

@property (nonatomic, retain) IBOutlet UIWebView* webView;
@property (nonatomic, retain) IBOutlet UILabel* textLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* indicatorView;

@end
