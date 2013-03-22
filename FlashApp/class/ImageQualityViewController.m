//
//  ImageQualityViewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-20.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//
#import "ImageQualityViewController.h"
#import "Math.h"
#include <Quartzcore/Quartzcore.h>
#import "TwitterClient.h"
#import "TrafficOptimizationViewController.h"
@interface ImageQualityViewController ()
- (void) showPictureQsLevel;
- (void) save;
@end

@implementation ImageQualityViewController
@synthesize knobImageView;
@synthesize radioLabel;
@synthesize leftBottomLabel,leftBottomLine,leftTopLabel,leftTopLine;
@synthesize rightBottomLabel,rightBottomLine,rightTopLabel,rightTopLine;
@synthesize picutureImageView;
@synthesize knob;
@synthesize photoBgImageView;
@synthesize firstImageView;
-(void)dealloc
{
    self.firstImageView=nil;
    self.knob=nil;
    self.photoBgImageView=nil;
    self.knobImageView=nil;
    self.radioLabel=nil;
    
    self.picutureImageView=nil;
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
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    int firstLock=[userDefaults integerForKey:@"firstImageView"];
    if(firstLock!=0)
    {

        [self.firstImageView removeFromSuperview];
    }
    else
    {
        UIImage *image1=nil;
        if(iPhone5)
        {
            image1=[UIImage imageNamed:@"zhiliang_first.png"];
            image1=[image1 stretchableImageWithLeftCapWidth:0 topCapHeight:2.0];
        }
        else
        {
            image1=[UIImage imageNamed:@"zhiliang_first1.png"];
            image1=[image1 stretchableImageWithLeftCapWidth:0 topCapHeight:2.0];
        }
        UITapGestureRecognizer *tapgester=[[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHandle)] autorelease];
        [self.firstImageView addGestureRecognizer:tapgester];

        self.firstImageView.image=image1;

    }
    
    
       
    
    UIImage* img1=[UIImage imageNamed:@"imagequality_bg.png"];
    img1=[img1 stretchableImageWithLeftCapWidth:img1.size.width-16 topCapHeight:img1.size.height/2-4];
    self.photoBgImageView.image=img1;
    
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    picQsLevel = user.pictureQsLevel;
    if ( user.pictureQsLevel == PIC_ZL_MIDDLE ) {
        knobButtonAngle = M_PI / 4;
    }
    else if ( user.pictureQsLevel == PIC_ZL_HIGH ) {
        knobButtonAngle = 3 * M_PI / 4;
    }
    else if ( user.pictureQsLevel == PIC_ZL_NOCOMPRESS ) {
        knobButtonAngle = 5 * M_PI / 4;
    }
    else if ( user.pictureQsLevel == PIC_ZL_LOW ) {
        knobButtonAngle = 7 * M_PI / 4;
    }
    
}
-(void)tapHandle
{
    [self.firstImageView removeFromSuperview];
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:1 forKey:@"firstImageView"];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self showPictureQsLevel];
}


- (void) viewWillDisappear:(BOOL)animated
{
    [self save];
    [super viewWillDisappear:animated];
}


-(IBAction)turnBack:(id)sender
{
    [[sysdelegate navController  ] popViewControllerAnimated:YES];
}
- (void) showPictureQsLevel
{
 
    
//#if NS_BLOCKS_AVAILABLE       // iOS4 and above
    CGPoint point=self.knob.center;
    
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5];
    
	CGAffineTransform transform = CGAffineTransformMakeRotation(knobButtonAngle);
	[knobImageView setTransform:transform];
    knobImageView.center=point;
    [UIView commitAnimations];
    [self performSelector:@selector(showLabelAndLines) withObject:nil afterDelay:0.5f];

//#else
//    [self performSelector:@selector(showLabelAndLines) withObject:nil afterDelay:0.0f]; // iOS3
//#endif
    
    
}


