//
//  GoLineModleViewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-26.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import "GoLineModleViewController.h"
#import "WiFiSpeedViewController.h"
#import "NetworkSpeedViewController.h"
#import "TCUtils.h"
#import "TwitterClient.h"
@interface GoLineModleViewController ()

@end

@implementation GoLineModleViewController
@synthesize netWorkBtn;
@synthesize warningBtn;
@synthesize warningLabel;
@synthesize warningView;
@synthesize normalView;
@synthesize wigiView;

@synthesize wifiBtn;
@synthesize wifiLabel;
@synthesize flag;
@synthesize golingMessLabel;
@synthesize speedLabel;
@synthesize persentLabel;
@synthesize wigiTitleLabel;
-(void)dealloc
{
    self.wigiTitleLabel=nil;
self.golingMessLabel=nil;
    self.wifiBtn=nil;
    self.wifiLabel=nil;
    self.wigiView=nil;
    self.normalView=nil;
    self.warningLabel=nil;
    self.warningView=nil;
    self.warningBtn=nil;
    self.persentLabel=nil;
    self.speedLabel=nil;
    self.netWorkBtn=nil;
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
    //[self performSelector:@selector(loadAndShowData) withObject:nil afterDelay:0.0];
    self.netWorkBtn.controller=self;
    self.wifiBtn.controller=self;
    self.warningBtn.controller=self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judegServerOpen) name:RefreshNotification object: nil];
  //  self.speedLabel.font = [UIFont fontWithName:@"count" size:44.0];

//    [self judegServerOpen];
    // Do any additional setup after loading the view from its nib.
}
//-(void)loadAndShowData
//{
//    [self check];
//}

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
    if(flag==101)
    {
        WiFiSpeedViewController*wiFiSpeedViewController=[[[WiFiSpeedViewController alloc]init] autorelease];
        [[sysdelegate navController  ] pushViewController:wiFiSpeedViewController animated:YES];
    }
    else if (flag==102)
    {
        NetworkSpeedViewController*networkSpeedViewController=[[[NetworkSpeedViewController alloc]init] autorelease];
        networkSpeedViewController.controller=self;
        [[sysdelegate navController  ] pushViewController:networkSpeedViewController animated:YES];

    }
    else
    {
        if ([CHANNEL compare:@"appstore"] == NSOrderedSame) {
            [AppDelegate installProfile:nil vpn:nil];
        }
        else{
            [AppDelegate installProfile:nil apn:nil];
        }
    }
}
-(void)judegServerOpen
{
    [self.wigiView setHidden:NO];
    [self.warningView setHidden:NO];
    [self.normalView setHidden:NO];
    UserSettings* user = [UserSettings currentUserSettings];
    self.speedLabel.text=[UserSettings getJiasuApeed];
    [AppDelegate setLabelFrame:self.speedLabel label2:self.persentLabel];
    self.flag=0;
    //self.flag=101;
    ConnectionType type = [UIDevice connectionType];
    
    if ( type ==WIFI )
    {
        [self.normalView setHidden:YES];
        [self.warningView setHidden:YES];
        [self.wigiView setHidden:NO];
        self.wigiTitleLabel.text=@"WIFI测速";
        self.wifiLabel.text=@"暂停压缩加速服务 \n点击测速";

        self.flag=101;
    }
    else if(type!=NONE)
    {
        if ( user.proxyFlag == INSTALL_FLAG_NO )
        {
            [self.normalView setHidden:YES];
            [self.wigiView setHidden:YES];
            [self.warningView setHidden:NO];
            self.warningLabel.text=@"已连接到2G/3G开启服务";
           // controller=nil;
        }
        else
        {
            [self.normalView setHidden:NO];
            [self.warningView setHidden:YES];
            [self.wigiView setHidden:YES];
            [self.speedLabel setHidden:YES];
            [self.persentLabel setHidden:YES];
            

            self.flag=102;
        }
    }
    else
    {
        if ( user.proxyFlag == INSTALL_FLAG_YES )
        {
            [self.normalView setHidden:YES];
            [self.warningView setHidden:YES];
            [self.wigiView setHidden:NO];
            self.wigiTitleLabel.text=@"网络异常";
            self.wifiLabel.text=@"网络连接异常,请检查网络设置";
        }

    }
    if(!user.jiasuSpeed||user.jiasuSpeed.length==0)
    {
        [self.speedLabel setHidden:YES];
        [self.persentLabel setHidden:YES ];
        [self.golingMessLabel setHidden:NO];
    }
    else
    {
        [self.speedLabel setHidden:NO];
        [self.persentLabel setHidden:NO ];
        [self.golingMessLabel setHidden:YES];
    }


}

#pragma mark - check methods

//- (void) check
//{
////    iconImageView.hidden = YES;
////    indicatorView.hidden = NO;
////    [indicatorView startAnimating];
////    resultLabel.text = @"正在检测压缩服务是否开启...";
//    
//    [self checkReachable];
//}
//
//
//- (void) checkReachable
//{
//    //检测网络
//    Reachability* networkReachablity = [Reachability reachabilityWithHostName:P_HOST];
//    if ( [networkReachablity currentReachabilityStatus] == NotReachable ) {
//       // [self showResult:NO msg:@"连接不上飞速压缩服务器"];
//        return;
//    }
//    
//    //测试是否安装了profile
//    [self checkProfile];
//}
//
//
//- (void) checkProfile
//{
//    NSInvocationOperation* operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getAccesslog) object:nil];
//    
//    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
//    queue.maxConcurrentOperationCount = 1;
//    [queue addOperation:operation];
//    
//}
//
//
//- (void) getAccesslog
//{
//    [TCUtils readIfData:-1];
//    [TwitterClient getStatsData];
//    [self performSelectorOnMainThread:@selector(finishCheck) withObject:nil waitUntilDone:NO];
//    [self judegServerOpen];
//   // [[NSNotificationCenter defaultCenter] postNotificationName:RefreshNotification object:nil];
//}
//
//
////- (void) showResult:(BOOL)result msg:(NSString*)msg
////{
////    [indicatorView stopAnimating];
////    indicatorView.hidden = YES;
////    iconImageView.hidden = NO;
////    if ( result ) {
////        iconImageView.image = [UIImage imageNamed:@"icon_ok.png"];
////    }
////    else {
////        iconImageView.image = [UIImage imageNamed:@"icon_!.png"];
////    }
////    
////    resultLabel.text = msg;
////}
//
//
//- (void) finishCheck
//{
//    InstallFlag flag = [AppDelegate getAppDelegate].user.proxyFlag;
//    [self judegServerOpen];
////    if ( flag == INSTALL_FLAG_NO ) {
////        [self showResult:NO msg:@"您的压缩服务未启用"];
////       // openServiceButton.hidden = NO;
////    }
////    else {
////        [self showResult:YES msg:@"压缩服务工作正常"];
////       // openServiceButton.hidden = YES;
////    }
//}
//
//
//#pragma mark - helper methods
//
//
//- (void) installProfile
//{
//    [AppDelegate installProfile:@"current"];
//}
//

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
