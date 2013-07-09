//
//  AboutFlashViewController.m
//  FlashApp
//
//  Created by lidiansen on 13-1-22.
//  Copyright (c) 2013年 lidiansen. All rights reserved.
//

#import "AboutFlashViewController.h"
#import "FeedbackViewController.h"
#import "AboutServiceViewController.h"
@interface AboutFlashViewController ()

@end

@implementation AboutFlashViewController
@synthesize fankuiBtn;
@synthesize turnBtn;
@synthesize serverBtn;
@synthesize btn1,btn2,btn3;
@synthesize versionLabel;
-(void)dealloc
{
    self.versionLabel=nil;
    self.btn1=nil;
    self.btn2=nil;
    self.btn3=nil;

    self.fankuiBtn=nil;
    self.turnBtn=nil;
    self.serverBtn=nil;
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
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.versionLabel.text=[NSString stringWithFormat:@"v%@",version];
    
    
    UIImage *image=[UIImage imageNamed:@"about_clause_bg.png"];
    image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    [self.serverBtn setBackgroundImage:image forState:UIControlStateNormal];
    
    
//    UIImage* img=[UIImage imageNamed:@"opaque_small.png"];
//    img=[img stretchableImageWithLeftCapWidth:7 topCapHeight:8];
//    [self.fankuiBtn setBackgroundImage:img forState:UIControlStateNormal];
    
    
    [self.btn1 setTitleColor:[UIColor colorWithRed:50.0/255 green:79.0/255 blue:133.0/255 alpha:1.0] forState:UIControlStateHighlighted];
    [self.btn2 setTitleColor:[UIColor colorWithRed:50.0/255 green:79.0/255 blue:133.0/255 alpha:1.0] forState:UIControlStateHighlighted];
    [self.btn3 setTitleColor:[UIColor colorWithRed:50.0/255 green:79.0/255 blue:133.0/255 alpha:1.0] forState:UIControlStateHighlighted];
    // Do any additional setup after loading the view from its nib.
}
-(IBAction)openUrlBtnPress:(UIButton*)sender
{
    NSString* url = nil;
    if(sender.tag==101)
    {
        url=@"http://jiasu.flashapp.cn";
    }
    else if(sender.tag==102)
    {
        url=@"http://e.weibo.com/flashapp";
    }
    else if(sender.tag==103)
    {
        url=@"http://t.qq.com/flashapp2012";
    }
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}
-(IBAction)turnBtnPress:(id)sender
{
    [[sysdelegate navController  ] popViewControllerAnimated:YES];

}
-(IBAction)serverBtnPress:(id)sender
{
    AboutServiceViewController*aboutServiceViewController=[[[AboutServiceViewController alloc]init] autorelease];
    [[sysdelegate navController  ] pushViewController:aboutServiceViewController animated:YES];
}
-(IBAction)fankuiBtnPress:(id)sender
{
    FeedbackViewController*feedbackViewController=[[[FeedbackViewController alloc]init] autorelease];
    [self.navigationController pushViewController:feedbackViewController animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
