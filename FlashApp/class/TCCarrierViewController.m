//
//  TCCarrierViewController.m
//  flashapp
//
//  Created by 李 电森 on 12-4-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TCCarrierViewController.h"
#import "UserSettings.h"
#import "AppDelegate.h"

#define ZONE_AREA 0
#define ZONE_CARRIER 1

@interface TCCarrierViewController ()
- (void) sendSMS:(NSString*)receipt body:(NSString*)body;
- (void) displaySMSComposerSheet:(NSString*)receipt body:(NSString*)body;
@end

@implementation TCCarrierViewController

@synthesize bgImageView;
@synthesize areaButton;
@synthesize carrierButton;
@synthesize sendButton;
@synthesize provinces;
@synthesize carriers;
@synthesize provinceCodes;
@synthesize carrierCodes;
@synthesize selectedCarrierType;
@synthesize selectedAreaCode;
@synthesize selectedCarrierCode;
@synthesize areaLabel;
@synthesize carrierLabel;

#pragma mark - init & destroy

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
    [bgImageView release];
    [areaButton release];
    [carrierButton release];
    [sendButton release];
    [pickerView release];
    [provinces release];
    [carriers release];
    [provinceCodes release];
    [carrierCodes release];
    [selectedAreaCode release];
    [selectedCarrierCode release];
    [selectedCarrierType release];
    [areaLabel release];
    [carrierLabel release];
    [super dealloc];
}


#pragma mark - view lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    pickerView = [[ButtonPickerView alloc] initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height - 240, 320, 245)];

    pickerView.autoresizingMask=UIViewAutoresizingFlexibleBottomMargin;
    [self.carrierButton setTitleColor:self.carrierButton.titleLabel.textColor forState:UIControlStateHighlighted];
    [self.areaButton setTitleColor:self.areaButton.titleLabel.textColor forState:UIControlStateHighlighted];
    pickerView.hidden = YES;
    pickerView.picker.delegate = self;
    pickerView.picker.dataSource = self;
    [self.view addSubview:pickerView];
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"SystemGlobals" ofType:@"plist"];
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:path];

    self.provinces = [NSMutableDictionary dictionaryWithDictionary:[dic objectForKey:@"provinces"]];
    [provinces removeObjectForKey:@"71"];//台湾
    [provinces removeObjectForKey:@"81"];//香港
    [provinces removeObjectForKey:@"82"];//澳门
    NSArray* arr = [provinces allKeys];
    self.provinceCodes = [arr sortedArrayUsingSelector:@selector(compare:)];
    
    self.carriers = [dic objectForKey:@"carriers"];
    arr = [carriers allKeys];
    self.carrierCodes = [arr sortedArrayUsingSelector:@selector(compare:)];
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    if ( user.areaCode && user.areaCode.length > 0 ) {
        self.selectedAreaCode = user.areaCode;
    }
    else {
        self.selectedAreaCode = [provinceCodes objectAtIndex:0];
    }
    
    if ( user.carrierCode && user.carrierType && user.carrierCode.length > 0 && user.carrierType.length > 0 ) {
        self.selectedCarrierCode = user.carrierCode;
        self.selectedCarrierType = user.carrierType;
    }
    else {
        NSString* code = [carrierCodes objectAtIndex:0];
        NSArray* arr = [code componentsSeparatedByString:@"_"];
        self.selectedCarrierCode = [arr objectAtIndex:0];
        self.selectedCarrierType = [arr objectAtIndex:1];
    }
    
    NSString* s = [provinces objectForKey:selectedAreaCode];
    if ( s ) [areaButton setTitle:s forState:UIControlStateNormal];
    
    s = [carriers objectForKey:[NSString stringWithFormat:@"%@_%@", selectedCarrierCode, selectedCarrierType]];
    if ( s ) [carrierButton setTitle:s forState:UIControlStateNormal];
    
    areaLabel.text = NSLocalizedString(@"taocan.TCCarrierView.areaLabel.text", nil);
    carrierLabel.text = NSLocalizedString(@"taocan.TCCarrierView.carrierLabel.text", nil);
    //[areaButton setTitle:NSLocalizedString(@"taocan.TCCarrierView.areaButton.title.Beijing", nil) forState:UIControlStateNormal];
    //[carrierButton setTitle:NSLocalizedString(@"taocan.TCCarrierView.carrierButton.title.cmnet", nil) forState:UIControlStateNormal];
    [sendButton setTitle:NSLocalizedString(@"taocan.TCCarrierView.sendButton.title", nil) forState:UIControlStateNormal];
    
}


