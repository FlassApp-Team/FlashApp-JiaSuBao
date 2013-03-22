//
//  StarThreeViewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-27.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import "StarThreeViewController.h"
#import "StarLastViewController.h"
#import "ViewController.h"
@interface StarThreeViewController ()

@end

@implementation StarThreeViewController
@synthesize starLastViewController;
@synthesize installBtn;
@synthesize notInstallBtn;
@synthesize viewController;
-(void)dealloc
{
    self.viewController=nil;
    self.installBtn=nil;
    self.notInstallBtn=nil;
    self.starLastViewController=nil;
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
   // [self.notInstallBtn sett]
    // Do any additional setup after loading the view from its nib.
}
-(IBAction)installedBtnPress:(id)sender
{
    if(self.viewController==nil)
    {
        if(iPhone5)
        {
            self.viewController=[[[ViewController alloc]initWithNibName:@"ViewController_iphone5" bundle:nil] autorelease];
        }
        else
        {
            self.viewController=[[[ViewController alloc]init] autorelease];

        }
        [[sysdelegate navController  ]pushViewController:self.viewController animated:NO];
    }
}

-(IBAction)notInstalledBtnPress:(id)sender
{

        StarLastViewController*starLastController=[[[StarLastViewController alloc]init] autorelease];
        [[sysdelegate navController  ]pushViewController:starLastController animated:NO];
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
