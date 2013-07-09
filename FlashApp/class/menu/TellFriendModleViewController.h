//
//  TellFriendModleViewController.h
//  FlashApp
//
//  Created by lidiansen on 12-12-26.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "CustomBUtton.h"
@interface TellFriendModleViewController : UIViewController<UIActionSheetDelegate,MFMessageComposeViewControllerDelegate>
@property(nonatomic,retain)IBOutlet CustomBUtton *tellBtn;
@end
