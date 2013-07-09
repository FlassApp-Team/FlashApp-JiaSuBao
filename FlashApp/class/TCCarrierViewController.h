//
//  TCCarrierViewController.h
//  flashapp
//
//  Created by 李 电森 on 12-4-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "ButtonPickerView.h"
#import "TwitterClient.h"

@interface TCCarrierViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, MFMessageComposeViewControllerDelegate, UIAlertViewDelegate>
{
    UIImageView* bgImageView;
    UIButton* areaButton;
    UIButton* carrierButton;
    UIButton* sendButton;
    ButtonPickerView* pickerView;
    
    NSInteger selectedzone;
    NSMutableDictionary* provinces;
    NSArray* provinceCodes;
    NSDictionary* carriers;
    NSArray* carrierCodes;
    
    NSString* selectedAreaCode;
    NSString* selectedCarrierCode;
    NSString* selectedCarrierType;
    
    TwitterClient* client;
    
    UILabel* areaLabel;
    UILabel* carrierLabel;
    
}

@property (nonatomic, retain) IBOutlet UIImageView* bgImageView;
@property (nonatomic, retain) IBOutlet UIButton* areaButton;
@property (nonatomic, retain) IBOutlet UIButton* carrierButton;
@property (nonatomic, retain) IBOutlet UIButton* sendButton;
@property (nonatomic, retain) NSMutableDictionary* provinces;
@property (nonatomic, retain) NSDictionary* carriers;
@property (nonatomic, retain) NSArray* provinceCodes;
@property (nonatomic, retain) NSArray* carrierCodes;
@property (nonatomic, retain) NSString* selectedAreaCode;
@property (nonatomic, retain) NSString* selectedCarrierCode;
@property (nonatomic, retain) NSString* selectedCarrierType;
@property (nonatomic, retain) IBOutlet UILabel* areaLabel;
@property (nonatomic, retain) IBOutlet UILabel* carrierLabel;

- (IBAction) selectArea;
- (IBAction) selectCarrier;
- (IBAction) sendSmsToCarrier;
-(IBAction)turnBtnPress;
@end
