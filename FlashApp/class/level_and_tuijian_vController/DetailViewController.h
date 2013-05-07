//
//  DetailViewController.h
//  flashapp
//
//  Created by 朱广涛 on 13-4-25.
//  Copyright (c) 2013年 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController<UITableViewDataSource , UITableViewDelegate>
{
    BOOL hasrkm;
    BOOL haspics;
    
    float fontHeight;
}

@property (retain, nonatomic) IBOutlet UITableView *detailTableView;
@property (retain, nonatomic) IBOutlet UIView *headView;
@property (retain, nonatomic) IBOutlet UIImageView *appIconImgView;
@property (retain, nonatomic) IBOutlet UILabel *appNameLabel;
@property (retain, nonatomic) IBOutlet UIButton *gotuAnzhuang;

@property (retain, nonatomic) IBOutlet UIView *liyouView;
@property (retain, nonatomic) IBOutlet UIImageView *liyouImgView;
@property (retain, nonatomic) IBOutlet UILabel *liyouLabel;

@property (retain, nonatomic) IBOutlet UIView *endPicBtnView;
@property (retain, nonatomic) IBOutlet UILabel *picSizeLabel;

@property (retain, nonatomic) IBOutlet UIView *miaoshuTitleView;


@property (retain, nonatomic) IBOutlet UIView *showPicView;
@property (retain, nonatomic) IBOutlet UIScrollView *showPicScrollView;

@property (retain, nonatomic) IBOutlet UIButton *showPicBtn;

@property (nonatomic ,retain) NSMutableDictionary *appImgDic;

@end
