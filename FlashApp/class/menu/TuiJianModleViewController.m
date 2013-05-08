//
//  TuiJianModleViewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-26.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import "TuiJianModleViewController.h"
#import "RecommendViewController.h"
@interface TuiJianModleViewController ()

@end

@implementation TuiJianModleViewController
@synthesize recommendViewController;
@synthesize tuijianBtn;
@synthesize animationImgView;
-(void)dealloc
{
    self.tuijianBtn=nil;
    self.recommendViewController=nil;
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
    self.tuijianBtn.controller=self;
    
    /**yincangtuijian
    animationImgView = [[UIImageView alloc] initWithFrame:CGRectMake(34, 32, 55, 55)];
    [self.view addSubview:animationImgView];
    
    NSArray *animationArr = [NSArray arrayWithObjects:[UIImage imageNamed:@"app_new_up.png"],[UIImage imageNamed:@"app_new_middle.png"],[UIImage imageNamed:@"app_new_down.png"], nil];
    animationImgView.animationImages = animationArr;
    animationImgView.animationDuration = 2;
    
    BOOL newsApp = [[NSUserDefaults standardUserDefaults] boolForKey:NEWS_APP];
    if (newsApp) {
        [animationImgView startAnimating];
    }
     **/
    
    // Do any additional setup after loading the view from its nib.
}

-(void)nextContorller
{
//    [self.animationImgView stopAnimating];
    self.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    UIView *view=(UIView*)[self.view viewWithTag:101];
    [view removeFromSuperview];
    if(self.recommendViewController==nil)
        self.recommendViewController=[[[RecommendViewController alloc]init] autorelease];
    
    self.recommendViewController.showNewsAppAnimation = ^(BOOL shows){
        if (shows) {
            [self.animationImgView startAnimating];
        }else
        {
            [self.animationImgView stopAnimating];
        }
    };
    
    [[sysdelegate navController  ] pushViewController:self.recommendViewController animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
