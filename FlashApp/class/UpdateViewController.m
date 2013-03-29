//
//  UpdateViewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-28.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import "UpdateViewController.h"
#import "DeviceInfo.h"
#import "OpenUDID.h"
#import "StringUtil.h"
#import "JSON.h"
@interface UpdateViewController ()
-(void)update;
@end

@implementation UpdateViewController
@synthesize bgImageView;
@synthesize activity;
@synthesize bgView;
@synthesize cancleBtn;
@synthesize dic;
-(void)dealloc
{
    self.dic=nil;
    self.cancleBtn=nil;
    self.bgView=nil;
    self.activity=nil;
    self.bgImageView=nil;
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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.activity startAnimating];
    [AppDelegate exChangeOut:self.bgView dur:0.6];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if(iPhone5)
        self.view.frame=CGRectMake(0, 0, 320, 568);
    UIImage *image=[UIImage imageNamed:@"baikuang_shadow.png"];
    image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    self.bgImageView.image=image;
    
    [self.cancleBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [self update];
    // Do any additional setup after loading the view from its nib.
}
-(void)update
{
    Reachability* reachable = [Reachability reachabilityWithHostName:P_HOST];
    if ( [reachable currentReachabilityStatus] == NotReachable ) {
        [AppDelegate showAlert:@"网络连接异常,请链接网络"];
        return;
    }
    DeviceInfo* device = [DeviceInfo deviceInfoWithLocalDevice];
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* versionNum =[infoDict objectForKey:@"CFBundleVersion"];
    
    NSString* url = [NSString stringWithFormat:@"%@/%@.json?&deviceId=%@&platform=%@&osversion=%@&ver=%@&appid=%d",
                     API_BASE, @"up/upgrade",device.deviceId, [device.platform encodeAsURIComponent], [device.version encodeAsURIComponent], versionNum,2];
    
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.delegate=self;
    [request  startAsynchronous];
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [self.activity stopAnimating];
    [self.view removeFromSuperview];
    self.dic=[[request  responseString] JSONValue];
    BOOL isUpdate=[[self.dic objectForKey:@"hasUpgrade"] boolValue];
    if(!isUpdate)
    {
        UIAlertView*alertView=[[[UIAlertView alloc]initWithTitle:@"更新提示" message:@"当前已是最新版本" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]autorelease];
        [alertView show];
    }
    else
    {
        UIAlertView*alertView=[[UIAlertView alloc]initWithTitle:[dic objectForKey:@"appName"] message:[dic objectForKey:@"content"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.delegate=self;
        [alertView show];
    }
   // NSLog(@"request value===%@",[[request  responseString] JSONValue]);
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        NSString *url=[dic objectForKey:@"downURL"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self.activity stopAnimating];
    [self.view removeFromSuperview];
    [AppDelegate showAlert:@"检测失败"];
}
-(IBAction)cancleBtnPress:(id)sender
{
    [self.activity stopAnimating];
    [self.view removeFromSuperview];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
