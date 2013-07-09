//
//  TellFriendModleViewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-26.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//
#define TAG_ALERT_INVITE 100
#import <QuartzCore/QuartzCore.h>
#import "TellFriendModleViewController.h"
#import "ShareToSNSViewController.h"
//#import "DBConnection.h"
//#import "IFDataService.h"
#import "StatsDayService.h"
#import "StatsMonthDAO.h"
#import "StatsDayDAO.h"
#import "DateUtils.h"
#import "StringUtil.h"
//#import "UIImageUtil.h"
#import "OpenUDID.h"
#import "UIDevice-Reachability.h"
#import "WXApi.h"
//#import "TCUtils.h"
//#import "TitleView.h"


@interface TellFriendModleViewController ()
-(void)tellBtnPress;
- (void) sendMail:(NSString*)subject body:(NSString*)body;
- (void) sendSMS:(NSString*)body;
-(void)sendSNS:(NSString*)sns;
- (void) sendWeixin:(enum WXScene)scene text:(NSString*)text;
- (void) displaySMSComposerSheet:(NSString*)body;
- (NSData*) captureScreen;
@end

@implementation TellFriendModleViewController
@synthesize tellBtn;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    self.tellBtn=nil;
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tellBtn.controller=self;
    // Do any additional setup after loading the view from its nib.
}
/*- (void)willPresentActionSheet:(UIActionSheet*)actionSheet  //修改actionsheet的背景图片
{
    UIImage*theImage =[UIImage imageNamed:@"Default@2x.jpg"];
    theImage =[theImage stretchableImageWithLeftCapWidth:32 topCapHeight:32];
    CGSize theSize = actionSheet.frame.size;
    // draw the background image and replace layer content
    UIGraphicsBeginImageContext(theSize);
    [theImage drawInRect:CGRectMake(0,0, theSize.width, theSize.height)];
    theImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [[actionSheet layer] setContents:(id)theImage.CGImage];
}*/
-(void)nextContorller
{
    self.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    UIView *view=(UIView*)[self.view viewWithTag:101];
    [view removeFromSuperview];
    [self tellBtnPress];
}
-(void)tellBtnPress
{
    NSString* title =  NSLocalizedString(@"inviteFriend.title",nil);
    NSString* cancleButtonTitle =  NSLocalizedString(@"inviteFriend.cancle.title",nil);
    NSString* sendMailButtonTitle =  NSLocalizedString(@"sendMail.title",nil);
    NSString* sendSMSButtonTitle =  NSLocalizedString(@"sendSMS.title",nil);
    NSString* sendWeiboButtonTitle =  NSLocalizedString(@"sendWeibo.title",nil);
    NSString* sendRenRenButtonTitle =  NSLocalizedString(@"sendRenRen.title",nil);
    NSString* sendWeixinGroupButtonTitle =  NSLocalizedString(@"sendWeixinGroup.title",nil);
    NSString* sendWeixinFriendButtonTitle =  NSLocalizedString(@"sendWeixinFriend.title",nil);
    //    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:cancleButtonTitle otherButtonTitles:sendMailButtonTitle,sendSMSButtonTitle,sendWeiboButtonTitle,sendRenRenButtonTitle,
    //        sendWeixinFriendButtonTitle, sendWeixinGroupButtonTitle, nil];
    //
    //    CGRect rect = CGRectMake(10, 10, 300, 460);
    //    alertView.frame = rect;
    //
    //    alertView.tag = TAG_ALERT_INVITE;
    //    [alertView show];
    //    [alertView release];
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self
                                                    cancelButtonTitle:cancleButtonTitle destructiveButtonTitle:nil
                                                    otherButtonTitles:sendMailButtonTitle,sendSMSButtonTitle,sendWeiboButtonTitle,sendRenRenButtonTitle,
                                  sendWeixinFriendButtonTitle, sendWeixinGroupButtonTitle, nil];
    actionSheet.tag = TAG_ALERT_INVITE;
    [actionSheet showInView:sysdelegate.window.rootViewController.view];
    [actionSheet release];
}
#pragma mark - UIAlertView Delegate


- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( actionSheet.tag == TAG_ALERT_INVITE ) {
        NSString* subject =  NSLocalizedString(@"sendMail.subject",nil);
        NSString* text =  nil;
        if(buttonIndex==0)
        {
            text = [NSString stringWithFormat:@"%@ http://jiasu.flashapp.cn/email/%@.html",
                   NSLocalizedString(@"sendMail.text",nil),[OpenUDID value]];
        }
        else if(buttonIndex==1)
        {
            text = [NSString stringWithFormat:@"%@ http://jiasu.flashapp.cn/sms/%@.html",
                   NSLocalizedString(@"sendMail.text",nil), [OpenUDID value]];
        }
        else
        {
            text = [NSString stringWithFormat:@"%@ http://jiasu.flashapp.cn/social/%@.html",NSLocalizedString(@"sendMail.text",nil),[OpenUDID value]];
        }
//        if ( buttonIndex == 4 || buttonIndex == 5 ) {
//            //微信
//            text = [NSString stringWithFormat:@"%@http://%@/%@/%@.html %@",
//                    NSLocalizedString(@"sendMail.text.weixin1",nil),
//                    P_HOST, @"sns", [OpenUDID value],
//                    NSLocalizedString(@"sendMail.text.weixin2",nil)];
//        }
//        else {
//            text = [NSString stringWithFormat:@"%@http://%@/%@/%@.html",
//                    NSLocalizedString(@"sendMail.text",nil),
//                    P_HOST, buttonIndex==0 ? @"email" : @"sms",
//                    [OpenUDID value]];
//        }
        
        //http://p.flashapp.cn/sns/3586956c2d2d5b9a600e1db55feec7a76150ccc1.html
        //NSLog(@"TTTTTTTTTTTTTTTTTTT%@",text);

        NSString* sns = @"sinaWeibo";
        if ( buttonIndex == 0 ) {
            [self sendMail:subject body:text];
        }
        else if ( buttonIndex == 1 ) {
            [self sendSMS:text];
        }
        else if(buttonIndex == 2){
            [self sendSNS:sns];
        }
        else if(buttonIndex == 3){
            sns = @"renren";
            [self sendSNS:sns];
        }
        else if ( buttonIndex == 4 ) {
            [self sendWeixin:WXSceneSession text:text];
        }
        else if ( buttonIndex == 5 ) {
            [self sendWeixin:WXSceneTimeline text:text];
        }
    }
}

