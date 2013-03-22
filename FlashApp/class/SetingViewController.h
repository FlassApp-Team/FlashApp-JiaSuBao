//
//  SetingViewController.h
//  FlashApp
//
//  Created by lidiansen on 12-12-21.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserInfoViewController;
@class UpdateViewController;
@class BoundPhoneiewController;
@interface SetingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
}
@property(nonatomic,assign)    BOOL compressionServer;
@property(nonatomic,retain)IBOutlet UIImageView *bigImageView;

@property(nonatomic,retain)IBOutlet UITableView *setTableView;
@property(nonatomic,retain) UIView *bgView;

@property(nonatomic,retain)NSMutableArray *dataArray;
@property(nonatomic,retain)IBOutlet UIButton *fanKuiBtn;

@property(nonatomic,retain)BoundPhoneiewController*boundPhoneiewController;
@property(nonatomic,retain)UserInfoViewController *userInfoViewController;
@property(nonatomic,retain)UpdateViewController *updateViewController;
-(void)refresh;


-(IBAction)fankuiBtnPress:(id)sender;
-(IBAction)turnBrnPress:(id)sender;

@end
