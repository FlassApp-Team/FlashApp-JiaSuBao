//
//  ShareWeiBoViewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-19.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import "ShareWeiBoViewController.h"
#include <Quartzcore/Quartzcore.h>
#import "ShareToSNSViewController.h"
#import "OpenUDID.h"
@interface ShareWeiBoViewController ()
- (void) shareToSNS:(NSString*)sns;
- (void) sendWeixin:(enum WXScene)scene text:(NSString*)text;
@end

@implementation ShareWeiBoViewController
@synthesize backView;
@synthesize sinaBtn;
@synthesize renrenBtn;
@synthesize weixinBtn;
@synthesize TXBtn;
@synthesize imageView;
-(void)dealloc
{
    self.imageView=nil;
    self.TXBtn=nil;
    self.backView=nil;
    self.sinaBtn=nil;
    self.weixinBtn=nil;
    self.renrenBtn=nil;
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
    self.view.frame=CGRectMake(0, 0, __MainScreenFrame.size.width,  __MainScreenFrame.size.height);

    UIImage* img=[UIImage imageNamed:@"sharelong.png"];
    img=[img stretchableImageWithLeftCapWidth:48 topCapHeight:21];
    
//    UIImage* img1=[UIImage imageNamed:@"shareweibo.png"];
//    img1=[img1 stretchableImageWithLeftCapWidth:80 topCapHeight:80];
//    
//    self.imageView.image=img1;
    self.sinaBtn.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [self.sinaBtn setBackgroundImage:img forState:UIControlStateNormal];
    [self.TXBtn setBackgroundImage:img forState:UIControlStateNormal];
    [self.weixinBtn setBackgroundImage:img forState:UIControlStateNormal];
    [self.renrenBtn setBackgroundImage:img forState:UIControlStateNormal];

    // Do any additional setup after loading the view from its nib.
}
-(IBAction)cancleBtn:(id)sender
{
    [self.view removeFromSuperview];
}
-(void)share:(NSString *)sns
{
    Reachability* reachablity = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reachablity currentReachabilityStatus];
    if (  status == NotReachable ) {
        [AppDelegate showAlert:@"网络连接异常,请链接网络"];
        return;
    }
    UIViewController* controller = [[AppDelegate getAppDelegate] currentViewController];
    
    if ( [controller respondsToSelector:@selector(shareToSNS:)]) {
        [controller performSelector:@selector(shareToSNS:) withObject:sns afterDelay:0.3f];
    }
    else
    {
        [self shareToSNS:sns];
    }
    [self.view removeFromSuperview];

}
-(IBAction)sinaBtnPress:(id)sender
{
    [self share:@"sinaWeibo"];
}
-(IBAction)TXBtnPress:(id)sender
{
    [self share:@"QQWeibo"];

}
-(IBAction)renrenBtnPress:(id)sender
{
    [self share:@"renren"];

}
-(IBAction)weixinBtnPress:(id)sender
{
    Reachability* reachablity = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reachablity currentReachabilityStatus];
    if (  status == NotReachable ) {
        [AppDelegate showAlert:@"网络连接异常,请链接网络"];
        return;
    }

    UIViewController* controller = [[AppDelegate getAppDelegate] currentViewController];
    if ( [controller respondsToSelector:@selector(sendWeixinImage)]) {
        [controller performSelector:@selector(sendWeixinImage) withObject:nil afterDelay:0.3f];
    }
    else
    {
        [self sendWeixin:WXSceneSession text:NSLocalizedString(@"sendMail.text",nil)];
    }
    [self.view removeFromSuperview];
}

#pragma mark - Share Methods
- (void) shareToSNS:(NSString*)sns
{

    //NSString* deviceId = [OpenUDID value];
    NSString* snsText =  NSLocalizedString(@"sendMail.text",nil);
    NSString* content = [NSString stringWithFormat:@"%@%@",snsText,@"http://p.flashapp.cn/"];
    
   // NSData* image = [self captureScreen];
    
    ShareToSNSViewController * controller = [[ShareToSNSViewController alloc] init];
    controller.sns = sns;
    controller.content = content;
    controller.imageName = @"file";
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [[[AppDelegate getAppDelegate] navController] presentModalViewController:nav animated:YES];
    [controller release];
    [nav release];
}



- (void) sendWeixin:(enum WXScene)scene text:(NSString*)text
{
    if([WXApi isWXAppInstalled ])
    {
        SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
        req.bText = YES;
        req.text = text;
        req.scene = scene;
        [WXApi sendReq:req];
    }
    else
    {
        UIAlertView *alertView=[[[UIAlertView alloc]initWithTitle:@"提示信息" message:@"未安装微信客户端,分享失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]autorelease ];
        [alertView show];
    }
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
