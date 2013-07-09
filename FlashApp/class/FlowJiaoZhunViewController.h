//
//  FlowJiaoZhunViewController.h
//  FlashApp
//
//  Created by lidiansen on 12-12-19.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterClient.h"
#import "ProfileTipView.h"
#import "ButtonPickerView.h"
@interface FlowJiaoZhunViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>
{
    BOOL dirty;
    BOOL locationFlag;
    ProfileTipView* messageView;
    ButtonPickerView* pickerView;

}
@property(nonatomic,retain)UIViewController*controller;

@property(nonatomic,retain)NSArray *pickerData;
@property (nonatomic, retain) TwitterClient* client;

@property(nonatomic,retain)IBOutlet UILabel *taocanCountLabel;

@property(nonatomic,retain)IBOutlet UILabel *benyueCountLabel;

@property(nonatomic,retain)IBOutlet UILabel *yuejieLabel;
@property(nonatomic,retain)IBOutlet UILabel *yuejieDetailLabel;
@property(nonatomic,retain)IBOutlet UILabel *yuejieCountLabel;

@property(nonatomic,retain)IBOutlet UILabel *jingqueLabel;
@property(nonatomic,retain)IBOutlet UILabel *jingqueDetailLabel;
@property(nonatomic,retain)IBOutlet UILabel *stateLabel;
@property(nonatomic,retain)IBOutlet UIImageView *locationIcon;
@property(nonatomic,retain)IBOutlet UIButton *turnOnBtn;

@property(nonatomic,retain)IBOutlet UILabel *liuliangLabel;
@property(nonatomic,retain)IBOutlet UILabel *liuliangDetailLabel;
@property(nonatomic,retain)IBOutlet UILabel *liuliangCountLabel;


@property(nonatomic,retain)IBOutlet UIButton *taocanBtn;
@property(nonatomic,retain)IBOutlet UIButton *benyueBtn;
@property(nonatomic,retain)IBOutlet UIButton *yuejienBtn;
@property(nonatomic,retain)IBOutlet UIButton *jingqueBtn;
@property(nonatomic,retain)IBOutlet UIButton *liuliangBtn;
-(void)loadDingWei;
-(IBAction)taocanBtnPress:(id)sender;
-(IBAction)benyueBtnPress:(id)sender;
-(IBAction)yuejienBtnPress:(id)sender;
-(IBAction)jingqueBtnPress:(id)sender;
-(IBAction)liuliangBtnPress:(id)sender;
-(IBAction)turnOnBtn:(id)sender;
-(IBAction)turnBack:(id)sender;
@end
