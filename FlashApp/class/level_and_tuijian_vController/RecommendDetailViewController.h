//
//  RecommendDetailViewController.h
//  FlashApp
//
//  Created by lidiansen on 12-12-24.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendDetailViewController : UIViewController


@property(nonatomic,retain)NSString *downLoadUrl;
@property(nonatomic,retain)IBOutlet UIButton *installBtn;
@property(nonatomic,retain)IBOutlet UIImageView *headImageView;
@property(nonatomic,retain)IBOutlet UILabel *appNameLabel;
@property(nonatomic,retain)IBOutlet UILabel *appSizeLabel;
@property(nonatomic,retain)IBOutlet UILabel *feibiLabel;
@property(nonatomic,retain)IBOutlet UITextView *textView;

@property(nonatomic,retain)IBOutlet UIImageView *stareImageView1;
@property(nonatomic,retain)IBOutlet UIImageView *stareImageView2;
@property(nonatomic,retain)IBOutlet UIImageView *stareImageView3;
@property(nonatomic,retain)IBOutlet UIImageView *stareImageView4;
@property(nonatomic,retain)IBOutlet UIImageView *stareImageView5;


@property(nonatomic,retain)NSString *linkUrl;
@property(nonatomic,retain)NSString *appName;
@property(nonatomic,retain)NSString *appSize;
@property(nonatomic,retain)NSString *appDescibe;
@property(nonatomic,assign)NSInteger appStar;
@property(nonatomic,retain)UIImage *appIcon;





-(IBAction)installBtnPress:(id)sender;
-(IBAction)turnBtnPress:(id)sender;
@end
