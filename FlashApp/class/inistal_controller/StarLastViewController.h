//
//  StarLastViewController.h
//  FlashApp
//
//  Created by lidiansen on 12-12-27.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FeedbackViewController;
@interface StarLastViewController : UIViewController
@property(nonatomic,retain)FeedbackViewController*feedbackViewController;
@property(nonatomic,retain)IBOutlet UIButton *feedBackBtn;
-(IBAction)turnBtnPress:(id)sender;
-(IBAction)feedBackBtnPress:(id)sender;
-(IBAction)againBtnPress:(id)sender;
@end
