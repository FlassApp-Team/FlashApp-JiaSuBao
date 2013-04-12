//
//  StarTwoViewController.h
//  FlashApp
//
//  Created by lidiansen on 12-12-27.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StarTwoViewController : UIViewController
{
}
@property(nonatomic,retain)IBOutlet UIActivityIndicatorView *ativty;
@property(nonatomic,retain)IBOutlet UIView *bgView;
@property(nonatomic,retain)IBOutlet UIImageView*imageView;
@property(nonatomic,retain)IBOutlet UIButton *starBtn;
@property(nonatomic,retain)IBOutlet UIButton *installBtn;
-(IBAction)starServe:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *shoudongLabel;
@property (retain, nonatomic) IBOutlet UILabel *zidongLabel;
@property (retain, nonatomic) IBOutlet UILabel *apnLabel;
@property (retain, nonatomic) IBOutlet UILabel *vpnLabel;
@property (retain, nonatomic) IBOutlet UILabel *zidonghelpLabel;
@property (retain, nonatomic) IBOutlet UILabel *shoudongHelpLabel;
@property (retain, nonatomic) IBOutlet UIButton *zidongBtn;
@property (retain, nonatomic) IBOutlet UIButton *shoudongBtn;
@property (retain, nonatomic) IBOutlet UIImageView *miaoshuimageView;
@end
