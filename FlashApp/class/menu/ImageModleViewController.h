//
//  ImageModleViewController.h
//  FlashApp
//
//  Created by lidiansen on 12-12-26.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBUtton.h"
#import "CGLabel.h"
@class ImageCompressViewController;
@interface ImageModleViewController : UIViewController
//@property(nonatomic,retain)ImageQualityViewController*imageQualityViewController;
@property (nonatomic ,retain) ImageCompressViewController *icvc;
@property(nonatomic,retain)IBOutlet CustomBUtton *zhiliangBtn;
@property(nonatomic,retain)IBOutlet CGLabel*zhiliangLabel;
@end
