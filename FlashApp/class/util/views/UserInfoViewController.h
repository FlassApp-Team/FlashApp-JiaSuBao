//
//  UserInfoViewController.h
//  FlashApp
//
//  Created by lidiansen on 12-12-17.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGLabel.h"

@interface UserInfoViewController : UIViewController
@property(nonatomic,retain)IBOutlet UIButton *detailBtn;

@property(nonatomic,retain)IBOutlet UIImageView *nologoImageView;
@property(nonatomic,retain)IBOutlet UIImageView*logoImageView;
@property(nonatomic,retain)IBOutlet UIImageView *levelImageView;
@property(nonatomic,retain)IBOutlet UIImageView *feibiImageView;
@property(nonatomic,retain)IBOutlet CGLabel *nameLabel;
@property(nonatomic,retain)IBOutlet CGLabel *levelOrFeiBiLabel;
@property(nonatomic,retain)IBOutlet UIView *noLogoView;
@property(nonatomic,retain)IBOutlet UIView *logoView;


@property(nonatomic,retain)IBOutlet UIImageView*kuangImageView;
@property(nonatomic,retain)IBOutlet UIImageView *nameLineImageView;
@property(nonatomic,retain)IBOutlet UIImageView *feibiLineImageView;
//+ (UserInfoViewController*)sharedUserInfoViewController;

-(void)setFrameOfTwoView;
@end
