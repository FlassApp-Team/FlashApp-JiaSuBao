//
//  ImageCompressViewController.h
//  FlashApp
//
//  Created by 朱广涛 on 13-5-13.
//  Copyright (c) 2013年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>
#define CAN_SAVE 110

@class UserSettings;

@interface ImageCompressViewController : UIViewController<UIAlertViewDelegate>
{
    int qs ;
    int sel_btn_tag ;
    PictureQsLevel picLevel;
    CGPoint starPoint;
    CGPoint endPoint;
}
@property (retain, nonatomic) IBOutlet UIView *btnBgView;
@property (retain, nonatomic) IBOutlet UIImageView *compressImgView;
@property (retain, nonatomic) IBOutlet UIImageView *changeGrayLine;
@property (retain, nonatomic) IBOutlet UIImageView *changeBlueLine;

//button
@property (retain, nonatomic) IBOutlet UIButton *saveBtn;

@property (retain, nonatomic) IBOutlet UIButton *noCompressBtn;
@property (retain, nonatomic) IBOutlet UIButton *imgHeightBtn;
@property (retain, nonatomic) IBOutlet UIButton *imgMiddleBtn;
@property (retain, nonatomic) IBOutlet UIButton *imgLowBtn;

@end
