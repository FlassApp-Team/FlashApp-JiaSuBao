//
//  AccountNumberViewController.h
//  FlashApp
//
//  Created by lidiansen on 12-12-17.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserInfoViewController;
@class BoundPhoneiewController;
@interface AccountNumberViewController : UIViewController

@property(nonatomic,retain)IBOutlet UILabel *balancelLabel;
@property(nonatomic,retain)IBOutlet UILabel *jiangliLabel1;
@property(nonatomic,retain)IBOutlet UILabel *jiangliLabel2;
@property(nonatomic,retain)IBOutlet UILabel *jiangliLabel3;
@property(nonatomic,retain)IBOutlet UILabel *jiangliLabel4;
@property(nonatomic,retain)IBOutlet UILabel *jiangliLabel5;
@property(nonatomic,retain)IBOutlet UILabel *jiangliLabel6;
@property(nonatomic,retain)IBOutlet UILabel *jiangliLabel7;

@property(nonatomic,retain)IBOutlet UIButton *turnBtn;
@property(nonatomic,retain)IBOutlet UIButton *bangDingBtn;


@property(nonatomic,retain)IBOutlet UIButton *feiBiBtn;
@property(nonatomic,retain)IBOutlet UIButton *buyBtn;
@property(nonatomic,retain)IBOutlet UIButton *detailBtn;
@property(nonatomic,retain)UserInfoViewController *userInfoViewController;
@property(nonatomic,retain)BoundPhoneiewController *boundPhoneiewController;

@property(nonatomic,retain)IBOutlet UIView *backView;

-(IBAction)bangDingBtnPress:(id)sender;
-(IBAction)turnBtnPress:(id)sender;


-(IBAction)feiBiBtnPress:(id)sender;
-(IBAction)buyBtnPress:(id)sender;
-(IBAction)detailBtnPress:(id)sender;

@end
