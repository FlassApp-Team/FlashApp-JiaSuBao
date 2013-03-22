//
//  APNViewController.h
//  flashapp
//
//  Created by 李 电森 on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    RADIO_UNSELECTED,
    RADIO_CU,
    RADIO_CM,
    RADIO_CT,
    RADIO_DEFINE
} APN_TYPE;


@interface APNViewController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate>
{
    UIButton* submitButton;
    UITextField* apnTextField;
    UIButton* cuButton;
    UIButton* cmButton;
    UIButton* ctButton;
    UIImageView* bgImageView;
    UIScrollView* scrollView;
    
    UILabel* cuLabel;
    UILabel* cmLabel;
    UILabel* ctLabel;
    UILabel* apnLabel;
    UILabel* descLabel1;
    UILabel* descLabel2;
    
    
    
    APN_TYPE selectedRadio;
}
@property(nonatomic,retain)IBOutlet UIImageView *textBgImageView;//add jianfei han
@property(nonatomic,retain)IBOutlet UIButton *otherBtn;
@property (nonatomic, retain) IBOutlet UIButton* submitButton;
@property (nonatomic, retain) IBOutlet UITextField* apnTextField;
@property (nonatomic, retain) IBOutlet UIButton* cuButton;
@property (nonatomic, retain) IBOutlet UIButton* cmButton;
@property (nonatomic, retain) IBOutlet UIButton* ctButton;
@property (nonatomic, retain) IBOutlet UILabel* cuLabel;
@property (nonatomic, retain) IBOutlet UILabel* cmLabel;
@property (nonatomic, retain) IBOutlet UILabel* ctLabel;
@property (nonatomic, retain) IBOutlet UILabel* descLabel1;
@property (nonatomic, retain) IBOutlet UILabel* descLabel2;
@property (nonatomic, retain) IBOutlet UILabel* apnLabel;
-(IBAction)turnPbtnPress:(id)sender;
- (IBAction) save;
- (IBAction) radioClick:(id)sender;
@end
