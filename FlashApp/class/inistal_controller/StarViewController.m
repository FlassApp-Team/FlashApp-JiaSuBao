//
//  LoadingPageViewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-26.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import "StarViewController.h"
#import "StarOneViewController.h"
#import "StarTwoViewController.h"
#import "StarLastViewController.h"
#import "StarThreeViewController.h"
@interface StarViewController ()
-(void)initScrollview;
-(void)stopAnimation;
-(void)scrollViewAnimationOut;
@end
static StarViewController *starViewController;

@implementation StarViewController
@synthesize scrollView;
@synthesize starOneViewController;
@synthesize starTwoViewController;
@synthesize titleLabel;
@synthesize starThreeViewController;
@synthesize textScrollView;
@synthesize textScrollviewOffset;
@synthesize scrollviewOffset;
-(void)dealloc
{
    self.titleLabel=nil;
    self.textScrollView=nil;
    self.starTwoViewController=nil;
    self.starOneViewController=nil;
    self.scrollView=nil;
    [super dealloc];
}

+ (StarViewController*)sharedstarViewController
{
	@synchronized(self) {
		
        if (starViewController == nil) {
            starViewController = [[StarViewController alloc] init];
            
        }
    }
    return starViewController;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES ];
    self.scrollView.delegate=self;
    self.textScrollviewOffset=60;
    self.scrollviewOffset=320;
    [self initScrollview];
    [self starAnimation];
    // Do any additional setup after loading the view from its nib.
}
-(void)initScrollview
{
    
    [self.scrollView setContentSize:CGSizeMake((3 * self.scrollView.bounds.size.width),self.scrollView.bounds.size.height)];
    
    [self.textScrollView setContentSize:CGSizeMake(425,self.scrollView.bounds.size.height)];
    
    self.starOneViewController=[[[StarOneViewController alloc]init] autorelease];
    [self.scrollView addSubview:self.starOneViewController.view];
    self.starOneViewController.view.frame=CGRectMake(0, 0, self.starOneViewController.view.frame.size.width, self.starOneViewController.view.frame.size.height);
    
    
    self.starTwoViewController=[[[StarTwoViewController alloc]init] autorelease];
    [self.scrollView addSubview:self.starTwoViewController.view];
    self.starTwoViewController.view.frame=CGRectMake(320, 0, self.starTwoViewController.view.frame.size.width, self.starTwoViewController.view.frame.size.height);
    
    self.starThreeViewController=[[[StarThreeViewController alloc]init] autorelease];
    [self.scrollView addSubview:self.starThreeViewController.view];
    self.starThreeViewController.view.frame=CGRectMake(640, 0, self.starThreeViewController.view.frame.size.width, self.starThreeViewController.view.frame.size.height);
    
    
    
    self.textScrollView.decelerationRate=0.1;
}

-(void)starAnimation
{
    [UIView animateWithDuration:0.6 animations:^{
        self.titleLabel.frame = CGRectMake( 121, self.titleLabel.frame.origin.y, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
        
        
    }completion:^(BOOL finished){
        [self stopAnimation];}];
}
-(void)stopAnimation
{
    [UIView animateWithDuration:0.3 animations:^{
        self.titleLabel.frame = CGRectMake( 107, self.titleLabel.frame.origin.y, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
        
        
    }completion:^(BOOL finished){
        [self stopAnimation];}];
}
-(void)scrollViewAnimation:(float)OffsetX
{
    [UIView animateWithDuration:0.6 animations:^{
        self.textScrollView.frame = CGRectMake( self.textScrollView.frame.origin.x-OffsetX, self.textScrollView.frame.origin.y, self.textScrollView.frame.size.width, self.textScrollView.frame.size.height);
        [self.view setUserInteractionEnabled:NO];
        
    }completion:^(BOOL finished){
        [self scrollViewAnimationOut];}];
    
    
}
-(void)scrollViewAnimationOut
{
    [UIView animateWithDuration:0.3 animations:^{
        self.textScrollView.frame = CGRectMake(self.textScrollView.frame.origin.x+10, self.textScrollView.frame.origin.y, self.textScrollView.frame.size.width, self.textScrollView.frame.size.height);
        
        
    }completion:^(BOOL finished){}];
    [self.view setUserInteractionEnabled:YES];

   // NSLog(@"AAAAAAAAAAAAAA%@",NSStringFromCGRect(self.textScrollView.frame));
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
