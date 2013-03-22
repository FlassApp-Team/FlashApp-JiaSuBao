//
//  ImageQualityViewController.h
//  FlashApp
//
//  Created by lidiansen on 12-12-20.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserSettings.h"
@interface ImageQualityViewController : UIViewController
{
    float knobButtonAngle;
    PictureQsLevel picQsLevel;

}
@property(nonatomic,retain)IBOutlet UIImageView*firstImageView;
@property(nonatomic,retain)IBOutlet UIButton *knob;
@property(nonatomic,retain)IBOutlet UIImageView *photoBgImageView;
@property (nonatomic, retain) IBOutlet UIImageView* leftTopLine;
@property (nonatomic, retain) IBOutlet UIImageView* leftBottomLine;
@property (nonatomic, retain) IBOutlet UIImageView* rightTopLine;
@property (nonatomic, retain) IBOutlet UIImageView* rightBottomLine;
@property (nonatomic, retain) IBOutlet UILabel* leftTopLabel;
@property (nonatomic, retain) IBOutlet UILabel* leftBottomLabel;
@property (nonatomic, retain) IBOutlet UILabel* rightTopLabel;
@property (nonatomic, retain) IBOutlet UILabel* rightBottomLabel;
@property (nonatomic, retain) IBOutlet UIImageView* knobImageView;
@property (nonatomic, retain) IBOutlet UIImageView* picutureImageView;
@property (nonatomic, retain) IBOutlet UILabel* radioLabel;
- (IBAction) knobClick:(id)sender;
-(IBAction)turnBack:(id)sender;

@end
