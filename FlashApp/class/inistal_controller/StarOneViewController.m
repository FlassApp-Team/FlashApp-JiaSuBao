//
//  StarOneViewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-27.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import "StarOneViewController.h"
#import "StarViewController.h"
@interface StarOneViewController ()
-(void)btnAnimation;
@end

@implementation StarOneViewController
@synthesize imageView1;
@synthesize imageView2;
@synthesize imageView3;
@synthesize imageView4;
@synthesize viewArray;
@synthesize activity;
@synthesize timer;
@synthesize nextBtn;

@synthesize wangGeImageView;

@synthesize bgImageView;
-(void)dealloc
{
    self.bgImageView=nil;
    self.timer=nil;
    self.activity=nil;
    self.imageView1=nil;
    self.imageView2=nil;
    self.imageView3=nil;
    self.imageView4=nil;
    self.viewArray=nil;
    self.nextBtn=nil;
    self.wangGeImageView=nil;
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
    UIImage *image1=[UIImage imageNamed:@"white_box.png"];
    image1=[image1 stretchableImageWithLeftCapWidth:image1.size.width/2 topCapHeight:image1.size.height/2];
    self.bgImageView.image=image1;
    
    
    index=0;
    [self.activity startAnimating];
    
    UIImage *image=[UIImage imageNamed:@"wangge.png"];
    self.wangGeImageView.backgroundColor=[UIColor colorWithPatternImage:image] ;
    self.wangGeImageView.opaque=NO;

   // self.wangGeImageView.image=image;
    
    self.timer=[NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(timerHandle) userInfo:nil repeats:YES];

    
    self.viewArray=[[[NSArray alloc]initWithObjects:self.imageView1,self.imageView2,self.imageView3,self.imageView4, nil]autorelease];
}

-(void)timerHandle
{
    if(index>=[self.viewArray count])
    {
        [self.activity stopAnimating];
        [self.activity setHidden:YES];
        [self.timer invalidate];
        self.timer=nil;
        [self.nextBtn setEnabled:YES];
        [self btnAnimation];
        [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"bluebtn.png"] forState:UIControlStateNormal];
        [AppDelegate buttonTopShadow:self.nextBtn shadowColor:[UIColor darkGrayColor]];
        [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        return;
    }
    UIImageView *imageView6=nil;
    UIImageView *imageView=(UIImageView *)[self.viewArray objectAtIndex:index];
    if(index+1>=[self.viewArray count])
    {
        imageView6=(UIImageView *)[self.viewArray objectAtIndex:index];
        [self.activity stopAnimating];
        [self.activity setHidden:YES];

    }
    else
    {
        imageView6=(UIImageView *)[self.viewArray objectAtIndex:index+1];

    }
    imageView.image=[UIImage imageNamed:@"proceed.png"];
    self.activity.frame=imageView6.frame;
    index++;

}
-(void)btnAnimation
{
    [self.nextBtn setAlpha:0.2];
    [UIView animateWithDuration:0.4 animations:^{

        [self.nextBtn setAlpha:1.0];

        
    }completion:^(BOOL finished){
   }];

}
-(IBAction)nextBtnPress:(id)sender
{
    StarViewController *starViewController=[StarViewController sharedstarViewController];
    [starViewController.scrollView setContentOffset:CGPointMake(320, 0) animated:YES];
    [starViewController scrollViewAnimation:70];
    [self.nextBtn setUserInteractionEnabled:NO];

    NSLog(@"AAAAAAAAAA");
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
