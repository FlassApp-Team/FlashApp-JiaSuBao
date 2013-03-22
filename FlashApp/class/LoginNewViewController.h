//
//  LoginNewViewController.h
//  flashapp
//
//  Created by Qi Zhao on 12-7-28.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttributedButton.h"
#import "TwitterClient.h"
#import "LoadingView.h"

@interface LoginNewViewController : UIViewController <UITextFieldDelegate>
{
    UIButton* sinaButton;
    UIButton* renrenButton;
    UIButton* qqButton;
    UIButton* baiduButton;
    AttributedButton* registerButton;
    AttributedButton* forgotPasswdButton;
    UIButton* loginButton;
    UIScrollView* scrollView;
    UIImageView* bgImageView;
    
    UITextField* phoneTextField;
    UITextField* passwordTextField;
    LoadingView* loadingView;
    
    TwitterClient* client;
}

@property(nonatomic,retain)UIViewController*viewController;//add jianfei han 

@property (nonatomic, retain) IBOutlet UIButton* TXButton;

@property (nonatomic, retain) IBOutlet UIButton* sinaButton;
@property (nonatomic, retain) IBOutlet UIButton* renrenButton;
@property (nonatomic, retain) IBOutlet UIButton* qqButton;
@property (nonatomic, retain) IBOutlet UIButton* baiduButton;
@property (nonatomic, retain) IBOutlet AttributedButton* registerButton;
@property (nonatomic, retain) IBOutlet AttributedButton* forgotPasswdButton;
@property (nonatomic, retain) IBOutlet UIButton* loginButton;
@property (nonatomic, retain) IBOutlet UITextField* phoneTextField;
@property (nonatomic, retain) IBOutlet UITextField* passwordTextField;

-(IBAction)turnBtnPress:(id)sender;

- (IBAction) doRegister;
- (IBAction) forgotPassword;
- (IBAction) login:(id)sender;
- (IBAction) loginBySina;
- (IBAction) loginByRenren;
- (IBAction) loginByQQ;
- (IBAction) loginByBaidu;
- (IBAction) loginByWangyiweibo;
-(IBAction)loginTX;
@end
