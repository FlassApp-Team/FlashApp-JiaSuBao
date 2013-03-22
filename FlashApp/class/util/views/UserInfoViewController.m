//
//  UserInfoViewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-17.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import "UserInfoViewController.h"
#import<QuartzCore/QuartzCore.h>
#import "LoginNewViewController.h"
#import "LevelViewController.h"
@interface UserInfoViewController ()

@end
//static UserInfoViewController *userInfoViewController;

@implementation UserInfoViewController
@synthesize nologoImageView;
@synthesize logoImageView;
@synthesize feibiImageView;
@synthesize levelImageView;
@synthesize nameLabel;
@synthesize levelOrFeiBiLabel;
@synthesize detailBtn;

@synthesize feibiLineImageView;
@synthesize nameLineImageView;
@synthesize kuangImageView;
@synthesize logoView;
@synthesize noLogoView;
-(void)dealloc
{
    self.noLogoView=nil;
    self.logoView=nil;
    self.kuangImageView=nil;
    self.feibiLineImageView=nil;
    self.nameLineImageView=nil;
    self.nologoImageView=nil;
    self.logoImageView=nil;
    self.feibiImageView=nil;
    self.levelOrFeiBiLabel=nil;
    self.nameLabel=nil;
    self.levelOrFeiBiLabel=nil;
    self.detailBtn=nil;
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
//+ (UserInfoViewController*)sharedUserInfoViewController;
//{
//	@synchronized(self) {
//		
//        if (userInfoViewController == nil) {
//            userInfoViewController = [[UserInfoViewController alloc] init];
//            
//        }
//    }
//    return userInfoViewController;
//}
-(void)viewWillAppear:(BOOL)animated
{

    
    [super viewWillAppear:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setFrameOfTwoView) name:RefreshLoginNotification object: nil];

    CALayer *lVlayer = [self.logoImageView layer];   //获取ImageView的层,设置头像圆角
    [lVlayer setMasksToBounds:YES];
    [lVlayer setCornerRadius:4.0];

    [self setFrameOfTwoView];
}
-(void)setFrameOfTwoView
{
    [self.detailBtn removeTarget: self action:@selector(logined) forControlEvents:UIControlEventTouchUpInside];
    [self.detailBtn removeTarget:self action:@selector(noLogined) forControlEvents:UIControlEventTouchUpInside];
    
    
    UserSettings *user=[UserSettings currentUserSettings];
    if ( user.username && user.username.length > 0 ) {
        [self.logoView setHidden:NO];
        [self.noLogoView setHidden:YES];
        self.nameLabel.text=user.nickname;
        UserSettings* user = [AppDelegate getAppDelegate].user;
        UIImage * result = [UIImage imageWithData:user.headImageData];
        self.logoImageView.image=result;
        [self.detailBtn addTarget:self action:@selector(logined) forControlEvents:UIControlEventTouchUpInside];
        
    }
    else {
        //UIView
        [self.detailBtn addTarget:self action:@selector(noLogined) forControlEvents:UIControlEventTouchUpInside];
        [self.logoView setHidden:YES];
        [self.noLogoView setHidden:NO];
    }

    
    int currentStage=user.level/3;
    NSLog(@"user,level=====%d",user.level);
    if(currentStage<=0){
        self.levelImageView.image=[UIImage imageNamed:@"level_icon1"];
        
    }
    else if(currentStage<=1){
        self.levelImageView.image=[UIImage imageNamed:@"level_icon2"];
    }
    else if(currentStage<=2){
        self.levelImageView.image=[UIImage imageNamed:@"level_icon3"];
    }
    else if(currentStage<=3){
        self.levelImageView.image=[UIImage imageNamed:@"level_icon4"];
    }
    else if(currentStage<=4){
        self.levelImageView.image=[UIImage imageNamed:@"level_icon5"];
    }
    else if(currentStage<=5){
        self.levelImageView.image=[UIImage imageNamed:@"level_icon6"];
    }
    else if(currentStage<=6){
        self.levelImageView.image=[UIImage imageNamed:@"level_icon7"];
    }

    
    CGSize mbDataFrame = [self.nameLabel.text sizeWithFont:self.nameLabel.font constrainedToSize:CGSizeMake(320, 999) lineBreakMode:UILineBreakModeWordWrap];
    self.nameLabel.frame =CGRectMake(self.nameLabel.frame.origin.x,self.nameLabel.frame.origin.y,mbDataFrame.width,self.nameLabel.frame.size.height);
    self.nameLineImageView.frame=CGRectMake(self.nameLineImageView.frame.origin.x,self.nameLineImageView.frame.origin.y,mbDataFrame.width+15,self.nameLineImageView.frame.size.height);
    self.levelImageView.frame=CGRectMake(self.nameLabel.frame.origin.x+self.nameLabel.frame.size.width+2,self.levelImageView.frame.origin.y,self.levelImageView.frame.size.width,self.levelImageView.frame.size.height);
    
    CGSize feiBiDataFrame = [self.levelOrFeiBiLabel.text sizeWithFont:self.levelOrFeiBiLabel.font constrainedToSize:CGSizeMake(320, 999) lineBreakMode:UILineBreakModeWordWrap];
    self.levelOrFeiBiLabel.frame =CGRectMake(self.levelOrFeiBiLabel.frame.origin.x,self.levelOrFeiBiLabel.frame.origin.y,feiBiDataFrame.width,self.levelOrFeiBiLabel.frame.size.height);
    self.feibiLineImageView.frame=CGRectMake(self.feibiLineImageView.frame.origin.x,self.feibiLineImageView.frame.origin.y,feiBiDataFrame.width+self.feibiImageView.frame.size.width,self.feibiLineImageView.frame.size.height);

    
    
}

-(void)logined
{
    LevelViewController *levelViewController=[[[LevelViewController alloc]init] autorelease];
    [[sysdelegate navController]pushViewController:levelViewController animated:YES];
}
-(void)noLogined
{
    LoginNewViewController*loginNewViewController=[[[LoginNewViewController alloc]init] autorelease];
    loginNewViewController.viewController=self;
    [[sysdelegate navController]presentModalViewController:loginNewViewController animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
