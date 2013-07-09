//
//  FeedbackViewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-25.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "FeedbackViewController.h"
#import "AppDelegate.h"
#import "StringUtil.h"
#import "UIDevice-Reachability.h"
#import "OpenUDID.h"
#define TEXT_PLACEHOLDER @"请留下您的宝贵意见！"

#define SCROLLVIEW_FRAME_OUT_TEXT CGRectMake(0,0,320,256)
#define SCROLLVIEW_FRAME_IN_TEXT CGRectMake(0,0,320,216)
@interface FeedbackViewController ()
- (void) displaySMSComposerSheet:(NSString*)body;
@end

@implementation FeedbackViewController
@synthesize submitButton;
@synthesize topImageView;
@synthesize bottomImageView;
@synthesize contactField;
@synthesize textView;
-(void)dealloc
{
    self.contactField=nil;
    self.textView=nil;
    self.submitButton=nil;
    
    self.topImageView=nil;
    self.bottomImageView=nil;
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
        self.textView.returnKeyType=UIReturnKeyDone;
    self.contactField.returnKeyType=UIReturnKeyDone;
    
    
//    UIImage *image1=[UIImage imageNamed:@"about_clause_bg.png"];
//    image1=[image1 stretchableImageWithLeftCapWidth:image1.size.width/2 topCapHeight:image1.size.height/2];
    [self.submitButton setUserInteractionEnabled:NO];
   // [self.submitButton setBackgroundImage:image1 forState:UIControlStateNormal];
    
    
    
    UIImage *image=[UIImage imageNamed:@"feedback_text_bg.png"];
    image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];

    self.topImageView.image=image;
    self.bottomImageView.image=image;
    // Do any additional setup after loading the view from its nib.
    
    textView.text = TEXT_PLACEHOLDER;

    
}


-(IBAction)turnBtnPress:(id)sender
{
    [[sysdelegate navController  ] popViewControllerAnimated:YES];

}
#pragma mark - business method
- (IBAction) save
{
    NSString* content = [textView.text trim];
    NSString* contact = [contactField.text trim];
    
    if ( content.length == 0 ) {
        [AppDelegate showAlert:@"请输入您的反馈内容，谢谢"];
        return;
    }
    
    if ( contact.length == 0 ) {
        [AppDelegate showAlert:@"请输入您的联系方式，谢谢"];
        return;
    }
    
    if ( client ) return;
    
    content = [NSString stringWithFormat:@"#%@#%@", [OpenUDID value], content];
    
    BOOL reachable = [UIDevice reachableToHost:P_HOST];
    DeviceInfo *device = [DeviceInfo deviceInfoWithLocalDevice];
     NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
    //BOOL reachable = NO;
    if ( reachable ) {
        UserSettings* user = [AppDelegate getAppDelegate].user;
        NSString* url = [NSString stringWithFormat:@"%@/%@.json", API_BASE, API_FEEDBACK_FEEDBACK];
        NSString* body = [NSString stringWithFormat:@"content=%@&email=%@&username=%@&ftype=%d&appid=%d&platform=%@&innver=%d&vr=%@&chl=%@", [content encodeAsURIComponent], [contact encodeAsURIComponent], user.username,11,APP_ID,device.platform,0,version,CHANNEL ];
        client = [[TwitterClient alloc] initWithTarget:self action:@selector(didSave:obj:)];
        [client post:url body:body];
    }
    else {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的网络无法使用，采用短信方式发送反馈？" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
        [alertView show];
        [alertView release];
    }
}


