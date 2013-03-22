//
//  WenTiModleViewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-26.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import "WenTiModleViewController.h"
#import "CommonProblemViewController.h"
@interface WenTiModleViewController ()

@end

@implementation WenTiModleViewController
@synthesize weitiBtn;
-(void)dealloc
{
    self.weitiBtn=nil;
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
    self.weitiBtn.controller=self;
    // Do any additional setup after loading the view from its nib.
}
-(void)nextContorller
{
    self.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    UIView *view=(UIView*)[self.view viewWithTag:101];
    [view removeFromSuperview];
    CommonProblemViewController*commonProblemViewController=[[[CommonProblemViewController alloc]init] autorelease];
    [[sysdelegate navController  ] pushViewController:commonProblemViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
