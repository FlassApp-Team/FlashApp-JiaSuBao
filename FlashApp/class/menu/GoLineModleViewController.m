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
#import "ViewController.h"
#import "OpenServeViewController.h"

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
    
    [self judegServerOpen];
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
    UserSettings *user = [UserSettings currentUserSettings];
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
        if ([user.profileType isEqualToString:@"vpn"] ) {
            
            //iOS 5.1+ 以后不可以用
//            NSURL*url=[NSURL URLWithString:@"prefs:root=General&path=Network/VPN"];
//            [[UIApplication sharedApplication] openURL:url];
            
            OpenServeViewController *openSCV = [[OpenServeViewController alloc] init];
            [[sysdelegate navController  ] pushViewController:openSCV animated:YES];
            [openSCV release];
            
        }else{
            
                [AppDelegate installProfile:nil vpnn:nil interfable:@"0"];
            
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
        [self.normalView setHidden:YES];
        [self.warningView setHidden:YES];
        [self.wigiView setHidden:NO];
        
        self.wigiTitleLabel.text=@"网络异常";
        self.wifiLabel.text=@"网络连接异常,请检查网络设置";

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
