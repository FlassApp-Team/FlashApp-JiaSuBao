//
//  GameStyleViewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-17.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import "GameStyleViewController.h"
@interface GameStyleViewController ()
@property(nonatomic,retain)NSString*imageStr;
@property(nonatomic,retain)NSString *styleStr;
-(void)showAlertView:(NSString*)str title:(NSString*)title;
-(void)removeCurrentController;
-(void)initBtn;
@end

@implementation GameStyleViewController
@synthesize defaultBtn;
@synthesize gamestyleBtn;
@synthesize sleepBtn;
@synthesize buyBtn;
@synthesize delegate;
@synthesize alertDetailView;
@synthesize alertView;

@synthesize cancleBtn;
@synthesize okBtn;

@synthesize stytleDetailLabel;
@synthesize stytleTitleLabel;

@synthesize imageStr;
@synthesize styleStr;

@synthesize verticalImageView;
@synthesize horizontaImageView;
@synthesize alertBgImageView;
@synthesize detailImageView;
@synthesize alertImageView;


-(void)dealloc
{
    self.verticalImageView=nil;
    self.horizontaImageView=nil;
    self.alertBgImageView=nil;
    self.detailImageView=nil;
    self.defaultBtn=nil;
    self.buyBtn=nil;
    self.sleepBtn=nil;
    self.gamestyleBtn=nil;
    
    self.alertDetailView=nil;
    self.alertView=nil;
    self.okBtn=nil;
    self.cancleBtn=nil;
    
    self.stytleDetailLabel=nil;
    self.stytleTitleLabel=nil;
    self.imageStr=nil;
    
    self.styleStr=nil;
    

    self.alertImageView=nil;
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

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [AppDelegate exChangeOut:self.alertDetailView dur:0.6];

    UIImage *image=[UIImage imageNamed:@"baikuang_shadow.png"];
    image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    self.alertBgImageView.image=image;
    self.detailImageView.image=image;
    
    
    UIImage *image1=[UIImage imageNamed:@"baikuang_vertical.png"];
    image1=[image1 stretchableImageWithLeftCapWidth:image1.size.width/2 topCapHeight:0];
    self.verticalImageView.image=image1;
    
    
    UIImage *image2=[UIImage imageNamed:@"baikuang_horizonta.png"];
    image2=[image2 stretchableImageWithLeftCapWidth:0 topCapHeight:image2.size.height/2];
    self.horizontaImageView.image=image2;
    
    
    [self.okBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [self.cancleBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    
    
    self.view.frame=CGRectMake(0, 0, __MainScreenFrame.size.width,  __MainScreenFrame.size.height);
    [self.alertDetailView setHidden:NO];
    [self.alertView setHidden:YES];
    [self initBtn];

    
    NSString* str=[[NSUserDefaults standardUserDefaults] objectForKey:Model];
    if([str length]!=0)
    {
        if([str isEqualToString:DefaultModel])
        {
            [self.defaultBtn setHighlighted:YES];

        }
        else if([str isEqualToString:GameModel])
        {
            [self.gamestyleBtn setHighlighted:YES];

        }
        else if([str isEqualToString:BuyModel])
        {
            [self.buyBtn setHighlighted:YES];

        }
        else if([str isEqualToString:SleepModle])
        {
            [self.sleepBtn setHighlighted:YES];

        }
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:DefaultModel forKey:Model ];
        [self.defaultBtn setHighlighted:YES];

    }
    
    [super viewWillAppear:YES];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)initBtn
{
  
    UIImage *selectImage=[UIImage imageNamed:@"gamestyleselect.png"];
    selectImage=[selectImage stretchableImageWithLeftCapWidth:4 topCapHeight:selectImage.size.height/2];
    UIImage *selectedImage=[UIImage imageNamed:@"gamestyleselected.png"];
    selectedImage=[selectedImage stretchableImageWithLeftCapWidth:6 topCapHeight:selectedImage.size.height/2];
    
    [self.defaultBtn setTitleColor:[UIColor colorWithRed:1.0f/255.0f green:118.0f/255.0f blue:147.0f/255.0f alpha:1.0] forState:UIControlStateHighlighted];
    [self.defaultBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [self.gamestyleBtn setTitleColor:[UIColor colorWithRed:1.0f/255.0f green:118.0f/255.0f blue:147.0f/255.0f alpha:1.0] forState:UIControlStateHighlighted];
    [self.gamestyleBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [self.buyBtn setTitleColor:[UIColor colorWithRed:1.0f/255.0f green:118.0f/255.0f blue:147.0f/255.0f alpha:1.0] forState:UIControlStateHighlighted];
    [self.buyBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [self.sleepBtn setTitleColor:[UIColor colorWithRed:1.0f/255.0f green:118.0f/255.0f blue:147.0f/255.0f alpha:1.0] forState:UIControlStateHighlighted];
    [self.sleepBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [self.defaultBtn setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
    [self.defaultBtn setBackgroundImage:selectImage forState:UIControlStateNormal];
    [self.gamestyleBtn setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
    [self.gamestyleBtn setBackgroundImage:selectImage forState:UIControlStateNormal];
    [self.buyBtn setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
    [self.buyBtn setBackgroundImage:selectImage forState:UIControlStateNormal];
    [self.sleepBtn setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
    [self.sleepBtn setBackgroundImage:selectImage forState:UIControlStateNormal];

    
    UIImage *defaultBtnImaged=[UIImage imageNamed:@"gamestyledefaulted.png"];
    UIImage *defaultBtnImage=[UIImage imageNamed:@"gamestyledefault.png"];
    [self.defaultBtn setImage:defaultBtnImaged forState:UIControlStateHighlighted];
    [self.defaultBtn setImage:defaultBtnImage forState:UIControlStateNormal];
    
    
    UIImage *gamesBtnImaged=[UIImage imageNamed:@"gamestylegamed.png"];
    UIImage *gamesBtnImage=[UIImage imageNamed:@"gamestylegame.png"];
    [self.gamestyleBtn setImage:gamesBtnImaged forState:UIControlStateHighlighted];
    [self.gamestyleBtn setImage:gamesBtnImage forState:UIControlStateNormal];
    
    UIImage *buyBtnImaged=[UIImage imageNamed:@"gamestylebuyed.png"];
    UIImage *buyBtnImage=[UIImage imageNamed:@"gamestylebuy.png"];
    [self.buyBtn setImage:buyBtnImaged forState:UIControlStateHighlighted];
    [self.buyBtn setImage:buyBtnImage forState:UIControlStateNormal];
    
    UIImage *sleepBtnImaged=[UIImage imageNamed:@"gamestylesleeped.png"];
    UIImage *sleepBtnImage=[UIImage imageNamed:@"gamestylesleep.png"];
    
    [self.sleepBtn setImage:sleepBtnImaged forState:UIControlStateHighlighted];
    [self.sleepBtn setImage:sleepBtnImage forState:UIControlStateNormal];
    


    UIImage* okBgImage=[UIImage imageNamed:@"ok_bg.png"];
    okBgImage=[okBgImage stretchableImageWithLeftCapWidth:9 topCapHeight:2];
    [self.okBtn setBackgroundImage:okBgImage forState:UIControlStateHighlighted];
    
    UIImage* cancleBgImage=[UIImage imageNamed:@"cancle_bg.png"];
    cancleBgImage=[cancleBgImage stretchableImageWithLeftCapWidth:1 topCapHeight:1 ];
    [self.cancleBtn setBackgroundImage:cancleBgImage forState:UIControlStateHighlighted];

}
-(IBAction)defaultBtnPressUp:(id)sender
{
    [AppDelegate exChangeOut:self.alertView dur:0.6];
    
    [[NSUserDefaults standardUserDefaults] setObject:DefaultModel forKey:Model ];

    self.imageStr=[NSString stringWithFormat:@"%@",@"gamestyledefaultlogo.png"];
    NSString*titleStr=[NSString stringWithFormat:@"%@",@"默认模式"];
    NSString *detailStr=@"为游戏玩家精心打造拦截广告,清空缓存提升游戏速度 ！";
    [self showAlertView:detailStr title:titleStr];
}

-(IBAction)gamestyleBtnPress:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:GameModel forKey:Model ];

    [AppDelegate exChangeOut:self.alertView dur:0.6];

    self.imageStr=[NSString stringWithFormat:@"%@",@"gamestylegamelogo.png"];

    NSString*titleStr=[NSString stringWithFormat:@"%@",@"游戏模式"];
    NSString *detailStr=@"为游戏玩家精心打造拦截广告,清空缓存提升游戏速度 ！";

    [self showAlertView:detailStr title:titleStr];

}
-(IBAction)sleepBtnPress:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:SleepModle forKey:Model ];

    [AppDelegate exChangeOut:self.alertView dur:0.6];

    self.imageStr=[NSString stringWithFormat:@"%@",@"gamestylesleeplogo.png"];
    NSString*titleStr=[NSString stringWithFormat:@"%@",@"睡眠模式"];
    NSString *detailStr=@"为游戏玩家精心打造拦截广告,清空缓存提升游戏速度 ！";


    [self showAlertView:detailStr title:titleStr];

}
-(IBAction)buyBtnPress:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:BuyModel forKey:Model ];

    [AppDelegate exChangeOut:self.alertView dur:0.6];

    self.imageStr=[NSString stringWithFormat:@"%@",@"gamestylebuylogo.png"];
    NSString*titleStr=[NSString stringWithFormat:@"%@",@"购物模式"];
    NSString *detailStr=@"为游戏玩家精心打造拦截广告,清空缓存提升游戏速度 ！";

    [self showAlertView:detailStr title:titleStr];
}
-(IBAction)okBtnPress:(id)sender
{
    [delegate selectFinish:self.imageStr title:self.styleStr];
    [self removeCurrentController];
}
-(void)showAlertView:(NSString*)str title:(NSString*)title
{
    [self.alertView setHidden:NO];
    self.stytleDetailLabel.text=str;
    self.stytleTitleLabel.text=title;
    self.styleStr=[NSString stringWithFormat:@"%@%@",@"   ",title];
    UIImage *image=[UIImage imageNamed:self.imageStr];
    self.alertImageView.image=image;
    self.alertImageView.center=self.stytleTitleLabel.center;
 
    self.alertImageView.frame=CGRectMake(131-image.size.width/1.5, self.alertImageView.frame.origin.y, image.size.width/1.5, image.size.height/1.5);
  
    [self.alertDetailView setHidden:YES];
}
-(IBAction)cancleBtnPress:(id)sender
{
    [self removeCurrentController];
}
-(void)removeCurrentController
{
    [self.alertDetailView setHidden:NO];
    [self.alertView setHidden:YES];
    [self.view removeFromSuperview];
}
-(IBAction)turnBtnPress:(id)sender
{
    [self removeCurrentController];
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
