//
//  VPNHelpViewController.h
//  FlashApp
//
//  Created by 朱广涛 on 13-3-25.
//  Copyright (c) 2013年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VPNHelpViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (retain, nonatomic) IBOutlet UILabel *pointLabel;

@property (nonatomic ,assign) BOOL showCloseBtn;

@end
