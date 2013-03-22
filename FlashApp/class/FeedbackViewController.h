//
//  FeedbackViewController.h
//  FlashApp
//
//  Created by lidiansen on 12-12-25.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//
#import <MessageUI/MessageUI.h>

#import <UIKit/UIKit.h>
#import "TwitterClient.h"
@interface FeedbackViewController : UIViewController<UITextViewDelegate, UITextFieldDelegate, MFMessageComposeViewControllerDelegate, UIAlertViewDelegate>
{
    TwitterClient* client;
    
    BOOL showClose;
}
@property(nonatomic,retain)IBOutlet UIImageView *topImageView;
@property(nonatomic,retain)IBOutlet UIImageView *bottomImageView;


@property (nonatomic, retain) IBOutlet UITextView* textView;
@property (nonatomic, retain) IBOutlet UITextField* contactField;
@property (nonatomic, retain) IBOutlet UIButton* submitButton;

-(IBAction)turnBtnPress:(id)sender;
- (IBAction) save;
@end
