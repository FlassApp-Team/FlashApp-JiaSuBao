//
//  LoginNewViewController.m
//  flashapp
//
//  Created by Qi Zhao on 12-7-28.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import "LoginNewViewController.h"
//#import "RegisterNewViewController.h"
//#import "ForgotPasswdViewController.h"
#import "SNSLoginViewController.h"
#import "AppDelegate.h"
#import "StringUtil.h"
#import "OpenUDID.h"


#define TAG_BG_IMAGEVIEW 101
#define TAG_SCROLLVIEW 102

@interface LoginNewViewController ()

@end

@implementation LoginNewViewController

@synthesize sinaButton;
@synthesize renrenButton;
@synthesize qqButton;
@synthesize baiduButton;
@synthesize registerButton;
@synthesize forgotPasswdButton;
@synthesize loginButton;
@synthesize phoneTextField;
@synthesize passwordTextField;
@synthesize TXButton;


@synthesize viewController;
#pragma mark - init & destroy

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) dealloc
{
    [sinaButton release];
    [renrenButton release];
    [qqButton release];
    [baiduButton release];
    [registerButton release];
    [forgotPasswdButton release];
    [loginButton release];
    [phoneTextField release];
    [passwordTextField release];
    self.TXButton =nil;
    self.viewController=nil;
    [super dealloc];
}


