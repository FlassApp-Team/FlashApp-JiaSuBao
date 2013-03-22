//
//  StarLastViewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-27.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import "StarLastViewController.h"
#import "FeedbackViewController.h"
#import "StarViewController.h"
@interface StarLastViewController ()

@end

@implementation StarLastViewController
@synthesize feedbackViewController;
@synthesize feedBackBtn;
-(void)dealloc
{
    self.feedBackBtn=nil;
    self.feedbackViewController=nil;
    [super dealloc];
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
    UIImage* img=[UIImage imageNamed:@"opaque_small.png"];
    img=[img stretchableImageWithLeftCapWidth:7 topCapHeight:8];
    [self.feedBackBtn setBackgroundImage:img forState:UIControlStateNormal];
    // Do any additional setup after loading the view from its nib.
}
-(IBAction)turnBtnPress:(id)sender
{
    [[sysdelegate navController  ]popViewControllerAnimated:NO];

}
-(IBAction)feedBackBtnPress:(id)sender
{
    if(self.feedbackViewController==nil)
    {
        self.feedbackViewController=[[[FeedbackViewController alloc]init] autorelease];
        [[sysdelegate navController  ]pushViewController:self.feedbackViewController animated:NO];
    }
}
-(IBAction)againBtnPress:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
    StarViewController *starViewController=[StarViewController sharedstarViewController];
    [starViewController.scrollView setContentOffset:CGPointMake(320, 0) animated:YES];
    starViewController.textScrollView.frame = CGRectMake( -60, 0, 425, 168);
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
