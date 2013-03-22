//
//  DetectionViewController.h
//  FlashApp
//
//  Created by lidiansen on 13-1-19.
//  Copyright (c) 2013年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGLabel.h"
@interface DetectionViewController : UIViewController
{
int index;
}
@property(nonatomic,retain)UIViewController*controller;
@property(nonatomic,retain)IBOutlet UIActivityIndicatorView *detectActivity;

@property(nonatomic,retain)IBOutlet UIButton *turnBrn;
@property(nonatomic,retain)IBOutlet CGLabel*titleLabel;
@property(nonatomic,retain)IBOutlet CGLabel *messageLabel;
@property(nonatomic,retain)IBOutlet UIImageView *bgImageView;
@property(nonatomic,retain)IBOutlet UIImageView *wangGeImageView;
@property(nonatomic,retain)NSTimer *timer;
@property(nonatomic,retain)IBOutlet UIActivityIndicatorView *activity;
@property(nonatomic,retain)IBOutlet UIImageView *imageView1;
@property(nonatomic,retain)IBOutlet UIImageView *imageView2;
@property(nonatomic,retain)IBOutlet UIImageView *imageView3;
@property(nonatomic,retain)NSArray *viewArray;
@property(nonatomic,retain)NSArray *messageArray;
@property(nonatomic,retain)NSArray *detailArray;

-(IBAction)turnBtnPress:(id)sender;
@end