#pragma mark - view lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    scrollView = (UIScrollView*) [self.view viewWithTag:TAG_SCROLLVIEW];
    scrollView.contentSize = CGSizeMake(320, 310);
    
    bgImageView = (UIImageView*) [self.view viewWithTag:TAG_BG_IMAGEVIEW];
    bgImageView.image = [[UIImage imageNamed:@"help_ok_bg.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:16];
    
    UIImageView* imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(5, 36, 310, 1)] autorelease];
    imageView.image = [[UIImage imageNamed:@"line.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:0];
    [scrollView addSubview:imageView];
    
    imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(5, 98, 310, 1)] autorelease];
    imageView.image = [[UIImage imageNamed:@"line.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:0];
    [scrollView addSubview:imageView];

    imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(84, 43, 1, 47)] autorelease];
    imageView.image = [[UIImage imageNamed:@"v_line.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:23];
    [scrollView addSubview:imageView];

    imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(154, 43, 1, 47)] autorelease];
    imageView.image = [[UIImage imageNamed:@"v_line.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:23];
    [scrollView addSubview:imageView];

    imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(236, 43, 1, 47)] autorelease];
    imageView.image = [[UIImage imageNamed:@"v_line.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:23];
    [scrollView addSubview:imageView];
    
    UIImage* image = [[UIImage imageNamed:@"blueButton1.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    [loginButton setBackgroundImage:image forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setTitle:@"登    录" forState:UIControlStateNormal];
    
    registerButton.titleUnderlined = YES;
    forgotPasswdButton.titleUnderlined = YES;

    loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(95, 60, 130, 100)];
    loadingView.hidden = YES;
    [self.view addSubview:loadingView];
    [loadingView release];
    
    [self.sinaButton setTitleColor:BgTextColor forState:UIControlStateHighlighted];
    [self.baiduButton setTitleColor:BgTextColor forState:UIControlStateHighlighted];
    [self.renrenButton setTitleColor:BgTextColor forState:UIControlStateHighlighted];
    [self.qqButton setTitleColor:BgTextColor forState:UIControlStateHighlighted];
    [self.TXButton setTitleColor:BgTextColor forState:UIControlStateHighlighted];

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.sinaButton = nil;
    self.renrenButton = nil;
    self.qqButton = nil;
    self.baiduButton = nil;
    self.registerButton = nil;
    self.loginButton = nil;
    self.forgotPasswdButton = nil;
    self.passwordTextField = nil;
    self.phoneTextField = nil;
    self.TXButton=nil;
    if ( client ) {
        [client cancel];
        [client release];
    }
}
-(IBAction)turnBtnPress:(id)sender
{
    [[sysdelegate navController]dismissModalViewControllerAnimated:YES];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - opertion methods

- (IBAction) login:(id)sender
{
    NSString* phone = [phoneTextField.text trim];
    if ( phone.length == 0 ) {
        [AppDelegate showAlert:@"请输入手机号"];
        return;
    }
    
    NSString* passwd = [passwordTextField.text trim];
    if ( passwd.length == 0 ) {
        [AppDelegate showAlert:@"请输入密码"];
        return;
    }
    
    if ( client ) return;
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    
    time_t now;
    time( &now );
    long long currTime = now * 1000LL;
    
    srand( time(0) );
    int rd = ((double) rand() / RAND_MAX) * 10000;
    
    NSString* deviceId = [OpenUDID value];
    NSString* code = [[NSString stringWithFormat:@"%@%@%@%d", deviceId, CHANNEL, API_KEY, rd] md5HexDigest];
    
    loadingView.hidden = NO;
    NSString* url = [NSString stringWithFormat:@"%@/%@.json?deviceId=%@&username=%@&password=%@&startQuantity=%f&shareQuantity=%f&currTime=%lld&chl=%@&rd=%d&code=%@&ver=%@&appid=%d", 
                     API_BASE, API_USER_LOGIN, deviceId, [phone encodeAsURIComponent], [passwd encodeAsURIComponent], 
                     user.dayCapacityDelta, user.monthCapacityDelta, currTime,
                     CHANNEL, rd, code, API_VER,2];
    client = [[TwitterClient alloc] initWithTarget:self action:@selector(didLogin:obj:)];
    [client get:url];
}


- (void) didLogin:(TwitterClient*)cli obj:(NSObject*)obj
{
    loadingView.hidden = YES;
    client = nil;
    
    if ( cli.hasError ) {
        [AppDelegate showAlert:cli.errorMessage];
    }
    else {
        //login & switch view
        NSString* passwd = [passwordTextField.text trim];
        BOOL result = [TwitterClient doLogin:obj passwd:passwd];
        if ( result ) {
            [AppDelegate showAlert:@"您已经成功登录。"];
            [[AppDelegate getAppDelegate] switchUser];
            //[self.navigationController popViewControllerAnimated:YES];
            
            if ( self.navigationController == [[AppDelegate getAppDelegate] navController] ) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else {
                [[[AppDelegate getAppDelegate] navController] dismissModalViewControllerAnimated:YES];
            }
        }
        else {
            [AppDelegate showAlert:@"请输入正确的手机号和密码。"];
        }
    }
}


- (void) doRegister
{
    UINavigationController* nav = [[AppDelegate getAppDelegate] navController];
    if ( self.navigationController == nav ) {
        [nav popViewControllerAnimated:NO];
        [self performSelector:@selector(showRegister:) withObject:@"false" afterDelay:0.1f];
    }
    else {
       // [self showRegister:@"true"];
    }
}


- (void) showRegister:(NSString*)modalMode//add jianfei han 01/16/2013
{
//    UINavigationController* currNav = [[AppDelegate getAppDelegate] navController];
//    if ( [@"false" compare:modalMode] == NSOrderedSame ) {
//        RegisterNewViewController* controller = [[RegisterNewViewController alloc] init];
//        [currNav pushViewController:controller animated:YES];
//        [controller release];
//    }
//    else {
//        RegisterNewViewController* controller = [[RegisterNewViewController alloc] init];
//        controller.showCloseButton = YES;
//        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:controller];
//        [self.navigationController presentModalViewController:nav animated:YES];
//        [controller release];
//        [nav release];
//    }
}


- (void) forgotPassword
{
//    ForgotPasswdViewController* controller = [[ForgotPasswdViewController alloc] init];
//    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:controller];
//    [self.navigationController presentModalViewController:nav animated:YES];
//    [controller release];
//    [nav release];
}


- (void) close
{
    UINavigationController* nav = [[AppDelegate getAppDelegate] navController];
    if ( self.navigationController == nav ) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [nav dismissModalViewControllerAnimated:YES];
    }
}


#pragma mark - sns login methods

- (void) loginSNS:(NSString*)domain
{
    ConnectionType type = [UIDevice connectionType];
    NSString* desc = nil;
    if(type==NONE)
    {
        desc = @"网络连接异常,请链接网络";
        [AppDelegate showAlert:@"提示信息" message:@"网络连接异常,请链接网络"];
        return;
    }
    
    SNSLoginViewController* controller = [[[SNSLoginViewController alloc] init] autorelease];
    controller.domain = domain;
    [self presentModalViewController:controller animated:YES];
    
    //NSLog(@"AAAAAAAAAAAAAAAA%@",[[sysdelegate navController]topViewController]);

}

-(IBAction)loginTX
{
    [self loginSNS:@"QQWeibo"];

}
- (void) loginBySina
{
    [self loginSNS:@"sinaWeibo"];
}


- (void) loginByRenren
{
    [self loginSNS:@"renren"];
}


- (void) loginByQQ
{
    [self loginSNS:@"QQ"];
}


- (void) loginByBaidu
{
    [self loginSNS:@"baidu"];
}


- (void) loginByWangyiweibo
{
    [self loginSNS:@"wangyiWeibo"];
}


#pragma mark - UITextFieldDelegate

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    scrollView.frame = CGRectMake(0, 0, 320, 200);
    scrollView.contentOffset = CGPointMake(0, 100);
    bgImageView.frame = CGRectMake(5, 10, 310, 296);
    return YES;
}


/*
- (void) textFieldDidEndEditing:(UITextField *)textField
{
    scrollView.frame = CGRectMake(0, 0, 320, 416);
    scrollView.contentOffset = CGPointMake(0, 0);
    bgImageView.frame = CGRectMake(5, 10, 310, 296);
}*/

@end
