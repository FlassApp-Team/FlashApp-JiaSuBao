//
//  ZhengDuanModleViewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-26.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import "ZhengDuanModleViewController.h"
#import "ZhenDuanViewController.h"
//#import "HelpNetBadViewController.h"
@interface ZhengDuanModleViewController ()

@end

@implementation ZhengDuanModleViewController
@synthesize zhenduanBtn;
-(void)dealloc
{
    self.zhenduanBtn=nil;
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
    self.zhenduanBtn.controller=self;
    // Do any additional setup after loading the view from its nib.
}
-(void)nextContorller
{
    self.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    UIView *view=(UIView*)[self.view viewWithTag:101];
    [view removeFromSuperview];
    ConnectionType type = [UIDevice connectionType];
    UserSettings* user = [AppDelegate getAppDelegate].user;
    if ( user.proxyFlag == INSTALL_FLAG_NO )
    {
        [AppDelegate showAlert:@"提示信息" message:@"压缩服务未启用,请开启服务"];
        return;
    }
    if ( type != CELL_2G && type != CELL_3G && type != CELL_4G )
    {
       // NSLog(@"请关闭wifi来获取最佳的诊断效果");

        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"诊断"
                                                            message:@"请关闭WIFI,确保网络连接正常,以获得最佳的测试效果."
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        alertView.tag=103;
        [alertView show];
        [alertView release];
    }
    else
    {
        ZhenDuanViewController*zhenDuanViewController=[[[ZhenDuanViewController alloc]init] autorelease];
        [[sysdelegate navController  ] pushViewController:zhenDuanViewController animated:YES];
    }


    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
