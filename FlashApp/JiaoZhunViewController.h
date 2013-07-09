//
//  JiaoZhunViewController.h
//  FlashApp
//
//  Created by 朱广涛 on 13-6-20.
//  Copyright (c) 2013年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TwitterClient;

@interface JiaoZhunViewController : UIViewController<UITableViewDataSource , UITableViewDelegate>
{
    NSArray *oneSessiontopImageArray ;
    NSArray *twoSessiontopImageArray ;
    NSArray *oneSessionnameLabelArray;
    NSArray *twoSessionnameLabelArray;
    
    NSArray *oneSessiontitleArray; //alert框title
    //用于判断用户是否开启位置服务
    BOOL locationFlag;
    
    
    
    NSString *yueJieRiStr;
    NSString *taoCanZongStr;
    NSString *yiYongLiangStr;
    
    

}
@property (nonatomic, retain) TwitterClient* client;

@property (nonatomic ,retain) UILabel *oneNameLabel;


@property (nonatomic ,retain) UILabel *twoNameLabel;

@property (nonatomic ,retain) UIButton *turnOnBtn;

@property(nonatomic,retain) UILabel *taocanCountLabel;

@property(nonatomic,retain) UILabel *benyueCountLabel;

@property(nonatomic,retain) UILabel *yuejieCountLabel;

@property(nonatomic,retain)UIViewController*controller;

@end