- (void) didSave:(TwitterClient*)cli obj:(NSObject*)obj
{
    client = nil;
    
    if ( cli.hasError ) {
        [AppDelegate showAlert:@"抱歉，访问网络失败"];
        return;
    }
    
    if ( !obj || ![obj isKindOfClass:[NSDictionary class]] ) {
        [AppDelegate showAlert:@"抱歉，请求网络失败"];
        return;
    }
    
    NSDictionary* dic = (NSDictionary*) obj;
    NSObject* value = [dic objectForKey:@"result"];
    if ( value ) {
        Boolean* b = (Boolean*)value;
        if ( b ) {
            [AppDelegate showAlert:@"已经成功发送了您的反馈信息。"];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        else {
            [AppDelegate showAlert:@"抱歉，请求网络失败"];
            return;
        }
    }
    else {
        [AppDelegate showAlert:@"抱歉，请求网络失败"];
        return;
    }
}


- (void) close
{
    [[sysdelegate navController  ] popViewControllerAnimated:YES];

}


#pragma mark - UITextViewDelegate

- (BOOL) textViewShouldBeginEditing:(UITextView *)v
{
    if ( [v.text compare:TEXT_PLACEHOLDER] == NSOrderedSame ) v.text = @"";
    return YES;
}


- (void)textViewDidChange:(UITextView *)v
{
    [self.submitButton setTitle:@"发送" forState:UIControlStateNormal];
    if([v.text compare:@""]==NSOrderedSame||[v.text compare:TEXT_PLACEHOLDER]==NSOrderedSame)
    {
        if(!self.submitButton.userInteractionEnabled)
            return;
        [self.submitButton setUserInteractionEnabled:NO];
        [self.submitButton setTitleColor:BgTextColor forState:UIControlStateNormal];
        UIImage *image1=[UIImage imageNamed:@"about_clause_bg.png"];
        image1=[image1 stretchableImageWithLeftCapWidth:image1.size.width/2 topCapHeight:image1.size.height/2];
        [self.submitButton setBackgroundImage:image1 forState:UIControlStateNormal];
    }
    else
    {
        if(self.submitButton.userInteractionEnabled)
            return;
        [self.submitButton setUserInteractionEnabled:YES];
        [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIImage *image1=[UIImage imageNamed:@"unlock_bg.png"];
        image1=[image1 stretchableImageWithLeftCapWidth:image1.size.width/2 topCapHeight:image1.size.height/2];
        [self.submitButton setBackgroundImage:image1 forState:UIControlStateNormal];
    }

    //scrollView.frame = SCROLLVIEW_FRAME_IN_TEXT;
}


#pragma mark - UITextFieldDelegate
- (void) textViewDidEndEditing:(UITextView *)v
{
    if([v.text compare:@""]==NSOrderedSame||[v.text compare:TEXT_PLACEHOLDER]==NSOrderedSame)
    {
    }
    else
    {
        [self.submitButton setUserInteractionEnabled:YES];
        UIImage *image1=[UIImage imageNamed:@"unlock_bg.png"];
        image1=[image1 stretchableImageWithLeftCapWidth:image1.size.width/2 topCapHeight:image1.size.height/2];
        [self.submitButton setBackgroundImage:image1 forState:UIControlStateNormal];
    }
    //scrollView.frame = SCROLLVIEW_FRAME_IN_TEXT;
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
            [AppDelegate showAlert:@"设备没有短信功能" message:@"您的设备不能发送短信"];
		}
	}
	else {
        [AppDelegate showAlert:@"iOS版本过低" message:@"iOS版本过低,iOS4.0以上才支持程序内发送短信"];
	}
}


- (void) displaySMSComposerSheet:(NSString*)body
{
    [textView resignFirstResponder];
    [contactField resignFirstResponder];
    //scrollView.frame = SCROLLVIEW_FRAME_OUT_TEXT;
    
	MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
	picker.messageComposeDelegate = self;
    picker.recipients = [NSArray arrayWithObjects:@"18611737301", nil];
	picker.body = body;
    picker.title = @"发送短信";
    
    [self.navigationController presentModalViewController:picker animated:YES];
	[picker release];
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)messageComposeViewController
				 didFinishWithResult:(MessageComposeResult)result {
	switch (result)
	{
		case MessageComposeResultCancelled:
			break;
		case MessageComposeResultSent:
            [AppDelegate showAlert:@"您的反馈信息已经发送成功，谢谢对我们工作的支持"];
			break;
		case MessageComposeResultFailed:
            [AppDelegate showAlert:@"抱歉，短信发送失败"];
			break;
		default:
			NSLog(@"Result: SMS not sent");
			break;
	}
    
    [[sysdelegate navController  ] popViewControllerAnimated:YES];
}


#pragma mark - UIAlertViewDelegate

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 0 ) {
        NSString* content = [NSString stringWithFormat:@"#%@#%@ 【联系方式】%@", [OpenUDID value], textView.text, contactField.text];
        [self sendSMS:content];
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
