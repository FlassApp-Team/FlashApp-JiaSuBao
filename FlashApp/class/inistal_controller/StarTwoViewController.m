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
@synthesize starBtn;
@synthesize shoudongBtn;
@synthesize zidongBtn;
@synthesize apnLabel;
@synthesize vpnLabel;
@synthesize zidonghelpLabel;
@synthesize shoudongHelpLabel;
@synthesize zidongLabel;
@synthesize shoudongLabel;
@synthesize miaoshuimageView;
@synthesize appstoreView;
@synthesize elseView;


-(void)dealloc
{
    self.imageView=nil;
    self.bgView=nil;
    self.ativty=nil;
    self.starBtn=nil;
    [appstoreView release];
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
    
    UIImage *miaoshuBianKuang = [UIImage imageNamed:@"white_box.png"];
    miaoshuBianKuang = [miaoshuBianKuang stretchableImageWithLeftCapWidth:miaoshuBianKuang.size.width/2 topCapHeight:miaoshuBianKuang.size.width/2];
    self.miaoshuimageView.image = miaoshuBianKuang;
    
    if ([CHANNEL isEqualToString:@"appstore"]) {
        elseView.hidden = YES;
    }else{
        appstoreView.hidden = YES;
    }
    
    
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
 *越狱用户点击安装 apn
 */
-(IBAction)starServe:(id)sender
{
    
    [self activtyStar];
    
    UserSettings *user = [UserSettings currentUserSettings];
    user.profileType = @"apn";
    [UserSettings saveUserSettings:user];
    
    [AppDelegate installProfile:nil vpnn:nil];
    
}

-(IBAction)autoBtn:(id)sender /* 自动按钮 */
{
    [self activtyStar];
    
    UserSettings *user = [UserSettings currentUserSettings];
    user.profileType = @"apn";
    [UserSettings saveUserSettings:user];
    
    [AppDelegate installProfile:nil  vpnn:nil];
}

-(IBAction)shouDongBtn:(id)sender /* 手动按钮 */
{
    [self activtyStar];
    
    UserSettings *user = [UserSettings currentUserSettings];
    user.profileType = @"vpn";
    [UserSettings saveUserSettings:user];
    
    [AppDelegate installProfile:nil  vpnn:nil];
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
    [self setShoudongLabel:nil];
    [self setZidongLabel:nil];
    [self setApnLabel:nil];
    [self setVpnLabel:nil];
    [self setZidonghelpLabel:nil];
    [self setShoudongHelpLabel:nil];
    [self setZidongBtn:nil];
    [self setShoudongBtn:nil];
    [self setAppstoreView:nil];
    [self setElseView:nil];
    [super viewDidUnload];
}
@end
