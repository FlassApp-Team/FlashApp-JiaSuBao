//
//  LoginNewViewController.m
//  flashapp
//
//  Created by Qi Zhao on 12-7-28.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import "LoginNewViewController.h"
//#import "RegisterNewViewController.h"
//#import "ForgotPasswdViewController.h"
#import "SNSLoginViewController.h"
#import "AppDelegate.h"
#import "StringUtil.h"
#import "OpenUDID.h"
#import "UserSettings.h"
#import "NSString+SBJSON.h"
#import "MBProgressHUD.h"


#define TAG_BG_IMAGEVIEW 101
#define TAG_SCROLLVIEW 102

@interface LoginNewViewController ()

@end

@implementation LoginNewViewController
TencentOAuth *tencentOAuth;

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
    
    MBProgressHUD *loginHUD = [[MBProgressHUD alloc] initWithView:self.view];
    loginHUD.tag = 101010;
    loginHUD.labelText = @"正在登陆请稍后...";
    [self.view addSubview:loginHUD];
    [loginHUD release];

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
    thirdType = @"QQ";
    NSArray *permissions = [NSArray arrayWithObjects:@"get_simple_userinfo",@"",@"add_share" ,@"add_t", nil];
    tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"100379557" andDelegate:self];
    [tencentOAuth authorize:permissions inSafari:NO];
}

- (void) loginByBaidu
{
    [self loginSNS:@"baidu"];
}


- (void) loginByWangyiweibo
{
    [self loginSNS:@"wangyiWeibo"];
}


- (void) afterLogin
{
    UINavigationController* nav = [[AppDelegate getAppDelegate] navController];
    if ( nav == self.navigationController ) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
        [nav dismissModalViewControllerAnimated:YES];
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登陆成功" message:@"恭喜您登陆成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
    [alertView release];
}

- (NSString *)addcChlAndrdAndCodeAndVer:(NSString *)urlStr requestTypeDic:(NSDictionary *)dic
{
    //随机数
    int rd = ((float) rand()) / RAND_MAX * 10000;
    
    NSString* deviceId = [OpenUDID value];
    //MD5加密
    NSString* s = [NSString stringWithFormat:@"%@%@%@%@%@%d", deviceId, CHANNEL, [dic objectForKey:@"snsid"],[dic objectForKey:@"snstype"], API_KEY,rd ];
    //MD5加密
    NSString* code = [s md5HexDigest];
    
    //生成新的url
    NSString *newUrl = [NSString stringWithFormat:@"%@&chl=%@&rd=%d&code=%@&ver=%@",urlStr,CHANNEL,rd,code,API_VER];
    
    return newUrl;
}

- (void)startThirdLoginRequest:(NSDictionary *)loginDic
{        
    NSString *urlString = [NSString stringWithFormat:@"http://p.flashapp.cn/api/users/registsns.json?appid=%d&deviceId=%@&nickname=%@&snsid=%@&snstype=%@&token=%@",APP_ID,[OpenUDID value],[loginDic objectForKey:@"nickname"],[loginDic objectForKey:@"snsid"],[loginDic objectForKey:@"snstype"],[loginDic objectForKey:@"token"]];
    urlString = [self addcChlAndrdAndCodeAndVer:urlString requestTypeDic:loginDic];
        
    NSString *newURL = (NSString*)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)urlString, (CFStringRef)@"%", NULL, kCFStringEncodingUTF8);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:newURL]];
    [request setTimeOutSeconds:10];
    [request setNumberOfTimesToRetryOnTimeout:2];
    [request setCompletionBlock:^{
        NSString *responseString =  [request responseString];
        NSRange rangOK = [responseString rangeOfString:@"200"];
        if (rangOK.length > 0 ) {
             NSLog(@"responseString  is ok  %@",responseString);
        }else{
            
        }
       
    }];
    [request startAsynchronous];
}

