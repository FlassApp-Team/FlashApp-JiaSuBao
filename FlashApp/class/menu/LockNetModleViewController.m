//
//  LockNetModleViewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-26.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import "LockNetModleViewController.h"
#import "LockNetWorkViewController.h"
#import "UserAgentLockDAO.h"
@interface LockNetModleViewController ()
- (void) loadData;
@end

@implementation LockNetModleViewController
@synthesize suowangBtn;
@synthesize lockAppCountLabel;
-(void)dealloc
{
    self.lockAppCountLabel=nil;
    self.suowangBtn=nil;
    
    
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
    self.suowangBtn.controller=self;
   // self.lockAppCountLabel.font = [UIFont fontWithName:@"count" size:44.0];

    [self loadData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:RefreshAppLockedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:RefreshNotification object: nil];
    // Do any additional setup after loading the view from its nib.
}
-(void)loadData
{
    NSDictionary*allLockDic = [UserAgentLockDAO getAllLockedApps ];
    int count=[allLockDic count];
    self.lockAppCountLabel.text=[NSString stringWithFormat:@"%d",count];
}
-(void)nextContorller
{
    self.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    UIView *view=(UIView*)[self.view viewWithTag:101];
    [view removeFromSuperview];
    ConnectionType type = [UIDevice connectionType];
    if(type==NONE)
    {
        [AppDelegate showAlert:@"提示信息" message:@"网络连接异常,请链接网络"];
        return;
    }
    LockNetWorkViewController*lockNetWorkViewController=[[[LockNetWorkViewController alloc]init] autorelease];
    [[sysdelegate navController  ] pushViewController:lockNetWorkViewController animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
