//
//  DetectionViewController.m
//  FlashApp
//
//  Created by lidiansen on 13-1-19.
//  Copyright (c) 2013年 lidiansen. All rights reserved.
//

#import "DetectionViewController.h"
#import "TrafficOptimizationViewController.h"
@interface DetectionViewController ()
-(void)loadNextController;
@end

@implementation DetectionViewController
@synthesize bgImageView;
@synthesize wangGeImageView;
@synthesize activity;
@synthesize viewArray;
@synthesize timer;
@synthesize imageView1,imageView2,imageView3;
@synthesize turnBrn;
@synthesize messageLabel;
@synthesize titleLabel;
@synthesize messageArray;
@synthesize detectActivity;
@synthesize detailArray;
@synthesize controller;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)dealloc
{
    self.controller=nil;
    self.detectActivity=nil;
    self.messageLabel=nil;
    self.titleLabel=nil;
    self.turnBrn=nil;
    self.bgImageView=nil;
    self.wangGeImageView=nil;
    self.activity=nil;
    self.viewArray=nil;
    if(timer)
    {
        [self.timer invalidate];
        self.timer=nil;
    }
    self.imageView2=nil;
    self.imageView1=nil;
    self.imageView3=nil;
    self.messageArray=nil;
    self.detailArray=nil;
    [super dealloc];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *image1=[UIImage imageNamed:@"white_box.png"];
    image1=[image1 stretchableImageWithLeftCapWidth:image1.size.width/2 topCapHeight:image1.size.height/2];
    
    self.bgImageView.image=image1;
    
    [self.activity startAnimating];
    [self.detectActivity startAnimating];

    UIImage *image=[UIImage imageNamed:@"wangge.png"];
    self.wangGeImageView.backgroundColor=[UIColor colorWithPatternImage:image] ;
    self.wangGeImageView.opaque=NO;
    // self.wangGeImageView.image=image;
    
    self.timer=[NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(timerHandle) userInfo:nil repeats:YES];
    
    
    self.viewArray=[[[NSArray alloc]initWithObjects:self.imageView1,self.imageView2,self.imageView3 ,nil]autorelease];
    self.messageArray=[NSArray arrayWithObjects:@"正在进行流量检测...",@"正在进行压缩服务设置检测...",@"正在进行应用使用检测...", nil];
    self.detailArray=[NSArray arrayWithObjects:@"检测本机套餐流量...",@"检测压缩服务设置情况...",@"检测应用使用情况...", nil];
    
}
#pragma mark -detection
-(void)timerHandle
{
    if(index>=[self.viewArray count])
    {
        [self.detectActivity stopAnimating];
        [self.activity stopAnimating];
        [self.activity setHidden:YES];
        [self.timer invalidate];
        [self loadNextController];
        self.timer=nil;
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
    self.titleLabel.text=[self.messageArray objectAtIndex:index];
    self.messageLabel.text=[self.detailArray objectAtIndex:index];
    index++;
    
}
-(void)loadNextController
{
    TrafficOptimizationViewController*trafficOptimizationViewController=[[[TrafficOptimizationViewController alloc]init] autorelease];
    trafficOptimizationViewController.controller=self.controller;
    [[sysdelegate currentViewController].navigationController pushViewController:trafficOptimizationViewController animated:YES];
}
-(IBAction)turnBtnPress:(id)sender
{
    if(timer)
    {
        [self.timer invalidate];
        self.timer=nil;
    }
    [[sysdelegate currentViewController].navigationController popViewControllerAnimated:YES];
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
