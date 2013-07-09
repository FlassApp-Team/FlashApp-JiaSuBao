//
//  StarTwoViewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-27.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import "StarTwoViewController.h"
#import "StarViewController.h"
@interface StarTwoViewController ()

@end

@implementation StarTwoViewController

@synthesize ativty;
@synthesize bgView;
@synthesize imageView;
@synthesize elseView;


-(void)dealloc
{
    self.imageView=nil;
    self.bgView=nil;
    self.ativty=nil;
    [elseView release];
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
    
    UIImage *image=[UIImage imageNamed:@"activty_bg.png"];
    image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    self.imageView.image=image;
    
    // Do any additional setup after loading the view from its nib.
}
-(void)activtyStar
{
    [self.bgView setHidden:NO];
    [self.ativty startAnimating];
    [self.view setUserInteractionEnabled:NO];
    [self performSelector:@selector(activtyStop) withObject:nil afterDelay:3.0];
}
-(void)activtyStop
{
    [self.bgView setHidden:YES];
    [self.ativty stopAnimating];
    [self.view setUserInteractionEnabled:YES];
    StarViewController *starViewController=[StarViewController sharedstarViewController];
    [starViewController.scrollView setContentOffset:CGPointMake(640, 0) animated:YES];
    [starViewController scrollViewAnimation:40];
}

/*
 *用户点击安装 apn
 */
-(IBAction)starServe:(id)sender
{
    
    [self activtyStar];
    
    UserSettings *user = [UserSettings currentUserSettings];
    user.profileType = @"apn";
    [UserSettings saveUserSettings:user];
    
    if ([CHANNEL isEqualToString:@"appstore"]) {
        [AppDelegate installProfile:nil  vpnn:nil interfable:@"1"];
    }else{
        [AppDelegate installProfile:nil vpnn:nil interfable:@"0"];
    }
    
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

- (void)viewDidUnload {
    [self setElseView:nil];
    [super viewDidUnload];
}
@end
