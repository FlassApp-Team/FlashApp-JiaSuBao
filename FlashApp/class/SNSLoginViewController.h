//
//  SNSLoginViewController.h
//  flashapp
//
//  Created by Qi Zhao on 12-7-28.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
@interface SNSLoginViewController : UIViewController <UIWebViewDelegate,ASIHTTPRequestDelegate>
{
    UIWebView* webview;
    UILabel* label;
    UIActivityIndicatorView* indicator;
    
    NSString* domain;
}
@property (nonatomic, retain) IBOutlet UIWebView* webview;
@property (nonatomic, retain) IBOutlet UILabel* label;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* indicator;
@property (nonatomic, retain) NSString* domain;
-(IBAction)turnBtnPress:(id)sender;
@end
