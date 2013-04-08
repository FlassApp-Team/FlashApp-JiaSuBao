//
//  SecondPageViewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-13.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import "SecondPageViewController.h"
#include <Quartzcore/Quartzcore.h>
#import "AppDelegate.h"
#import "ImageModleViewController.h"
#import "WangSuModleViewController.h"
#import "LockNetModleViewController.h"
#import "ZhengDuanModleViewController.h"
#import "wenTiModleViewController.h"
#import "TellFriendModleViewController.h"
@interface SecondPageViewController ()
-(void)initViewController;
@end

@implementation SecondPageViewController


@synthesize imageModleViewController;
@synthesize wangSuModleViewController;
@synthesize lockNetModleViewController;
@synthesize zhengDuanModleViewController;
@synthesize wenTiModleViewController;
//@synthesize tellFriendModleViewController;
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

    self.imageModleViewController=nil;
    self.wangSuModleViewController=nil;
    
    self.lockNetModleViewController=nil;
   // self.tellFriendModleViewController=nil;
    self.zhengDuanModleViewController=nil;
    self.wenTiModleViewController=nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initViewController];
    // Do any additional setup after loading the view from its nib.
}
-(void)initViewController
{
    if(iPhone5)
    {
        self.lockNetModleViewController=[[[LockNetModleViewController alloc]initWithNibName:@"LockNetModleViewController_iphone5" bundle:nil] autorelease];
        [self.view addSubview:self.lockNetModleViewController.view];
        self.lockNetModleViewController.view.frame=CGRectMake(17, 90, self.lockNetModleViewController.view.frame.size.width, self.lockNetModleViewController.view.frame.size.height);
        
        
        self.wangSuModleViewController=[[[WangSuModleViewController alloc]initWithNibName:@"WangSuModleViewController_iphone5" bundle:nil] autorelease];

        [self.view addSubview:self.wangSuModleViewController.view];
        self.wangSuModleViewController.view.frame=CGRectMake(152, 90, self.wangSuModleViewController.view.frame.size.width, self.wangSuModleViewController.view.frame.size.height);
        
        
        
        self.zhengDuanModleViewController=[[[ZhengDuanModleViewController alloc]initWithNibName:@"ZhengDuanModleViewController_iphone5" bundle:nil] autorelease];

        [self.view addSubview:self.zhengDuanModleViewController.view];
        self.zhengDuanModleViewController.view.frame=CGRectMake(17, 234, self.zhengDuanModleViewController.view.frame.size.width, self.zhengDuanModleViewController.view.frame.size.height);
        
        
        self.imageModleViewController=[[[ImageModleViewController alloc]initWithNibName:@"ImageModleViewController_iphone5" bundle:nil] autorelease];

        [self.view addSubview:self.imageModleViewController.view];
        self.imageModleViewController.view.frame=CGRectMake(152, 234, self.imageModleViewController.view.frame.size.width, self.imageModleViewController.view.frame.size.height);
        
        
        //常见问题
//        self.wenTiModleViewController=[[[WenTiModleViewController alloc]initWithNibName:@"WenTiModleViewController_iphone5" bundle:nil] autorelease];
//        [self.view addSubview:self.wenTiModleViewController.view];
//        self.wenTiModleViewController.view.frame=CGRectMake(17, 376, self.wenTiModleViewController.view.frame.size.width, self.wenTiModleViewController.view.frame.size.height);

    }
    else
    {
        self.lockNetModleViewController=[[[LockNetModleViewController alloc]init] autorelease];
        [self.view addSubview:self.lockNetModleViewController.view];
        self.lockNetModleViewController.view.frame=CGRectMake(17, 53, self.lockNetModleViewController.view.frame.size.width, self.lockNetModleViewController.view.frame.size.height);
        
        
        self.wangSuModleViewController=[[[WangSuModleViewController alloc]init] autorelease];
        [self.view addSubview:self.wangSuModleViewController.view];
        self.wangSuModleViewController.view.frame=CGRectMake(149, 53, self.wangSuModleViewController.view.frame.size.width, self.wangSuModleViewController.view.frame.size.height);
        
        
        
        self.zhengDuanModleViewController=[[[ZhengDuanModleViewController alloc]init] autorelease];
        [self.view addSubview:self.zhengDuanModleViewController.view];
        self.zhengDuanModleViewController.view.frame=CGRectMake(17, 182, self.zhengDuanModleViewController.view.frame.size.width, self.zhengDuanModleViewController.view.frame.size.height);
        
        
        self.imageModleViewController=[[[ImageModleViewController alloc]init] autorelease];
        [self.view addSubview:self.imageModleViewController.view];
        self.imageModleViewController.view.frame=CGRectMake(149, 182, self.imageModleViewController.view.frame.size.width, self.imageModleViewController.view.frame.size.height);
        
        //常见问题
//        self.wenTiModleViewController=[[[WenTiModleViewController alloc]init] autorelease];
//        [self.view addSubview:self.wenTiModleViewController.view];
//        self.wenTiModleViewController.view.frame=CGRectMake(17, 311, self.wenTiModleViewController.view.frame.size.width, self.wenTiModleViewController.view.frame.size.height);

    }
   //    
//    self.tellFriendModleViewController=[[[TellFriendModleViewController alloc]init] autorelease];
//    [self.view addSubview:self.tellFriendModleViewController.view];
//    self.tellFriendModleViewController.view.frame=CGRectMake(20, 311, self.tellFriendModleViewController.view.frame.size.width, self.tellFriendModleViewController.view.frame.size.height);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
