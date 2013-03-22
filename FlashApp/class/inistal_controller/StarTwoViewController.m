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
@synthesize starBtn;
@synthesize installBtn;
@synthesize bgView;
@synthesize ativty;
@synthesize imageView;
-(void)dealloc
{
    self.imageView=nil;
    self.bgView=nil;
    self.ativty=nil;
    self.installBtn=nil;
    self.starBtn=nil;
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
-(IBAction)starServe:(id)sender
{
    
    [self activtyStar];
    [AppDelegate installProfile:nil apn:nil];
    


  //  [self.starBtn setUserInteractionEnabled:NO];

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
