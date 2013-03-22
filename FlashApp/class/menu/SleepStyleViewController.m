//
//  SleepStyleViewController.m
//  FlashApp
//
//  Created by cai 丽亚 on 13-3-5.
//  Copyright (c) 2013年 lidiansen. All rights reserved.
//

#import "SleepStyleViewController.h"
#import "TwitterClient.h"
#import "OpenUDID.h"
@implementation SleepStyleViewController
@synthesize sleepStyleBtn;
@synthesize sleepStyleLabel;
-(void)dealloc
{
    self.sleepStyleLabel=nil;
    self.sleepStyleLabel=nil;
    if ( twitterClient ) {
        [twitterClient cancel];
        [twitterClient release];
        twitterClient = nil;
    }

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

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sleepStyleBtn.controller=self;
    UserSettings*user=[AppDelegate getAppDelegate].user;
    if(user.sleepStyleFlag)
    {
        self.sleepStyleLabel.text=@"开";
    }
    else
    {
        self.sleepStyleLabel.text=@"关";
    }
    // Do any additional setup after loading the view from its nib.
}
-(void)nextContorller
{
    self.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    UIView *view=(UIView*)[self.view viewWithTag:101];
    [view removeFromSuperview];
    UserSettings*user=[AppDelegate getAppDelegate].user;
    if(user.sleepStyleFlag)
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"是否关闭睡眠模式"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag=101;
        [alertView show];
        [alertView release];
    }
    else
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"是否开启睡眠模式"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag=102;
        [alertView show];
        [alertView release];
    }


    
}
-(void)hiddenLoadingView
{
    UserSettings*user=[AppDelegate getAppDelegate].user;
    if(user.sleepStyleFlag)
    {
        [AppDelegate showAlert:@"睡眠模式已关闭"];
        self.sleepStyleLabel.text=@"关";
        UserSettings*user=[AppDelegate getAppDelegate].user;
        user.sleepStyleFlag=0;
        [UserSettings saveUserSettings:user];

    }
    else
    {
        [AppDelegate showAlert:@"睡眠模式已开启,防止流量偷跑,睡醒后别忘了来恢复啊!"];
        self.sleepStyleLabel.text=@"开";
        UserSettings*user=[AppDelegate getAppDelegate].user;
        user.sleepStyleFlag=1;
        [UserSettings saveUserSettings:user];
    }


    
}

- (void) didUnlockAllApps:(TwitterClient*)tc obj:(NSObject*)obj
{
    twitterClient = nil;
    
    if ( tc.hasError ) {
        [AppDelegate showAlert:@"抱歉,网络访问失败"];
    }
    
    if ( !obj || ![obj isKindOfClass:[NSDictionary class]] ) return;
    
    NSDictionary* dic = (NSDictionary*) obj;
    if ( [dic objectForKey:@"code"] && [dic objectForKey:@"code"] != [NSNull null] ) {
        int code = [[dic objectForKey:@"code"] intValue];
        if ( code == 200 ) {
            //[UserAgentLockDAO deleteAll];
            [self performSelector:@selector(hiddenLoadingView) withObject:nil afterDelay:0.3f];
            return;
        }
    }
    
    [AppDelegate showAlert:@"抱歉,操作失败!"];
}

-(void)unlockAll
{
    if ( twitterClient ) return;
    
    if ( ![AppDelegate networkReachable] ) {
        [AppDelegate showAlert:@"抱歉,网络访问失败!"];
        return;
    }
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    NSString* url = [NSString stringWithFormat:@"%@/%@.json?lock=%d&locktime=%d&host=%@&port=%d",
                     API_BASE,@"settngs/disableall",0, 1, user.proxyServer, user.proxyPort];
    url = [TwitterClient composeURLVerifyCode:url];
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(didUnlockAllApps:obj:)];
    [twitterClient get:url];

}
-(void)lockAll
{
    if ( twitterClient ) return;
    
    if ( ![AppDelegate networkReachable] ) {
        [AppDelegate showAlert:@"抱歉,网络访问失败!"];
        return;
    }
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    NSString* url = [NSString stringWithFormat:@"%@/%@.json?lock=%d&locktime=%d&host=%@&port=%d",
                     API_BASE,@"settngs/disableall",1, 0, user.proxyServer, user.proxyPort];
    url = [TwitterClient composeURLVerifyCode:url];
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(didUnlockAllApps:obj:)];
    [twitterClient get:url];
}
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    UIView *view=(UIView*)[self.view viewWithTag:101];
    [view removeFromSuperview];
    if(alertView.tag==101)
    {
        if(buttonIndex==1)
        {
            [self unlockAll];
        }
    }
    else
    {
        if(buttonIndex==1)
        {
            [self lockAll];
        }
    }

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
