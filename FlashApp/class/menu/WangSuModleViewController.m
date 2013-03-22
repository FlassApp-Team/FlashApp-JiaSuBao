//
//  WangSuModleViewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-26.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import "WangSuModleViewController.h"
#import "WangSuViewController.h"
@interface WangSuModleViewController ()

@end

@implementation WangSuModleViewController
@synthesize wangsuBtn;
-(void)dealloc
{
    self.wangsuBtn=nil;
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
    self.wangsuBtn.controller=self;
    // Do any additional setup after loading the view from its nib.
}
-(void)nextContorller
{
    ConnectionType type = [UIDevice connectionType];
    
    
    UserSettings* user = [AppDelegate getAppDelegate].user;

    if ( user.proxyFlag == INSTALL_FLAG_NO )
    {
        [AppDelegate showAlert:@"提示信息" message:@"压缩服务未启用,请开启服务"];
        return;
    }
    
    if ( type != CELL_2G && type != CELL_3G && type != CELL_4G )
    {

        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"网速优化"
                                                            message:@"加速宝要根据移动网络实测选择最佳压缩加速机房,请您关闭wifi,确保移动网络为开启状态"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        alertView.tag=103;
        [alertView show];
        [alertView release];       
    }
    else
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"网速优化"
                                                            message:@"根据你的网络实测,为你选择最佳的加速宝服务器,测速所需0.3KB流量"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定",nil];
        alertView.tag=104;
        [alertView show];
        [alertView release];
    }


}
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    UIView *view=(UIView*)[self.view viewWithTag:101];
    [view removeFromSuperview];
    if ( alertView.tag == 103 )
    {
        
    }
    else
    {
        if(buttonIndex==1)
        {
            WangSuViewController*wangSuViewController=[[[WangSuViewController alloc]init] autorelease];
            [[sysdelegate navController  ] pushViewController:wangSuViewController animated:YES];
        }

    }
}
-(IBAction)wangsuBtnPress:(id)sender
{

   
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
