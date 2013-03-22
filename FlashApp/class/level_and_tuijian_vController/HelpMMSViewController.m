//
//  HelpMMSViewController.m
//  flashapp
//
//  Created by Qi Zhao on 12-7-22.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "HelpMMSViewController.h"
#import "FeedbackViewController.h"

#define TAG_BACKGROUND_IMAGEVIEW 101

@interface HelpMMSViewController ()
@property(nonatomic,retain)IBOutlet UIButton *fankuiBtn;
@end

@implementation HelpMMSViewController

@synthesize scrollview;
@synthesize fankuiBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)turnBtnPress:(id)sender
{
    [[sysdelegate navController  ] popViewControllerAnimated:YES];
}
-(IBAction)fankuiBtnPress:(id)sender
{
    FeedbackViewController*feedbackViewController=[[[FeedbackViewController alloc]init] autorelease];
    [self.navigationController pushViewController:feedbackViewController animated:YES];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImage* img=[UIImage imageNamed:@"opaque_small.png"];
    img=[img stretchableImageWithLeftCapWidth:7 topCapHeight:8];
    [self.fankuiBtn setBackgroundImage:img forState:UIControlStateNormal];
    UIImageView* imageView = (UIImageView*) [self.view viewWithTag:TAG_BACKGROUND_IMAGEVIEW];
    imageView.image = [[UIImage imageNamed:@"help_triangle_bg.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:20];
    
    self.navigationItem.title = @"诊断与帮助";
    scrollview.contentSize = CGSizeMake(320, 1100);
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    self.fankuiBtn=nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
