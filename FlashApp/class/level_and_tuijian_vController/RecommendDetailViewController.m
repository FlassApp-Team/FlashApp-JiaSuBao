//
//  RecommendDetailViewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-24.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import "RecommendDetailViewController.h"

@interface RecommendDetailViewController ()

@property(nonatomic,retain)IBOutlet UIView *bottomView;
@property(nonatomic)CGRect frame;

@end

@implementation RecommendDetailViewController
@synthesize textView;
@synthesize installBtn;
@synthesize downLoadUrl;
@synthesize appNameLabel;
@synthesize appSizeLabel;
@synthesize feibiLabel;
@synthesize headImageView;
@synthesize linkUrl;
@synthesize appDescibe;
@synthesize appIcon;
@synthesize appName;
@synthesize appSize;
@synthesize appStar;
@synthesize bottomView;
@synthesize frame;

@synthesize stareImageView1,stareImageView2,stareImageView3,stareImageView4,stareImageView5;
-(void)dealloc
{
    self.bottomView=nil;
    self.textView=nil;
    self.installBtn=nil;
    self.appNameLabel=nil;
    self.appSizeLabel=nil;
    self.feibiLabel=nil;
    self.headImageView=nil;
    self.downLoadUrl=nil;
    self.stareImageView1=nil;
    self.stareImageView2=nil;
    self.stareImageView3=nil;
    self.stareImageView4=nil;
    self.stareImageView5=nil;
    
    self.linkUrl=nil;
    self. appDescibe=nil;
    self.appIcon=nil;
    self. appName=nil;
    self. appSize=nil;

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
-(IBAction)installBtnPress:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.linkUrl]];
    NSLog(@"selflinkUrl===%@",self.linkUrl);
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.appSizeLabel.text=self.appSize;
    self.appNameLabel.text=self.appName;
    self.headImageView.image=self.appIcon;
    self.textView.text=self.appDescibe;
   // NSLog(@"self.appSizeLabel.text=======%@",self.appSizeLabel.text);
}

-(void)viewWillAppear:(BOOL)animated{
    self.frame=self.bottomView.frame;
    NSInteger stars=self.appStar/2;
    NSInteger halfstars=self.appStar%2;
    UIImageView *imagV;
    for(int i=0;i<stars;i++)
    {
        imagV=(UIImageView*)[self.bottomView viewWithTag:10+i];
        imagV.image=[UIImage imageNamed:@"recommend_all_star.png"];
    }
    if(halfstars){
        imagV=(UIImageView*)[self.bottomView viewWithTag:10+stars];
        imagV.image=[UIImage imageNamed:@"recommend_half_star.png"];
    }
    for(int i=halfstars+stars;i<5;i++)
    {
        imagV=(UIImageView*)[self.bottomView viewWithTag:10+i];
        imagV.image=[UIImage imageNamed:@"recommend_none_star.png"];
    }
    self.bottomView.frame=CGRectMake(0, self.view.frame.size.height, frame.size.width, frame.size.height);
}

-(void)viewDidAppear:(BOOL)animated{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.frame=self.frame;
    } completion:^(BOOL finished) {
        
    }];
}



-(IBAction)turnBtnPress:(id)sender
{
    [self.view removeFromSuperview];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
