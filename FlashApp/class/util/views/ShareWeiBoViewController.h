//
//  ShareWeiBoViewController.h
//  FlashApp
//
//  Created by lidiansen on 12-12-19.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareWeiBoViewController : UIViewController

@property(nonatomic,retain)IBOutlet UIImageView *imageView;
@property(nonatomic,retain)IBOutlet UIView *backView;
@property(nonatomic,retain)IBOutlet UIButton *sinaBtn;
@property(nonatomic,retain)IBOutlet UIButton *TXBtn;
@property(nonatomic,retain)IBOutlet UIButton *renrenBtn;
@property(nonatomic,retain)IBOutlet UIButton *weixinBtn;
-(IBAction)sinaBtnPress:(id)sender;
-(IBAction)TXBtnPress:(id)sender;
-(IBAction)renrenBtnPress:(id)sender;
-(IBAction)weixinBtnPress:(id)sender;

-(IBAction)cancleBtn:(id)sender;
@end
