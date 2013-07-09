//
//  NoLoginViewController.m
//  FlashApp
//
//  Created by lidiansen on 13-1-25.
//  Copyright (c) 2013年 lidiansen. All rights reserved.
//

#import "NoLoginViewController.h"

@interface NoLoginViewController ()

@end

@implementation NoLoginViewController
@synthesize bgImageView;
-(void)dealloc
{
    self.bgImageView=nil;
    
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
    UIImage*image=[UIImage imageNamed:@"login_prompt.png"];
    image=[image stretchableImageWithLeftCapWidth:52.0 topCapHeight:12.0];
    self.bgImageView.image=image;
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)fullBtnPress:(id)sender
{
    [self.view removeFromSuperview];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
