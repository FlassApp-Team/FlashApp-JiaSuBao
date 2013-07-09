//
//  APNViewController.m
//  flashapp
//
//  Created by 李 电森 on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "APNViewController.h"
#import "AppDelegate.h"
#import "StringUtil.h"
#import "REString.h"

@interface APNViewController ()
- (void) selectButton:(UIButton*) button selected:(BOOL)selected;
- (void) installAPN;
@end

@implementation APNViewController

@synthesize submitButton;
@synthesize apnTextField;
@synthesize cuButton;
@synthesize ctButton;
@synthesize cmButton;
@synthesize otherBtn;
@synthesize cmLabel;
@synthesize ctLabel;
@synthesize cuLabel;
@synthesize descLabel1;
@synthesize descLabel2;
@synthesize apnLabel;
@synthesize textBgImageView;//add jianfei han
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) dealloc
{
    [submitButton release];
    [apnTextField release];
    [cuButton release];
    [cmButton release];
    [ctButton release];
    [bgImageView release];
    
    [cmLabel release];
    [ctLabel release];
    [cuLabel release];
    [descLabel1 release];
    [descLabel2 release];
    [apnLabel release];
    
    self.textBgImageView=nil;
    self.otherBtn=nil;
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImage *image=[UIImage imageNamed:@"feedback_text_bg.png"];
    image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    self.textBgImageView.image=image;
    
    UIImage *image1=[UIImage imageNamed:@"unlock_bg.png"];
    image1=[image1 stretchableImageWithLeftCapWidth:image1.size.width/2 topCapHeight:image1.size.height/2];
    [submitButton setBackgroundImage:image1 forState:UIControlStateNormal];
    
    apnTextField.returnKeyType=UIReturnKeyDone;
    NSString* apnName = [[NSUserDefaults standardUserDefaults] objectForKey:@"apnName"];
    if ( [@"3gnet" compare:apnName] == NSOrderedSame ) {
        [self selectButton:cuButton selected:YES];
        selectedRadio = RADIO_CU;
    }
    else if ( [@"cmnet" compare:apnName] == NSOrderedSame ) {
        [self selectButton:cmButton selected:YES];
        selectedRadio = RADIO_CM;
    }
    else if ( [@"ctnet" compare:apnName] == NSOrderedSame ) {
        [self selectButton:ctButton selected:YES];
        selectedRadio = RADIO_CT;
    }
    else if ( apnName ) {
        self.apnTextField.text = apnName;
        selectedRadio = RADIO_DEFINE;
    }
    else {
        selectedRadio = RADIO_UNSELECTED;
    }
    
    cuLabel.text = NSLocalizedString(@"set.APNView.3gnet.name", nil);
    cmLabel.text = NSLocalizedString(@"set.APNView.cmnet.name", nil);
    ctLabel.text = NSLocalizedString(@"set.APNView.ctnet.name", nil);
    apnLabel.text = NSLocalizedString(@"set.APNView.apn.name", nil);
    descLabel1.text = NSLocalizedString(@"set.APNView.descLabel1.text", nil);
    descLabel2.text = NSLocalizedString(@"set.APNView.descLabel2.text", nil);
    apnTextField.placeholder = NSLocalizedString(@"set.APNView.apnField.placeholder", nil);
    [submitButton setTitle:NSLocalizedString(@"defineName", nil) forState:UIControlStateNormal];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.submitButton = nil;
    self.apnTextField = nil;
    self.ctButton = nil;
    self.cmButton = nil;
    self.cuButton = nil;
    self.otherBtn = nil;
    self.textBgImageView=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (BOOL) checkAPNName:(NSString*)apnName
{
    BOOL result = NO;
    result = [apnName matches:@"^[0-9|a-z|A-Z|\\-|_|.|']+$" withSubstring:nil];
    if ( result ) return YES;
    else return NO;
}



- (void) save
{
    NSString* apnName = nil;
    NSString* message;
    
    if ( selectedRadio == RADIO_CU ) {
        apnName = @"3gnet";
        message = [NSString stringWithFormat:@"%@(%@)，%@", NSLocalizedString(@"set.APNView.3gnet.save.message", nil), apnName,NSLocalizedString(@"set.APNView.apn.save.message", nil)];
    }
    else if ( selectedRadio == RADIO_CM ) {
        apnName = @"cmnet";
        message = [NSString stringWithFormat:@"%@(%@)，%@", NSLocalizedString(@"set.APNView.cmnet.save.message", nil), apnName,NSLocalizedString(@"set.APNView.apn.save.message", nil)];
    }
    else if ( selectedRadio == RADIO_CT ) {
        apnName = @"ctnet";
        message = [NSString stringWithFormat:@"%@(%@)，%@", NSLocalizedString(@"set.APNView.ctnet.save.message", nil), apnName,NSLocalizedString(@"set.APNView.apn.save.message", nil)];
    }
    else if ( selectedRadio == RADIO_DEFINE ) {
        apnName = [apnTextField.text trim];
        if ( ![self checkAPNName:apnName] ) {
            [AppDelegate showAlert:NSLocalizedString(@"set.APNView.checkAPNName.message", nil)];
            return;
        }
        
        message = [NSString stringWithFormat:@"%@%@，是否确认并安装新的描述文件？",  NSLocalizedString(@"set.APNView.showAPNName.message", nil),apnName];
    }
    else {
        [AppDelegate showAlert:@"请选择你要设置的APN"];
        return;
    }
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    [alertView release];
}


- (void) radioClick:(id)sender
{
    UIButton* button = (UIButton*)sender;
    [self selectButton:button selected:YES];
    
    if ( button != cuButton ) {
        [self selectButton:cuButton selected:NO];
    }
    else {
        selectedRadio = RADIO_CU;
    }

    if ( button != cmButton ) {
        [self selectButton:cmButton selected:NO];
    }
    else {
        selectedRadio = RADIO_CM;
    }

    if ( button != ctButton ) {
        [self selectButton:ctButton selected:NO];
    }
    else {
        selectedRadio = RADIO_CT;
    }
    if(button!=otherBtn)
    {
        [self selectButton:otherBtn selected:NO];
    }
    else{
        selectedRadio=RADIO_UNSELECTED;
    }
    [apnTextField resignFirstResponder];
}


- (void) selectButton:(UIButton*) button selected:(BOOL)selected
{
    if ( selected ) {
        [button setImage:[UIImage imageNamed:@"select_point.png"] forState:UIControlStateNormal];
    }
    else {
        [button setImage:[UIImage imageNamed:@"no_select_point.png"] forState:UIControlStateNormal];
    }
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 1 ) {
        [self installAPN];
    }
}