- (void) showLabelAndLines
{
    UIColor* highlightColor = [UIColor greenColor];
    UIColor* normalColor = [UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:25.0/255.0 alpha:1.0];
    
    if ( picQsLevel == PIC_ZL_LOW ) {
        picutureImageView.image = [UIImage imageNamed:@"si_image60.jpg"];
        radioLabel.text = @"图片质量低,很模糊,最高可节省80%流量";
    }
    else if ( picQsLevel == PIC_ZL_HIGH ) {
        picutureImageView.image = [UIImage imageNamed:@"si_image15.jpg"];
        radioLabel.text = @"图片质量高,较清晰,最高可节省30%流量";
    }
    else if ( picQsLevel == PIC_ZL_NOCOMPRESS ) {
        //picutureImageView.image = [UIImage imageNamed:@"si_image.jpg"];
        picutureImageView.image = [UIImage imageNamed:@"si_image15.jpg"];
        radioLabel.text = @"图片质量不变,但无法节省流量";
    }
    else {
        picutureImageView.image = [UIImage imageNamed:@"si_image25.jpg"];
        radioLabel.text = @"图片质量中,较模糊,最高节省50%流量";
    }
    [picutureImageView setNeedsDisplay];
    
    if ( picQsLevel == PIC_ZL_LOW ) {
        leftTopLabel.textColor = highlightColor;
        leftTopLine.image = [UIImage imageNamed:@"si_lt_blue.png"];
    }
    else {
        leftTopLabel.textColor = normalColor;
        leftTopLine.image = [UIImage imageNamed:@"si_lt.png"];
    }
    
    if ( picQsLevel == PIC_ZL_MIDDLE ) {
        rightTopLabel.textColor = highlightColor;
        rightTopLine.image = [UIImage imageNamed:@"si_rt_blue.png"];
    }
    else {
        rightTopLabel.textColor = normalColor;
        rightTopLine.image = [UIImage imageNamed:@"si_rt.png"];
    }
    
    if ( picQsLevel == PIC_ZL_HIGH ) {
        rightBottomLabel.textColor = highlightColor;
        rightBottomLine.image = [UIImage imageNamed:@"si_rb_blue.png"];
    }
    else {
        rightBottomLabel.textColor = normalColor;
        rightBottomLine.image = [UIImage imageNamed:@"si_rb.png"];
    }
    
    if ( picQsLevel == PIC_ZL_NOCOMPRESS ) {
        leftBottomLabel.textColor = highlightColor;
        leftBottomLine.image = [UIImage imageNamed:@"si_lb_blue.png"];
    }
    else {
        leftBottomLabel.textColor = normalColor;
        leftBottomLine.image = [UIImage imageNamed:@"si_lb.png"];
    }
}


#pragma mark - actions

- (IBAction) knobClick:(id)sender
{
    if ( picQsLevel == PIC_ZL_LOW ) {
        picQsLevel = PIC_ZL_MIDDLE;
    }
    else if ( picQsLevel == PIC_ZL_MIDDLE ) {
        picQsLevel = PIC_ZL_HIGH;
    }
    else if ( picQsLevel == PIC_ZL_HIGH ) {
        picQsLevel = PIC_ZL_NOCOMPRESS;
    }
    else if ( picQsLevel == PIC_ZL_NOCOMPRESS ) {
        picQsLevel = PIC_ZL_LOW;
    }
    
    knobButtonAngle += M_PI / 2;
    
    [self showPictureQsLevel];
}
#pragma mark - save data

- (void) save
{
    Reachability* reachable = [Reachability reachabilityWithHostName:P_HOST];
    if ( [reachable currentReachabilityStatus] == NotReachable ) {
        [AppDelegate showAlert:@"抱歉，连接网络失败。"];
        return;
    }
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    if ( user.pictureQsLevel == picQsLevel ) return;
    
    int qs = 0;
    if ( picQsLevel == PIC_ZL_LOW ) {
        qs = 0;
    }
    else if ( picQsLevel == PIC_ZL_MIDDLE ) {
        qs = 1;
    }
    else if ( picQsLevel == PIC_ZL_HIGH ) {
        qs = 2;
    }
    else if ( picQsLevel == PIC_ZL_NOCOMPRESS ) {
        qs = 2;
    }
    
    NSString* url = [NSString stringWithFormat:@"%@/%@.json?misc=%d&host=%@&port=%d",
                     API_BASE, API_SETTING_IMAGE_QUALITY, qs,
                     user.proxyServer, user.proxyPort];
    url = [TwitterClient composeURLVerifyCode:url];
    
    NSHTTPURLResponse* response;
    NSError* error;
    NSObject* obj = [TwitterClient sendSynchronousRequest:url response:&response error:&error];
    
    if ( response.statusCode == 200 ) {
        if ( !obj && ![obj isKindOfClass:[NSDictionary class]] ) {
            [AppDelegate showAlert:@"抱歉，操作失败"];
        }
        
        NSDictionary* dic = (NSDictionary*) obj;
        NSNumber* number = (NSNumber*) [dic objectForKey:@"code"];
        int code = [number intValue];
        if ( code == 200 ) {
            user.pictureQsLevel = picQsLevel;
            [UserSettings savePictureQsLevel:picQsLevel];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshInterface" object:nil];//刷新界面
        }
        else {
            [AppDelegate showAlert:@"抱歉，操作失败"];
        }
    }
    else {
        [AppDelegate showAlert:@"抱歉，操作失败"];
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
