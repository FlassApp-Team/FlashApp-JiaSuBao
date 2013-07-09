//
//  ZhenDuanViewController.h
//  FlashApp
//
//  Created by lidiansen on 12-12-21.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpItemView.h"
typedef enum {
    CONN_CHECK_BAD,
    CONN_CHECK_SLOW
} ConnectionCheckType;


@interface ZhenDuanViewController : UIViewController
{
    HelpItemView* cellItem;
    HelpItemView* flashappItem;
    
    ConnectionCheckType checkType;
}
@property(nonatomic,retain)IBOutlet UIView*bgWiFiView;
@property(nonatomic,retain)IBOutlet UIImageView*bgImageView;
@property(nonatomic,retain)IBOutlet UIView *bgView;

@property (nonatomic, assign) ConnectionCheckType checkType;
@property(nonatomic,retain)IBOutlet UIButton *questionBtn;
@property(nonatomic,retain)IBOutlet UIButton *sureBtn;

-(IBAction)turnBrnPress:(id)sender;
-(IBAction)questionBtnPress:(id)sender;
-(IBAction)sureBtn:(id)sender;
@end
