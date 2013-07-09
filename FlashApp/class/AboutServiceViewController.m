//
//  AboutServiceViewController.m
//  FlashApp
//
//  Created by lidiansen on 13-1-30.
//  Copyright (c) 2013年 lidiansen. All rights reserved.
//

#import "AboutServiceViewController.h"

@interface AboutServiceViewController ()

@end

@implementation AboutServiceViewController

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
    // Do any additional setup after loading the view from its nib.
}
-(IBAction)turnBtnPress:(id)sender
{
    [[sysdelegate navController  ] popViewControllerAnimated:YES];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
