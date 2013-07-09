//
//  StarThreeViewController.h
//  FlashApp
//
//  Created by lidiansen on 12-12-27.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StarLastViewController ;
@class ViewController;
@interface StarThreeViewController : UIViewController
@property(nonatomic,retain)IBOutlet UIButton *installBtn;
@property(nonatomic,retain)IBOutlet UIButton *notInstallBtn;

-(IBAction)installedBtnPress:(id)sender;
-(IBAction)notInstalledBtnPress:(id)sender;

@property(nonatomic,retain)StarLastViewController *starLastViewController;
@property(nonatomic,retain)ViewController *viewController;

@end
