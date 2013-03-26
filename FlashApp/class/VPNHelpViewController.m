//
//  VPNHelpViewController.m
//  FlashApp
//
//  Created by 朱广涛 on 13-3-25.
//  Copyright (c) 2013年 lidiansen. All rights reserved.
//

#import "VPNHelpViewController.h"

@interface VPNHelpViewController ()

@end

@implementation VPNHelpViewController
@synthesize webView;
@synthesize activity;
@synthesize pointLabel;

- (void)dealloc {
    [webView release];
    [activity release];
    [pointLabel release];
    [super dealloc];
}
- (void)viewDidUnload
{
    [self setWebView:nil];
    [self setActivity:nil];
    [self setPointLabel:nil];
    [super viewDidUnload];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CGRect makeSize = [[UIScreen mainScreen] applicationFrame];
    
    webView.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height, makeSize.size.width, makeSize.size.height-self.navigationController.navigationBar.frame.size.height);
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString *htmlString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"YDD" ofType:@"html"]  encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:htmlString baseURL:baseURL];
    
//    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"YDD" ofType:@"html"];
        
//    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:resourcePath]];
    
//    [webView loadRequest:req];
}

-(IBAction)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