- (void) installAPN
{
    NSString* apnName = nil;
    if ( selectedRadio == RADIO_CU ) {
        apnName = @"3gnet";
    }
    else if ( selectedRadio == RADIO_CM ) {
        apnName = @"cmnet";
    }
    else if ( selectedRadio == RADIO_CT ) {
        apnName = @"ctnet";
    }
    else {
        apnName = [apnTextField.text trim];
        if ( ![self checkAPNName:apnName] ) {
            [AppDelegate showAlert:NSLocalizedString(@"set.APNView.checkAPNName.null", nil)];
            return;
        }
    }

    
    [AppDelegate installProfile:@"datasave" vpnn:apnName interfable:@"0"];
}


#pragma mark - UITextFieldDelegate

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    [cuButton setImage:[UIImage imageNamed:@"no_select_point.png"] forState:UIControlStateNormal];
    [cmButton setImage:[UIImage imageNamed:@"no_select_point.png"] forState:UIControlStateNormal];
    [ctButton setImage:[UIImage imageNamed:@"no_select_point.png"] forState:UIControlStateNormal];
    [otherBtn setImage:[UIImage imageNamed:@"select_point.png"] forState:UIControlStateNormal];

    selectedRadio = RADIO_DEFINE;
    
}
-(IBAction)turnPbtnPress:(id)sender
{
    [[sysdelegate navController  ] popViewControllerAnimated:YES];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [apnTextField resignFirstResponder];
    return YES;
}

@end
