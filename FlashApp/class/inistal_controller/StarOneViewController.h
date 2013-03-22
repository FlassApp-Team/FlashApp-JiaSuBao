//
//  StarOneViewController.h
//  FlashApp
//
//  Created by lidiansen on 12-12-27.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StarOneViewController : UIViewController
{
    int index;
}
@property(nonatomic,retain)IBOutlet UIImageView *bgImageView;
@property(nonatomic,retain)IBOutlet UIImageView *wangGeImageView;
@property(nonatomic,retain)NSTimer *timer;
@property(nonatomic,retain)IBOutlet UIButton *nextBtn;
@property(nonatomic,retain)IBOutlet UIActivityIndicatorView *activity;
@property(nonatomic,retain)NSArray *viewArray;
@property(nonatomic,retain)IBOutlet UIImageView *imageView1;
@property(nonatomic,retain)IBOutlet UIImageView *imageView2;
@property(nonatomic,retain)IBOutlet UIImageView *imageView3;
@property(nonatomic,retain)IBOutlet UIImageView *imageView4;
-(IBAction)nextBtnPress:(id)sender;
@end
