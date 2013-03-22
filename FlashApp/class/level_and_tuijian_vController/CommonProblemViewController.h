//
//  CommonProblemViewController.h
//  FlashApp
//
//  Created by lidiansen on 12-12-25.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CommonProblemViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain)IBOutlet UIButton *fankuiBtn;
//@property(nonatomic,retain)IBOutlet UIWebView *webView;
-(IBAction)turnBtnPress:(id)sender;
-(IBAction)fankuiBtnPress:(id)sender;

@end
