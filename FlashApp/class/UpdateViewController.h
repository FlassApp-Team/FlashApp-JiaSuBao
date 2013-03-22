//
//  UpdateViewController.h
//  FlashApp
//
//  Created by lidiansen on 12-12-28.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
@interface UpdateViewController : UIViewController<ASIHTTPRequestDelegate,UIAlertViewDelegate>
@property(nonatomic,retain)NSDictionary*dic;
@property(nonatomic,retain)IBOutlet UIButton *cancleBtn;
@property(nonatomic,retain)IBOutlet UIImageView *bgImageView;
@property(nonatomic,retain)IBOutlet UIActivityIndicatorView *activity;
@property(nonatomic,retain)IBOutlet UIView *bgView;
-(IBAction)cancleBtnPress:(id)sender;
@end