#pragma mark - TencentOAuthDelegate
/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin
{
    if (tencentOAuth.accessToken !=nil && 0 != tencentOAuth.accessToken) {
        
        MBProgressHUD *loginHUD ;
        for (UIView *view in  [self.view subviews] ) {
            if (view.tag == 101010) {
                loginHUD = (MBProgressHUD *)view;
            }
        }
        [loginHUD show:YES];
        
        [tencentOAuth getUserInfo];
        
        //分享
//        TCAddShareDic *shareDic = [TCAddShareDic dictionary];
//        shareDic.paramTitle = @"分享加速宝测试";
//        shareDic.paramUrl = @"http://www.flashapp.cn";
//        shareDic.paramComment = @"加速的哦";//分享理由
//        shareDic.paramSummary = @"网速慢，流量少！就用加速宝";//分享摘要
//        [tencentOAuth addShareWithParams:shareDic];
        
        //记录下accessToken
        [[NSUserDefaults standardUserDefaults] setObject:tencentOAuth.accessToken forKey:QQ_LOGIN_ACCESSTOKEN];
        [[NSUserDefaults standardUserDefaults] setObject:tencentOAuth.openId forKey:QQ_LOGIN_OPENID];
        [[NSUserDefaults standardUserDefaults] setObject:tencentOAuth.expirationDate forKey:QQ_LOGIN_BACKTIME];
    }
}

- (void)startThirdLoginRequestWithServer
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:3];
    NSString *urlString = [NSString stringWithFormat:@"http://%@",@"qq"];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [request setCompletionBlock:^{
        NSString *responseStr = [request responseString];
        [dic setDictionary:[responseStr JSONValue]];
    }];
    NSLog(@"dic is ====+++++=====+++++ %@",dic);
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"退出登录" message:@"您取消了登陆" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"登陆失败，您检查用户名、密码。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        [alertView release];
    }
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登陆异常" message:@"您的网络似乎有问题，请检查网络后con登陆。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
    [alertView release];
}

#pragma mark - TencentSessionDelegate
/**
 * 退出登录的回调
 */
- (void)tencentDidLogout
{
    
}

/**
 * 获取用户个人信息回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/getUserInfoResponse.exp success
 *          错误返回示例: \snippet example/getUserInfoResponse.exp fail
 */
- (void)getUserInfoResponse:(APIResponse*) response
{
    MBProgressHUD *loginHUD ;
    for (UIView *view in  [self.view subviews] ) {
        if (view.tag == 101010) {
            loginHUD = (MBProgressHUD *)view;
        }
    }
    [loginHUD hide:YES];
    
    if (response.retCode == URLREQUEST_SUCCEED) {
        UserSettings* user = [AppDelegate getAppDelegate].user;
        user.username = [tencentOAuth openId];
        user.nickname = [response.jsonResponse objectForKey:@"nickname"];
        [UserSettings saveUserSettings:user];
        
        NSString *qqheadImgURL = [response.jsonResponse objectForKey:@"figureurl_qq_1"];
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:qqheadImgURL]];
        [request setCompletionBlock:^{
            user.headImageData = [request responseData];
            [UserSettings saveUserSettings:user];
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshLoginNotification object:nil];
        }];
        [request startAsynchronous];
        
        //请求服务器将数据传递给后台接口
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[response.jsonResponse objectForKey:@"nickname"],@"nickname",tencentOAuth.openId,@"snsid",thirdType,@"snstype",tencentOAuth.accessToken,@"token" ,nil];
        [self startThirdLoginRequest:dic];
    }
    
    [self performSelector:@selector(afterLogin) withObject:nil];
}

/**
 * 分享到QZone回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/addShareResponse.exp success
 *          错误返回示例: \snippet example/addShareResponse.exp fail
 */
- (void)addShareResponse:(APIResponse*) response
{
    if (response.retCode == URLREQUEST_SUCCEED) {
        NSLog(@"RESPONSE DIC IS = %@",response.jsonResponse);
    }
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