#pragma mark - sms methods

- (void) sendSMS:(NSString*)body
{
	Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
	if (messageClass != nil) {
		// Check whether the current device is configured for sending SMS messages
		if ([messageClass canSendText]) {
			[self displaySMSComposerSheet:body];
		}
		else {
            NSString* content= NSLocalizedString(@"device.sendSMS.invalid.content",nil);
            NSString* message= NSLocalizedString(@"device.sendSMS.invalid.message",nil);
            [AppDelegate showAlert:content message:message];
		}
	}
	else {
        NSString* content= NSLocalizedString(@"ios.sendSMS.invalid.content",nil);
        NSString* message= NSLocalizedString(@"ios.sendSMS.invalid.message",nil);
        [AppDelegate showAlert:content message:message];
	}
}
//
//
- (void) displaySMSComposerSheet:(NSString*)body
{
	MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
	picker.messageComposeDelegate = self;
	picker.body = body;
    NSString* title = NSLocalizedString(@"sms.picker.title",nil);
    picker.title = title;
    
    if([AppDelegate  deviceSysVersion]>=6.0f)
    {
        [[[sysdelegate navController  ]topViewController]presentViewController:picker animated:YES completion:nil];

    }
    else
    {
        [[[sysdelegate navController  ]topViewController]presentModalViewController:picker animated:YES];

    }
	[picker release];
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)messageComposeViewController
				 didFinishWithResult:(MessageComposeResult)result {
	switch (result)
	{
		case MessageComposeResultCancelled:
			break;
		case MessageComposeResultSent:
            [AppDelegate showAlert: NSLocalizedString(@"sms.send.success", nil)];
			break;
		case MessageComposeResultFailed:
            [AppDelegate showAlert:NSLocalizedString(@"sms.send.fail", nil)];
			break;
		default:
			NSLog(@"Result: SMS not sent");
			break;
	}
    if([AppDelegate  deviceSysVersion]>=6.0f)
    {
        [[[sysdelegate navController  ]topViewController]dismissViewControllerAnimated:YES completion:nil];
        
    }
    else
    {
        [[[sysdelegate navController  ]topViewController]dismissModalViewControllerAnimated:YES];
        
    }

}


#pragma mark - email

- (void) sendMail:(NSString*)subject body:(NSString*)body
{
    NSString *mailTo = [NSString stringWithFormat:@"mailto:?subject=%@&body=%@",
                        [subject encodeAsURIComponent],
                        [body encodeAsURIComponent]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailTo]];
}

-(void)sendSNS:(NSString*)sns
{
    
//    UIViewController* controller = [[AppDelegate getAppDelegate] currentViewController];
//    if ( [controller respondsToSelector:@selector(shareToSNS:)]) {
//        [controller performSelector:@selector(shareToSNS:) withObject:sns afterDelay:0.3f];
//    }
    [self performSelector:@selector(shareToSNS:) withObject:sns afterDelay:0.3f];
}


- (void) shareToSNS:(NSString*)sns
{
    
    NSString* deviceId = [OpenUDID value];
    NSString* snsText =  NSLocalizedString(@"sendMail.text",nil);
    NSString* content = [NSString stringWithFormat:@"%@ http://%@/social/%@.html",snsText, P_HOST, deviceId];
    
    NSData* image = [self captureScreen];
    
    ShareToSNSViewController* controller = [[ShareToSNSViewController alloc]initWithNibName:@"ShareToSNSViewController" bundle:nil] ;
    controller.sns = sns;
    controller.content = content;
    controller.image = image;
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:controller];
    
    if([AppDelegate  deviceSysVersion]>=6.0f)
    {
        [[[sysdelegate navController  ]topViewController]presentViewController:nav animated:YES completion:nil];
        
    }
    else
    {
        [[[sysdelegate navController  ]topViewController]presentModalViewController:nav animated:YES];
        
    }

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
        UIAlertView *alertView=[[[UIAlertView alloc]initWithTitle:@"提示信息" message:@"未安装微信客户端,请选择其他分享方式，或者下载微信客户端" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]autorelease ];
        [alertView show];
    }

}

- (UIImage*) captureScreenImage
{
    UIGraphicsBeginImageContext( [[AppDelegate getAppDelegate] currentViewController].view.bounds.size );
    
    //renderInContext 呈现接受者及其子范围到指定的上下文
    [[[AppDelegate getAppDelegate] currentViewController].view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    //返回一个基于当前图形上下文的图片
    UIImage *aImage =UIGraphicsGetImageFromCurrentImageContext();
    
    //移除栈顶的基于当前位图的图形上下文
    UIGraphicsEndImageContext();
    //UIImageWriteToSavedPhotosAlbum(aImage, nil, nil, nil);
    return aImage;
}


- (NSData*) captureScreen
{
    UIImage* aImage = [self captureScreenImage];
    
    //以png格式返回指定图片的数据
    NSData* imageData = UIImageJPEGRepresentation( aImage, 0.6 );
    return imageData;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