- (void) viewWillDisappear:(BOOL)animated
{
    UserSettings* user = [AppDelegate getAppDelegate].user;
    if ( [selectedAreaCode compare:user.areaCode] != NSOrderedSame ||
        [selectedCarrierCode compare:user.carrierCode] != NSOrderedSame ||
        [selectedCarrierType compare:user.carrierType] != NSOrderedSame ) {
        user.areaCode = selectedAreaCode;
        user.carrierCode = selectedCarrierCode;
        user.carrierType = selectedCarrierType;
        [UserSettings saveUserSettings:user];

//        [TwitterClient getCarrierInfoSync:user.username area:selectedAreaCode code:selectedCarrierCode type:selectedCarrierType];
    }
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.bgImageView = nil;
    self.areaButton = nil;
    self.carrierButton = nil;
    self.sendButton = nil;
    
    self.provinces = nil;
    self.carriers = nil;
    self.provinceCodes = nil;
    self.carrierCodes = nil;
    self.selectedCarrierType = nil;
    self.selectedCarrierCode = nil;
    self.selectedAreaCode = nil;

    [pickerView release];
    pickerView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - operation methods
-(IBAction)turnBtnPress
{
    [[sysdelegate navController  ] popViewControllerAnimated:YES];
}
- (void) selectArea
{
    selectedzone = ZONE_AREA;
    pickerView.hidden = NO;
    [pickerView.picker reloadAllComponents];
    
    if ( selectedAreaCode && selectedAreaCode.length > 0 ) {
        NSString* c;
        for (int i=0; i<[provinceCodes count]; i++) {
            c = [provinceCodes objectAtIndex:i];
            if ( [c compare:selectedAreaCode] == NSOrderedSame ){
                [pickerView.picker selectRow:i inComponent:0 animated:YES];
                break;
            }
        }
    }
}


- (void) selectCarrier
{
    selectedzone = ZONE_CARRIER;
    pickerView.hidden = NO;
    [pickerView.picker reloadAllComponents];

    if ( selectedCarrierCode && selectedCarrierCode.length > 0 && selectedCarrierType && selectedCarrierType.length > 0 ) {
        NSString* c;
        NSString* s = [NSString stringWithFormat:@"%@_%@", selectedCarrierCode, selectedCarrierType];
        for (int i=0; i<[carrierCodes count]; i++) {
            c = [carrierCodes objectAtIndex:i];
            if ( [c compare:s] == NSOrderedSame ){
                [pickerView.picker selectRow:i inComponent:0 animated:YES];
                break;
            }
        }
    }
}


- (void) sendSmsToCarrier
{
    UserSettings* user = [AppDelegate getAppDelegate].user;
    
    BOOL changed = NO;
    if ( [selectedAreaCode compare:user.areaCode] != NSOrderedSame ||
        [selectedCarrierCode compare:user.carrierCode] != NSOrderedSame ||
        [selectedCarrierType compare:user.carrierType] != NSOrderedSame ) {
        changed = YES;
        user.areaCode = selectedAreaCode;
        user.carrierCode = selectedCarrierCode;
        user.carrierType = selectedCarrierType;
        [UserSettings saveUserSettings:user];
    }
    
    BOOL notFound = NO;
    if ( !user.carrierSmsnum || user.carrierSmsnum.length == 0 || !user.carrierSmstext || user.carrierSmstext.length == 0 ) {
        notFound = YES;
    }

    if ( notFound || changed ) {
        if ( client ) return;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        client = [[TwitterClient alloc] initWithTarget:self action:@selector(didSaveCarrierInfo:obj:)];
        [client getCarrierInfo:user.username area:selectedAreaCode code:selectedCarrierCode type:selectedCarrierType];
    }
    else {
        //发送短信
        [self sendSMS:user.carrierSmsnum body:user.carrierSmstext];
    }
}


- (void) didSaveCarrierInfo:(TwitterClient*)tc obj:(NSObject*)obj
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    client = nil;
    
    if ( !obj ) {
        UserSettings* user = [AppDelegate getAppDelegate].user;
        if ( [@"46000" compare:user.carrierCode]==NSOrderedSame ) {
            user.carrierSmsnum = @"10086";
            user.carrierSmstext = @"CXLL";
        }
        else if ( [@"46001" compare:user.carrierCode]==NSOrderedSame ) {
            user.carrierSmsnum = @"10010";
            user.carrierSmstext = @"1071";
        }
        else if ( [@"46003" compare:user.carrierCode]==NSOrderedSame ) {
            user.carrierSmsnum = @"10001";
            user.carrierSmstext = @"108";
        }
    }
    else {
        [TwitterClient parseCarrierInfo:obj];
    }
    


    //发送短信
    UserSettings* user = [AppDelegate getAppDelegate].user;
    if ( user.carrierSmsnum && user.carrierSmsnum.length > 0 && user.carrierSmstext && user.carrierSmstext.length > 0 ) {
        [self sendSMS:user.carrierSmsnum body:user.carrierSmstext];
    }
}


