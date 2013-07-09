//
//  WangSuViewController.h
//  FlashApp
//
//  Created by lidiansen on 12-12-20.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGLabel.h"
@class IDCPickerViewController;
@interface WangSuViewController : UIViewController
@property(nonatomic,retain)IBOutlet UIView *bgView;
@property(nonatomic,retain)IDCPickerViewController *idcPickerViewController;

@property(nonatomic,retain)IBOutlet UIButton *refleshBtn;

@property(nonatomic,retain)IBOutlet CGLabel *titleLabel;


@property(nonatomic,retain)IBOutlet CGLabel *jiFangName;
@property(nonatomic,retain)IBOutlet UIImageView *moblieHomeImageView;
@property(nonatomic,retain)IBOutlet UILabel *moblieHomeName;
@property(nonatomic,retain)IBOutlet UILabel *moblieHomeDetail;
@property(nonatomic,retain)IBOutlet UIImageView *moblieHomeSelect;

@property(nonatomic,retain)IBOutlet UIImageView *shangDongImageView;
@property(nonatomic,retain)IBOutlet UILabel *shangDongName;
@property(nonatomic,retain)IBOutlet UILabel *shangDongDetail;
@property(nonatomic,retain)IBOutlet UIImageView *shangDongSelect;

@property(nonatomic,retain)IBOutlet UIImageView *huaDongImageView;
@property(nonatomic,retain)IBOutlet UILabel *huaDongName;
@property(nonatomic,retain)IBOutlet UILabel *huaDongDetail;
@property(nonatomic,retain)IBOutlet UIImageView *huaDongSelect;

@property(nonatomic,retain)IBOutlet UIButton *saveBtn;


@property(nonatomic,retain)IBOutlet UILabel *wifiLabel;
@property(nonatomic,retain)IBOutlet UILabel *moblieLabel;
@property(nonatomic,retain)IBOutlet UIButton *sureBtn;
-(IBAction)sureBtnPress:(id)sender;
-(IBAction)refleshPress:(id)sender;
-(IBAction)saveBtnPress:(id)sender;
-(IBAction)turnBrnPress:(id)sender;

-(IBAction)moblieHomeBtnPress:(id)sender;
-(IBAction)shangDongBtnPress:(id)sender;
-(IBAction)huaDongBtnPress:(id)sender;
-(void)relfresh;
@end
