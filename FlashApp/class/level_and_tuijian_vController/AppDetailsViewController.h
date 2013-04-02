//
//  AppDetailsViewController.h
//  FlashApp
//
//  Created by 朱广涛 on 13-4-1.
//  Copyright (c) 2013年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDetailsViewController : UIViewController

@property (retain, nonatomic) IBOutlet UIView *bgView;
@property (retain, nonatomic) IBOutlet UIScrollView *bgScroll;
@property (retain, nonatomic) IBOutlet UIImageView *appImage;
@property (retain, nonatomic) IBOutlet UILabel *appName;
@property (retain, nonatomic) IBOutlet UILabel *appSize;
@property (retain, nonatomic) IBOutlet UILabel *appLiYou;
@property (retain, nonatomic) IBOutlet UILabel *appMiaoshu;
@property (retain, nonatomic) IBOutlet UIImageView *starImageView;
@property (retain, nonatomic) IBOutlet UIImageView *starImageView2;
@property (retain, nonatomic) IBOutlet UIImageView *starImageView3;
@property (retain, nonatomic) IBOutlet UIImageView *starImageView4;
@property (retain, nonatomic) IBOutlet UIImageView *starImageView5;
@property (nonatomic ,retain) UIImage *appImages;
@property (nonatomic ,retain) NSMutableDictionary *appDic;
@property (nonatomic ,copy) NSString *appDownloadUrl;
@property (nonatomic ,assign)int appStar;


@end
