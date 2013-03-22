//
//  AccountNumberViewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-17.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import "AccountNumberViewController.h"
#import "AppDelegate.h"
#import "UserInfoViewController.h"
#import "BoundPhoneiewController.h"
@interface AccountNumberViewController ()

@end

@implementation AccountNumberViewController
@synthesize feiBiBtn;
@synthesize detailBtn;
@synthesize buyBtn;
@synthesize balancelLabel;
@synthesize jiangliLabel1;
@synthesize jiangliLabel2;
@synthesize jiangliLabel3;
@synthesize jiangliLabel4;
@synthesize jiangliLabel5;
@synthesize jiangliLabel6;
@synthesize jiangliLabel7;
@synthesize userInfoViewController;
@synthesize backView;
@synthesize boundPhoneiewController;
@synthesize turnBtn;
@synthesize bangDingBtn;
-(void)dealloc
{
    self.bangDingBtn=nil;
    self.turnBtn=nil;
    self.balancelLabel=nil;
    self.jiangliLabel1=nil;
    self.jiangliLabel2=nil;
    self.jiangliLabel3=nil;
    self.jiangliLabel4=nil;
    self.jiangliLabel5=nil;
    self.jiangliLabel6=nil;
    self.jiangliLabel7=nil;

    self.buyBtn=nil;
    self.detailBtn=nil;
    self.feiBiBtn=nil;
    self.backView=nil;
    self.userInfoViewController=nil;
    
    self.boundPhoneiewController=nil;
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
    
    
    UIImage* img1=[UIImage imageNamed:@"opaque_small.png"];
    img1=[img1 stretchableImageWithLeftCapWidth:7 topCapHeight:8];

    [self.bangDingBtn setBackgroundImage:img1 forState:UIControlStateNormal];
    
    
    
    
    
    UIImage* selectedImage1=[UIImage imageNamed:@"feibi_btn.png"];
    selectedImage1=[selectedImage1 stretchableImageWithLeftCapWidth:11 topCapHeight:0];
    [self.feiBiBtn setBackgroundImage:selectedImage1 forState:UIControlStateNormal];
    [self.buyBtn setBackgroundImage:selectedImage1 forState:UIControlStateNormal];

    
    [AppDelegate buttonTopShadow:self.detailBtn shadowColor:[UIColor grayColor]];
    [AppDelegate buttonTopShadow:self.feiBiBtn shadowColor:[UIColor grayColor]];
    [AppDelegate buttonTopShadow:self.buyBtn shadowColor:[UIColor grayColor]];



    [AppDelegate labelShadow:self.bangDingBtn.titleLabel];
    [AppDelegate labelShadow:self.detailBtn.titleLabel];
    if(self.userInfoViewController==nil)
    {
        self.userInfoViewController=[[[UserInfoViewController alloc]init] autorelease];
        [self.backView addSubview:self.userInfoViewController.view];
        self.userInfoViewController.levelOrFeiBiLabel.text=@"飞机用户";
        self.userInfoViewController.view.frame=CGRectMake(8, 40, 320, 67);
        self.userInfoViewController.feibiLineImageView.frame=CGRectMake(88, 46, 65, 1);
        [self.userInfoViewController.detailBtn removeTarget:self.userInfoViewController action:@selector(logined) forControlEvents:UIControlEventTouchUpInside];

        //self.userInfoViewController.view.transform=CGAffineTransformMakeScale(0.5, 0.5);

    }
   // NSLog(@"AAAAAAAAAAAAAAAAAAAA%f",self.userInfoViewController.view.frame.size.height);

    // Do any additional setup after loading the view from its nib.
}
-(IBAction)feiBiBtnPress:(id)sender
{}
-(IBAction)buyBtnPress:(id)sender
{}
-(IBAction)detailBtnPress:(id)sender
{}
-(IBAction)bangDingBtnPress:(id)sender
{
    if(self.boundPhoneiewController==nil)
    {
        self.boundPhoneiewController=[[[BoundPhoneiewController alloc]init] autorelease];
    }
    [[[sysdelegate navController  ] topViewController ].view addSubview:self.boundPhoneiewController.view];
}
-(IBAction)turnBtnPress:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
