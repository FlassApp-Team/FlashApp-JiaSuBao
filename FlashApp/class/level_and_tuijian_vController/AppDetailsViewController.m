//
//  AppDetailsViewController.m
//  FlashApp
//
//  Created by 朱广涛 on 13-4-1.
//  Copyright (c) 2013年 lidiansen. All rights reserved.
//

#import "AppDetailsViewController.h"

@interface AppDetailsViewController ()

@end

@implementation AppDetailsViewController
@synthesize bgView;
@synthesize bgScroll;
@synthesize appImage;
@synthesize appName;
@synthesize appSize;
@synthesize appLiYou;
@synthesize appMiaoshu;
@synthesize starImageView;
@synthesize starImageView2;
@synthesize starImageView3;
@synthesize starImageView4;
@synthesize starImageView5;
@synthesize appDownloadUrl;
@synthesize appStar;
@synthesize appImages;
@synthesize appDic;

- (void)dealloc {
    [appImage release];
    [appName release];
    [appSize release];
    [appLiYou release];
    [appMiaoshu release];
    [bgView release];
    [bgScroll release];
    [appDownloadUrl release];
    [starImageView release];
    [starImageView2 release];
    [starImageView3 release];
    [starImageView4 release];
    [starImageView5 release];
    [appImages release];
    [appDic release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setAppImage:nil];
    [self setAppName:nil];
    [self setAppSize:nil];
    [self setAppLiYou:nil];
    [self setAppMiaoshu:nil];
    [self setBgView:nil];
    [self setBgScroll:nil];
    [self setAppDownloadUrl:nil];
    [self setStarImageView:nil];
    [self setStarImageView2:nil];
    [self setStarImageView3:nil];
    [self setStarImageView4:nil];
    [self setStarImageView5:nil];
    [self setAppDic:nil];
    [self setAppImages:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)downLoad:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.appDownloadUrl]];
}
- (IBAction)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        appDic = [[NSMutableDictionary alloc] init];
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     NSLog(@"dic = %@",appDic);
    
    self.appImage.image = appImages;
    self.appName.text = [appDic objectForKey:@"apname"];
    self.appSize.text = [appDic objectForKey:@"fsize"];
    self.appLiYou.text = [appDic objectForKey:@"apdesc"];
    self.appMiaoshu.text = [appDic objectForKey:@""];
    self.appStar = [[appDic objectForKey:@"star"] intValue];
    self.appDownloadUrl = [appDic objectForKey:@"link"];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSInteger stars=self.appStar/2;
    NSInteger halfstars=self.appStar%2;
    UIImageView *imagV;
    for(int i=0;i<stars;i++)
    {
        imagV=(UIImageView*)[self.bgScroll viewWithTag:10+i];
        imagV.image=[UIImage imageNamed:@"recommend_all_star.png"];
    }
    if(halfstars){
        imagV=(UIImageView*)[self.bgScroll viewWithTag:10+stars];
        imagV.image=[UIImage imageNamed:@"recommend_half_star.png"];
    }
    for(int i=halfstars+stars;i<5;i++)
    {
        imagV=(UIImageView*)[self.bgScroll viewWithTag:10+i];
        imagV.image=[UIImage imageNamed:@"recommend_none_star.png"];
    }

    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
