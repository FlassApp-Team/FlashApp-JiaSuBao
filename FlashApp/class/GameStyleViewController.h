//
//  GameStyleViewController.h
//  FlashApp
//
//  Created by lidiansen on 12-12-17.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
@interface GameStyleViewController : UIViewController

@property(nonatomic,retain)IBOutlet UIImageView *alertImageView;

@property(nonatomic,assign)IBOutlet UIImageView *verticalImageView;
@property(nonatomic,assign)IBOutlet UIImageView *horizontaImageView;


@property(nonatomic,retain)IBOutlet UIView *alertView;
@property(nonatomic,retain)IBOutlet UIImageView *alertBgImageView;

@property(nonatomic,retain)IBOutlet UIView *alertDetailView;
@property(nonatomic,retain)IBOutlet UIImageView *detailImageView;

@property(nonatomic,retain)IBOutlet UIButton *okBtn;
@property(nonatomic,retain)IBOutlet UIButton *cancleBtn;

@property(nonatomic,retain)IBOutlet UILabel*stytleTitleLabel;
@property(nonatomic,retain)IBOutlet UILabel*stytleDetailLabel;

@property(assign)NSObject<ViewControllerDelegate>*delegate;
@property(nonatomic,retain)IBOutlet UIButton *defaultBtn;
@property(nonatomic,retain)IBOutlet UIButton *gamestyleBtn;
@property(nonatomic,retain)IBOutlet UIButton *sleepBtn;
@property(nonatomic,retain)IBOutlet UIButton *buyBtn;
-(IBAction)gamestyleBtnPress:(id)sender;
-(IBAction)sleepBtnPress:(id)sender;
-(IBAction)buyBtnPress:(id)sender;
-(IBAction)okBtnPress:(id)sender;
-(IBAction)cancleBtnPress:(id)sender;
-(IBAction)defaultBtnPressUp:(id)sender;

-(IBAction)turnBtnPress:(id)sender;
@end
