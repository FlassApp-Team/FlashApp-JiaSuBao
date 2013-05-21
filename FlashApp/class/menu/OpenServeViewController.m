//
//  OpenServeViewController.m
//  FlashApp
//
//  Created by 朱广涛 on 13-4-12.
//  Copyright (c) 2013年 lidiansen. All rights reserved.
//

#import "OpenServeViewController.h"

@interface OpenServeViewController ()

@end

@implementation OpenServeViewController
@synthesize label1;
@synthesize label2;
@synthesize label3;
@synthesize label4;
@synthesize label5;
@synthesize image1;
@synthesize image2;
@synthesize image3;
@synthesize image4;
@synthesize image5;
@synthesize webView;
@synthesize scrollView;

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
    
    scrollView.contentSize = CGSizeMake(320, 580);
}

- (void)viewDidUnload
{
    [self setLabel1:nil];
    [self setLabel2:nil];
    [self setLabel3:nil];
    [self setLabel4:nil];
    [self setLabel5:nil];
    [self setImage1:nil];
    [self setImage2:nil];
    [self setImage3:nil];
    [self setImage4:nil];
    [self setImage5:nil];
    [self setWebView:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (IBAction)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)chongixinBtn:(id)sender
{
    NSString *inchk = [[NSUserDefaults standardUserDefaults] objectForKey:@"inchk"];
//    NSString *inchk = @"0";
    
    if ([@"1" isEqualToString:inchk]) {
        [AppDelegate installProfile:@"current" vpnn:@"apn" interfable:@"1"];
    }else{
        [AppDelegate installProfile:@"current" vpnn:@"apn" interfable:@"0"];
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [label1 release];
    [label2 release];
    [label3 release];
    [label4 release];
    [label5 release];
    [image1 release];
    [image2 release];
    [image3 release];
    [image4 release];
    [image5 release];
    [webView release];
    [scrollView release];
    [super dealloc];
}
@end
