//
//  YouHuaModleViewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-26.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import "YouHuaModleViewController.h"
#import "DetectionViewController.h"
@interface YouHuaModleViewController ()

@end

@implementation YouHuaModleViewController
@synthesize traOpBtn;
@synthesize messageLabel;

@synthesize jieshengCountStr;
@synthesize titleLabel;
@synthesize bigIconImageView;
@synthesize smallIconImageView;
-(void)dealloc
{
    self.titleLabel=nil;
    self.bigIconImageView=nil;
    self.smallIconImageView=nil;
    self.messageLabel=nil;
    self.traOpBtn=nil;
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
    self.traOpBtn.controller=self;
    [self showMessage];
    // Do any additional setup after loading the view from its nib.
}
-(void)nextContorller
{
    self.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    UIView *view=(UIView*)[self.view viewWithTag:101];
    [view removeFromSuperview];
    ConnectionType type = [UIDevice connectionType];
    if(type==NONE)
    {
        [AppDelegate showAlert:@"提示信息" message:@"网络连接异常,请连接网络"];
        return;
    }
    UserSettings* user = [AppDelegate getAppDelegate].user;
    if ( user.proxyFlag == INSTALL_FLAG_NO )
    {
        [AppDelegate showAlert:@"提示信息" message:@"压缩服务未启用,请开启服务"];
        return;
    }
    DetectionViewController*detectionViewController=[[[DetectionViewController alloc]init] autorelease];
    detectionViewController.controller=self;
    [[sysdelegate navController  ] pushViewController:detectionViewController animated:YES];

}
-(void)showMessage
{
    NSUserDefaults*userDefault=[NSUserDefaults standardUserDefaults];
    jieshengCountStr=[[userDefault objectForKey:@"youhuaAPPCount"] intValue];
    if(!jieshengCountStr)
    {
        [self.bigIconImageView setHidden:YES ];
        [self.messageLabel setHidden:NO ];
        [self.smallIconImageView setHidden:NO];
        [self.titleLabel setHidden:NO];
        if(iPhone5)
        {
            self.titleLabel.frame=CGRectMake(41, 13, 83, 36);

        }
        else
            self.titleLabel.frame=CGRectMake(38, 6, 83, 36);

    }
    else
    {
        [self.bigIconImageView setHidden:NO ];
        [self.messageLabel setHidden:YES ];
        [self.smallIconImageView setHidden:YES];
        [self.titleLabel setHidden:NO];
        if(iPhone5)
            self.titleLabel.frame=CGRectMake(28, 87, 83, 36);
        else
            self.titleLabel.frame=CGRectMake(25, 79, 83, 36);
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