#pragma mark - UIPickerView Datasource

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ( selectedzone == ZONE_AREA ) {
        return [provinces count];
    }
    else {
        return [carrierCodes count];
    }
}


- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ( selectedzone == ZONE_AREA ) {
        NSString* code = [provinceCodes objectAtIndex:row];
        NSString* area = [provinces objectForKey:code];
        return area;
    }
    else {
        NSString* code = [carrierCodes objectAtIndex:row];
        NSString* carrier = [carriers objectForKey:code];
        return carrier;
    }
}


- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ( selectedzone == ZONE_AREA ) {
        NSString* code = [provinceCodes objectAtIndex:row];
        NSString* area = [provinces objectForKey:code];
        [areaButton setTitle:area forState:UIControlStateNormal];
        self.selectedAreaCode = code;
    }
    else {
        NSString* code = [carrierCodes objectAtIndex:row];
        NSString* carrier = [carriers objectForKey:code];
        [carrierButton setTitle:carrier forState:UIControlStateNormal];
        
        NSArray* arr = [code componentsSeparatedByString:@"_"];
        self.selectedCarrierCode = [arr objectAtIndex:0];
        self.selectedCarrierType = [arr objectAtIndex:1];
    }
}


#pragma mark - sms methods

- (void) sendSMS:(NSString*)receipt body:(NSString*)body
{
	Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
	if (messageClass != nil) {
		// Check whether the current device is configured for sending SMS messages
		if ([messageClass canSendText]) {
			[self displaySMSComposerSheet:receipt body:body];
		}
		else {
            [AppDelegate showAlert:NSLocalizedString(@"device.sendSMS.invalid.content", nil) message:NSLocalizedString(@"device.sendSMS.invalid.message", nil)];
		}
	}
	else {
        [AppDelegate showAlert:[NSString stringWithFormat:@"%@%@，%@%@，%@。",NSLocalizedString(@"taocan.TCCarrierView.sendSms.to",nil), receipt,NSLocalizedString(@"taocan.TCCarrierView.sendSms.content",nil), body,NSLocalizedString(@"taocan.TCCarrierView.sendSms.queryPreFlow",nil)]];
	}
}


- (void) displaySMSComposerSheet:(NSString*)receipt body:(NSString*)body
{
    if ( !receipt ) return;
    if ( receipt.length == 0 ) return;
    
	MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
	picker.messageComposeDelegate = self;
    picker.recipients = [NSArray arrayWithObjects:receipt, nil];
	picker.body = body;
    picker.title = NSLocalizedString(@"sms.picker.title", nil);
    
    [self.navigationController presentModalViewController:picker animated:YES];
	[picker release];
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)messageComposeViewController
				 didFinishWithResult:(MessageComposeResult)result {
    [self.navigationController dismissModalViewControllerAnimated:YES];
	switch (result)
	{
		case MessageComposeResultCancelled:
			break;
		case MessageComposeResultSent:
            [AppDelegate getAppDelegate].adjustSMSSend = YES;
            [[sysdelegate currentViewController].navigationController popViewControllerAnimated:YES];
			break;
		case MessageComposeResultFailed:
            [AppDelegate showAlert:NSLocalizedString(@"sms.send.fail", nil)];
			break;
		default:
			NSLog(@"Result: SMS not sent");
			break;
	}
    
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //[[[AppDelegate getAppDelegate] currentNavigationController] dismissModalViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
