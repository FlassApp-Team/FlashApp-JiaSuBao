//
//  AboutFlashViewController.h
//  FlashApp
//
//  Created by lidiansen on 13-1-22.
//  Copyright (c) 2013年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutFlashViewController : UIViewController
@property(nonatomic,retain)IBOutlet UIButton*serverBtn;
@property(nonatomic,retain)IBOutlet UIButton*turnBtn;
@property(nonatomic,retain)IBOutlet UIButton*fankuiBtn;
@property(nonatomic,retain)IBOutlet UIButton*btn1;
@property(nonatomic,retain)IBOutlet UIButton*btn2;
@property(nonatomic,retain)IBOutlet UIButton*btn3;
@property(nonatomic,retain)IBOutlet UILabel*versionLabel;

-(IBAction)openUrlBtnPress:(id)sender;
-(IBAction)turnBtnPress:(id)sender;
-(IBAction)fankuiBtnPress:(id)sender;
-(IBAction)serverBtnPress:(id)sender;
@end
