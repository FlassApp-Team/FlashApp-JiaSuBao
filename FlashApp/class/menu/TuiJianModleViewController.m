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
    // Do any additional setup after loading the view from its nib.
}
-(void)nextContorller
{
    self.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    UIView *view=(UIView*)[self.view viewWithTag:101];
    [view removeFromSuperview];
    if(self.recommendViewController==nil)
        self.recommendViewController=[[[RecommendViewController alloc]init] autorelease];
    
    [[sysdelegate navController  ] pushViewController:self.recommendViewController animated:YES];
    
    
//    RecommendViewController*RRRConnretooler=[[[RecommendViewController alloc]init] autorelease];
//    [[sysdelegate navController  ] pushViewController:RRRConnretooler animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
