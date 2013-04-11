//
//  VPNCloseHelpViewController.m
//  FlashApp
//
//  Created by 朱广涛 on 13-4-10.
//  Copyright (c) 2013年 lidiansen. All rights reserved.
//

#import "VPNCloseHelpViewController.h"

@interface VPNCloseHelpViewController ()

@end

@implementation VPNCloseHelpViewController
@synthesize webView;

- (void)dealloc {
    [webView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    NSString *htmlString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"CLO" ofType:@"html"]  encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:htmlString baseURL:baseURL];
    
}

- (IBAction)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
