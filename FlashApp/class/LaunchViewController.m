//
//  LaunchViewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-28.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import "LaunchViewController.h"
#import "ViewController.h"
#import "StarViewController.h"
#import "TCUtils.h"
#import "StageStats.h"
#import "StatsMonthDAO.h"
#import "StringUtil.h"
@interface LaunchViewController ()
-(void)viewAnimation;
- (void)alignTop:(UILabel *)label;
-(void)animationStop;
-(void)showDatasaveView;
-(void)showSetupView;
@end

@implementation LaunchViewController
@synthesize lodingView;
@synthesize MBLabel;
@synthesize MBdataLabel;
@synthesize imageView;
@synthesize tcLabel;
@synthesize saveImageView;
@synthesize saveDataLabel;
-(void)dealloc
{
    self.saveDataLabel=nil;
    self.saveImageView=nil;
    self.tcLabel=nil;
    self.imageView=nil;
    self.MBdataLabel=nil;
    self.MBLabel=nil;
    self.lodingView=nil;
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
    self.imageView.image=[UIImage imageNamed:@"Default.jpg"];
    if(iPhone5)
    {
        self.imageView.image=[UIImage imageNamed:@"Default-568h@2x.jpg"];
    }
    
    /*
     *查询本月的流量使用情况，方法
     */
    time_t now;
    time(&now);
    time_t peroid[2];
    [TCUtils getPeriodOfTcMonth:peroid time:now];
    long startTime=peroid[0];
    long endTime=peroid[1];
    StageStats *stageStas = [StatsMonthDAO statForPeriod:startTime endTime:endTime];
    float number = [NSString bytesNumberByUnit:stageStas.bytesBefore-stageStas.bytesAfter unit:@"MB"];
    NSString* item1Number = [NSString stringWithFormat:@"%.2f", number];
    self.MBdataLabel.text=item1Number;
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    float totalm=[user.ctTotal floatValue]; // 用户总共的流量 单位：MB
    float used=[user.ctUsed longLongValue]; //  实际使用的流量 单位：byte
    float persent;
    float count=totalm-used/1024.0/1024.0; //剩余的流量 单位：MB
    NSString*str=nil;
    if(used==0)
    {
        [self.MBdataLabel setHidden:YES];//节省的数字
        [self.MBLabel setHidden:YES]; //数字后面的MB & GB
        [self.saveDataLabel setHidden:YES]; //本月已节省
        [self.saveImageView setHidden:YES]; //小猪的图片
    }
    if(totalm==0)
    {
        persent=0;
        count=0;

        [self.tcLabel setHidden:NO];
        str=[NSString stringWithFormat:@"未设置套餐流量"];
    }
    else
    {
        [self.MBLabel setHidden:NO];
        [self.MBdataLabel setHidden:NO];
        [self.saveDataLabel setHidden:NO];
        [self.saveImageView setHidden:NO];
        [self.tcLabel setHidden:NO];
        persent= used / 1024.0f / 1024.0f/totalm*100;
        if(persent>=1)
        {
            str=[NSString stringWithFormat:@"套餐流量剩余%.1fMB,已用%.0f%@",count,persent,@"%"];
            
        }
        else
        {
            str=[NSString stringWithFormat:@"套餐流量剩余%.1fMB,已用%.2f%@",count,persent,@"%"];
        }
        
        if(used==0)
        {
            persent=0;
            str=[NSString stringWithFormat:@"套餐流量剩余%.1fMB,已用%.0f%@",count,persent,@"%"];
        }

    }

    self.tcLabel.text=str;

    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self viewAnimation];
    //[self showDatasaveView];
    CGSize labFrame = [self.saveDataLabel.text sizeWithFont:self.saveDataLabel.font constrainedToSize:CGSizeMake(320, 23) lineBreakMode:UILineBreakModeWordWrap];
    self.saveDataLabel.frame =CGRectMake(self.saveDataLabel.frame.origin.x,self.saveDataLabel.frame.origin.y,labFrame.width,labFrame.height);
    
    
    [AppDelegate setLabelFrame:self.MBdataLabel label2:self.MBLabel];
    [self alignTop:self.MBdataLabel];
    [self alignTop:MBLabel];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewAnimation
{
    [self.lodingView setAlpha:0.1];
    
    [UIView animateWithDuration:1.5 animations:^{
        [self.lodingView setAlpha:1.0];
        
    }completion:^(BOOL finished){
        [self animationStop];}];
    
}
- (void)alignTop:(UILabel *)label
{
    CGSize fontSize = [label.text sizeWithFont:label.font];
    double finalHeight = fontSize.height * label.numberOfLines;
    double finalWidth = label.frame.size.width;    //expected width of label
    CGSize theStringSize = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:label.lineBreakMode];
    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
    for(int i=0; i<newLinesToPad; i++)
        label.text = [label.text stringByAppendingString:@"\n "];
}
-(void)animationStop
{
    [self performSelector:@selector(initViewController) withObject:nil afterDelay:1.0];

}
-(void)initViewController
{
    float systemVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if ( systemVersion < 4.0 ) {
        NSString* v = [[NSUserDefaults standardUserDefaults] objectForKey:@"systemVersion"];
        if ( v ) {
            [self showDatasaveView];
        }
        else {
            [self showSetupView];
            
            // [self showDatasaveView:NO];
        }
    }
    else {
        float currentCapacity = [UserSettings currentCapacity]; //套用户的 压缩流量 限额
        
        NSLog(@"currentCapacity=%f", currentCapacity);
        
        if ( currentCapacity == 0 ) { // 用户第一次启动的时候 没有压缩流量限额 引导用户安装配置文件
            
            [self showSetupView];
            
            // [self showDatasaveView:NO];
        }
        else {
            [self showDatasaveView];
        }
        
    }

}
-(void)showDatasaveView
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    ViewController*viewController=nil;
    if(iPhone5)
    {
        viewController=[[[ViewController alloc]initWithNibName:@"ViewController_iphone5" bundle:nil] autorelease];
    }
    else
    {
               viewController=[[[ViewController alloc]initWithNibName:@"ViewController" bundle:nil] autorelease];
    }
    [self.navigationController pushViewController:viewController animated:NO];
}
-(void)showSetupView
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    StarViewController*starViewController=[StarViewController sharedstarViewController];
    // ViewController *viewController=[[[ViewController alloc]init] autorelease];
    [self.navigationController pushViewController:starViewController animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
