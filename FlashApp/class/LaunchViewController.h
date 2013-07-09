//
//  LaunchViewController.h
//  FlashApp
//
//  Created by lidiansen on 12-12-28.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGLabel.h"
@interface LaunchViewController : UIViewController
@property(nonatomic,retain)IBOutlet UIImageView*saveImageView;
@property(nonatomic,retain)IBOutlet UIImageView*imageView;
@property(nonatomic,retain)IBOutlet UIView *lodingView;
@property(nonatomic,retain)IBOutlet CGLabel *saveDataLabel;
@property(nonatomic,retain)IBOutlet CGLabel *MBLabel;
@property(nonatomic,retain)IBOutlet CGLabel *MBdataLabel;
@property(nonatomic,retain)IBOutlet CGLabel*tcLabel;
@end
