//
//  WangSuViewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-20.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import "WangSuViewController.h"
#import "IDCPickerViewController.h"
@interface WangSuViewController ()

@end

@implementation WangSuViewController
@synthesize saveBtn;
@synthesize jiFangName;
@synthesize moblieHomeDetail;
@synthesize moblieHomeImageView;
@synthesize moblieHomeName;
@synthesize moblieHomeSelect;

@synthesize shangDongDetail;
@synthesize shangDongImageView;
@synthesize shangDongName;
@synthesize shangDongSelect;
@synthesize huaDongDetail;
@synthesize huaDongImageView;
@synthesize huaDongName;
@synthesize huaDongSelect;

@synthesize titleLabel;

@synthesize wifiLabel;
@synthesize moblieLabel;
@synthesize sureBtn;

@synthesize refleshBtn;
@synthesize bgView;
@synthesize idcPickerViewController;
-(void)dealloc
{
    self.bgView=nil;
    self.idcPickerViewController=nil;
    self.moblieHomeSelect=nil;
    self.moblieHomeName=nil;
    self.moblieHomeDetail=nil;
    self.moblieHomeImageView=nil;


    
    self.shangDongSelect=nil;
    self.shangDongName=nil;
    self.shangDongDetail=nil;
    self.shangDongImageView=nil;
    
    
    self.huaDongSelect=nil;
    self.huaDongName=nil;
    self.huaDongDetail=nil;
    self.huaDongImageView=nil;
    
    self.saveBtn=nil;
    self.jiFangName=nil;
    
    self.titleLabel=nil;
    
    self.wifiLabel=nil;
    self.moblieLabel=nil;
    self.sureBtn=nil;
    self.refleshBtn=nil;
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
//    UIImage* img1=[UIImage imageNamed:@"opaque_small.png"];
//    img1=[img1 stretchableImageWithLeftCapWidth:7 topCapHeight:8];
//    
//    [self.refleshBtn setBackgroundImage:img1 forState:UIControlStateNormal];
    
    //可以更换的几个机房
    self.idcPickerViewController=[[[IDCPickerViewController alloc]init] autorelease];
    self.idcPickerViewController.view.frame=CGRectMake(0, 169, 320, self.view.frame.size.height);
    self.idcPickerViewController.controller=self;
    [self.bgView addSubview:self.idcPickerViewController.view];
    
    [AppDelegate buttonTopShadow:self.saveBtn shadowColor:[UIColor grayColor]];
}
-(void)relfresh
{
    [self.idcPickerViewController loadData];
}

-(IBAction)refleshPress:(id)sender
{
    [self relfresh];
}

-(IBAction)turnBrnPress:(id)sender
{
    [[sysdelegate navController  ] popViewControllerAnimated:YES];
}

-(IBAction)saveBtnPress:(id)sender
{
    [self.idcPickerViewController saveButtonClick:sender];
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
