//
//  ImageModleViewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-26.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import "ImageModleViewController.h"
#import "ImageCompressViewController.h"
@interface ImageModleViewController ()
-(void)setImageQuality;
@end

@implementation ImageModleViewController
@synthesize zhiliangBtn;
@synthesize zhiliangLabel;
//@synthesize imageQualityViewController;
@synthesize icvc;
-(void)dealloc
{
    self.zhiliangLabel=nil;
    self.zhiliangBtn=nil;
    self.icvc = nil;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setImageQuality ) name:@"refreshInterface" object:nil];
    self.zhiliangBtn.controller=self;
    [self setImageQuality];
    // Do any additional setup after loading the view from its nib.
}
-(void)setImageQuality
{
    self.zhiliangLabel.font=[UIFont systemFontOfSize:54.0];
    UserSettings* user = [AppDelegate getAppDelegate].user;
    self.zhiliangLabel.font=[UIFont systemFontOfSize:50.0];
    self.zhiliangLabel.textAlignment=UITextAlignmentCenter;
    self.zhiliangLabel.numberOfLines=1;
    if ( user.pictureQsLevel == PIC_ZL_MIDDLE ) {
        self.zhiliangLabel.text=@"中";
    }
    else if ( user.pictureQsLevel == PIC_ZL_HIGH ) {
        self.zhiliangLabel.text=@"高";
        
    }
    else if ( user.pictureQsLevel == PIC_ZL_NOCOMPRESS ) {
        self.zhiliangLabel.font=[UIFont systemFontOfSize:13.0];
        self.zhiliangLabel.textAlignment=UITextAlignmentLeft;
        self.zhiliangLabel.numberOfLines=3;
        self.zhiliangLabel.text=@"图片无压缩 \n调节图片质量 \n可节省更多";
        
    }
    else if ( user.pictureQsLevel == PIC_ZL_LOW ) {
        self.zhiliangLabel.text=@"低";
        
    }
    
}
-(void)nextContorller
{
    self.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    UIView *view=(UIView*)[self.view viewWithTag:101];
    [view removeFromSuperview];
    if(self.icvc==nil)
    {
        self.icvc=[[[ImageCompressViewController alloc]init] autorelease];
    }
    [[sysdelegate navController  ] pushViewController:self.icvc animated:YES];

    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
