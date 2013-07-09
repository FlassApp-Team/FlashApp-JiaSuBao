//
//  GoLineModleViewController.h
//  FlashApp
//
//  Created by lidiansen on 12-12-26.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBUtton.h"
#import "CGLabel.h"

@interface GoLineModleViewController : UIViewController
{
    
}
@property(nonatomic,assign)int flag;
@property(nonatomic,retain)IBOutlet CGLabel *wigiTitleLabel;
@property(nonatomic,retain)IBOutlet CGLabel*golingMessLabel;
@property(nonatomic,retain)IBOutlet UIView*warningView;
@property(nonatomic,retain)IBOutlet CGLabel*warningLabel;
@property(nonatomic,retain)IBOutlet CustomBUtton *warningBtn;

@property(nonatomic,retain)IBOutlet UIView*normalView;
@property(nonatomic,retain)IBOutlet CustomBUtton *netWorkBtn;
@property(nonatomic,retain)IBOutlet CGLabel *speedLabel;
@property(nonatomic,retain)IBOutlet CGLabel*persentLabel;

@property(nonatomic,retain)IBOutlet UIView*wigiView;
@property(nonatomic,retain)IBOutlet CustomBUtton*wifiBtn;
@property(nonatomic,retain)IBOutlet CGLabel*wifiLabel;

-(void)judegServerOpen;

@end
