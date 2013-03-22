//
//  SleepStyleViewController.h
//  FlashApp
//
//  Created by cai 丽亚 on 13-3-5.
//  Copyright (c) 2013年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBUtton.h"
#import "CGLabel.h"
#import "TwitterClient.h"
@interface SleepStyleViewController : UIViewController
{
    TwitterClient* twitterClient;

}
@property(nonatomic,retain)IBOutlet CustomBUtton *sleepStyleBtn;
@property(nonatomic,retain)IBOutlet CGLabel*sleepStyleLabel;
@end
