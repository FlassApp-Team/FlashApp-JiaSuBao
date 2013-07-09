//
//  CloseServiceViewController.m
//  FlashApp
//
//  Created by 朱广涛 on 13-4-13.
//  Copyright (c) 2013年 lidiansen. All rights reserved.
//

#import "CloseServiceViewController.h"

@interface CloseServiceViewController ()

@end

@implementation CloseServiceViewController
@synthesize headImageView;
@synthesize scrollView;
@synthesize helpView;
@synthesize henxianImageView;

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
    
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setHelpView:nil];
    [self setHeadImageView:nil];
    [self setHenxianImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (IBAction)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [scrollView release];
    [helpView release];
    [headImageView release];
    [henxianImageView release];
    [super dealloc];
}
@end
