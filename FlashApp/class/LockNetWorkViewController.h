//
//  LockNetWorkViewController.h
//  FlashApp
//
//  Created by lidiansen on 12-12-20.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterClient.h"
#import "LoadingView.h"
@class ShareWeiBoViewController;
@interface LockNetWorkViewController : UIViewController<UITabBarControllerDelegate,UITableViewDataSource,UIActionSheetDelegate>
{
    TwitterClient* twitterClient;
    int index;
    BOOL pdsw;
    int lockCell;
    int canLock;
}
@property(nonatomic,retain)IBOutlet UILabel *AppCountLabel;
@property(nonatomic ,retain)IBOutlet UILabel *AppCountLabel_1;
@property(nonatomic,retain)NSDictionary* allLockDic;
@property(nonatomic,retain)ShareWeiBoViewController*shareWeiBoViewController;
@property(nonatomic,retain)IBOutlet UIButton *refleshBtn;
@property(nonatomic,retain)IBOutlet UITableView *myTableView;
@property(nonatomic,retain)IBOutlet UIButton *shareBtn;
@property(nonatomic,retain)IBOutlet UIButton* oneUnlockBtn;


@property (nonatomic, assign) long startTime;
@property (nonatomic, assign) long endTime;

@property (nonatomic , retain)IBOutlet UIImageView *dianImage;
@property (nonatomic , retain)IBOutlet UIImageView *savePoint;
@property (nonatomic , retain)IBOutlet UIView *jiesuoView;
@property (nonatomic , retain)IBOutlet UIView *jiasuoView;
@property (nonatomic , retain)NSMutableArray *datasArray;
@property (nonatomic ,retain)NSMutableArray *allLockArr;
@property (nonatomic ,retain) IBOutlet UIButton *kesuoBtn;

-(IBAction)oneUnlockBtnPress:(id)sender;
-(IBAction)turnBrnPress:(id)sender;
-(IBAction)refleshPress:(id)sender;
-(IBAction)shareBtnPress:(id)sender;
-(IBAction)jiesuoBtn:(id)sender;
-(IBAction)jiasuoBtn:(id)sender;
-(IBAction)suoOrjieBtn:(id)sender;
@end
