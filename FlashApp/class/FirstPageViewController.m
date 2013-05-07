//
//  FirstPageViewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-13.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import "FirstPageViewController.h"
#import "AppDelegate.h"
#import "TaoCanModleViewController.h"
#import "YouHuaModleViewController.h"
#import "TuiJianModleViewController.h"
#import "GoLineModleViewController.h"
#import "ModleOneViewController.h"
#import "TellFriendModleViewController.h"
@interface FirstPageViewController ()
-(void)initViewControll;
@end

@implementation FirstPageViewController


@synthesize modleOneViewController;
@synthesize taoCanModleViewController;
@synthesize tuiJianModleViewController;
@synthesize tellFriendModleViewController;
@synthesize goLineModleViewController;
@synthesize youHuaModleViewController;
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
       
    self.modleOneViewController=nil;
    self.taoCanModleViewController=nil;
    self.goLineModleViewController=nil;
    self.youHuaModleViewController=nil;
    self.tellFriendModleViewController=nil;
    self.tuiJianModleViewController=nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initViewControll];

   // [self initLabel];
    // Do any additional setup after loading the view from its nib.
}
-(void)initViewControll
{
    
    if(iPhone5)
    {
        self.modleOneViewController=[[[ModleOneViewController alloc]initWithNibName:@"ModleOneViewController_iphone5" bundle:nil] autorelease];
        [self.view addSubview:self.modleOneViewController.view];
        self.modleOneViewController.view.frame=CGRectMake(17, 90, self.modleOneViewController.view.frame.size.width, self.modleOneViewController.view.frame.size.height);
        NSLog(@"self.modeleeeeeee=%f",self.modleOneViewController.view.frame.size.width);
        
        self.goLineModleViewController=[[[GoLineModleViewController alloc]initWithNibName:@"GoLineModleViewController_iphone5" bundle:nil] autorelease];
        [self.view addSubview:self.goLineModleViewController.view];
        self.goLineModleViewController.view.frame=CGRectMake(152, 90, self.goLineModleViewController.view.frame.size.width, self.goLineModleViewController.view.frame.size.height);
        
        
        
        self.taoCanModleViewController=[[[TaoCanModleViewController alloc]initWithNibName:@"TaoCanModleViewController_iphone5" bundle:nil] autorelease];

        [self.view addSubview:self.taoCanModleViewController.view];
        self.taoCanModleViewController.view.frame=CGRectMake(17, 234, self.taoCanModleViewController.view.frame.size.width, self.taoCanModleViewController.view.frame.size.height);
        
        
        self.youHuaModleViewController=[[[YouHuaModleViewController alloc]initWithNibName:@"YouHuaModleViewController_iphone5" bundle:nil] autorelease];

        [self.view addSubview:self.youHuaModleViewController.view];
        self.youHuaModleViewController.view.frame=CGRectMake(152, 234, self.youHuaModleViewController.view.frame.size.width, self.youHuaModleViewController.view.frame.size.height);
        
        
        self.tuiJianModleViewController=[[[TuiJianModleViewController alloc]initWithNibName:@"TuiJianModleViewController_iphone5" bundle:nil] autorelease];

        [self.view addSubview:self.tuiJianModleViewController.view];
        self.tuiJianModleViewController.view.frame=CGRectMake(17, 376, self.tuiJianModleViewController.view.frame.size.width, self.tuiJianModleViewController.view.frame.size.height);
        
        self.tellFriendModleViewController=[[[TellFriendModleViewController alloc]initWithNibName:@"TellFriendModleViewController_iphone5" bundle:nil] autorelease];
        [self.view addSubview:self.tellFriendModleViewController.view];
        self.tellFriendModleViewController.view.frame=CGRectMake(152, 376, self.tellFriendModleViewController.view.frame.size.width, self.tellFriendModleViewController.view.frame.size.height);
    }
    else
    {
        self.modleOneViewController=[[[ModleOneViewController alloc]init] autorelease];
        [self.view addSubview:self.modleOneViewController.view];
        self.modleOneViewController.view.frame=CGRectMake(17, 53, self.modleOneViewController.view.frame.size.width, self.modleOneViewController.view.frame.size.height);
        
        
        self.goLineModleViewController=[[[GoLineModleViewController alloc]init] autorelease];
        [self.view addSubview:self.goLineModleViewController.view];
        self.goLineModleViewController.view.frame=CGRectMake(149, 53, self.goLineModleViewController.view.frame.size.width, self.goLineModleViewController.view.frame.size.height);
        
        self.taoCanModleViewController=[[[TaoCanModleViewController alloc]init] autorelease];
        [self.view addSubview:self.taoCanModleViewController.view];
        self.taoCanModleViewController.view.frame=CGRectMake(17, 182, self.taoCanModleViewController.view.frame.size.width, self.taoCanModleViewController.view.frame.size.height);
        
        
        self.youHuaModleViewController=[[[YouHuaModleViewController alloc]init] autorelease];
        [self.view addSubview:self.youHuaModleViewController.view];
        self.youHuaModleViewController.view.frame=CGRectMake(149, 182, self.youHuaModleViewController.view.frame.size.width, self.youHuaModleViewController.view.frame.size.height);
        
        
        self.tuiJianModleViewController=[[[TuiJianModleViewController alloc]init] autorelease];
        [self.view addSubview:self.tuiJianModleViewController.view];
        self.tuiJianModleViewController.view.frame=CGRectMake(17, 311, self.tuiJianModleViewController.view.frame.size.width, self.tuiJianModleViewController.view.frame.size.height);
        
        self.tellFriendModleViewController=[[[TellFriendModleViewController alloc]init] autorelease];
        [self.view addSubview:self.tellFriendModleViewController.view];
        self.tellFriendModleViewController.view.frame=CGRectMake(149, 311, self.tellFriendModleViewController.view.frame.size.width, self.tellFriendModleViewController.view.frame.size.height);

    }

    [self hiddenAndChangeViews];
}

/*
 *用来隐藏应用推荐，因为有的渠道审核的时候是不能带有应用推荐这个模块的所以为了审核通过就隐藏掉应用推荐
 */
-(void)hiddenAndChangeViews
{
    UserSettings *user = [UserSettings currentUserSettings];    
    if ([CHANNEL isEqualToString:@"91_market"] && user.rcen == 1 ) {
        CGRect newFrame = self.tuiJianModleViewController.view.frame;
        
        self.tuiJianModleViewController.view.hidden = YES;
        
        self.tellFriendModleViewController.view.frame = newFrame;
    }
}

-(void)initLabel
{
//    self.jieshenLabelTitle.text=NSLocalizedString(nil, @"本月节省");
//    self.golineLabelTitle.text=NSLocalizedString(nil, @"上网加速");
//    self.liuliangLabelTitle.text=NSLocalizedString(nil, @"流量优化");
//    self.liuliangLabelDetail.text=NSLocalizedString(nil, @"压缩服务器刚刚开启使用一段时间即可获得优化建议");
//    self.taocanLabelTitle.text=NSLocalizedString(nil, @"套餐剩余");
//    self.taocanLabelDetail.text=NSLocalizedString(nil, @"本月节省");
//    self.yaoqingLabelDetail.text=NSLocalizedString(nil, @"本月节省");
//    self.tuijianLabelTitle.text=NSLocalizedString(nil, @"本月节省");
//    self.tuijianLabelDetail.text=NSLocalizedString(nil, @"本月节省");

    
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
