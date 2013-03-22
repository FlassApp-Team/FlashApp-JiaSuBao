//
//  IDCPickerViewController.h
//  flashapp
//
//  Created by 李 电森 on 12-6-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TwitterClient.h"
#import "ASINetworkQueue.h"
#import "IDCInfo.h"

@interface IDCPickerViewController : UITableViewController <UIAlertViewDelegate>
{
    NSArray* idcArray;
    NSMutableDictionary* idcOrderArray; //用来放置每个机房测速后的集合。主要用于根据速度进行排序
    NSMutableDictionary* speedDic;
    NSInteger selectedRow;
    
    TwitterClient* client;
    NSOperationQueue* queue;
    
    UIProgressView* progressIndicator;
    NSMutableArray *items; //用来逐个展现列表。
    
    NSMutableArray * children ; //用来存放单选框按钮button
    NSInteger idcCount; //计算当前加载的机房个数
    
    UIButton* button;
}
@property(nonatomic,retain)UIViewController *controller;//add jianfei han
- (void) ping;
- (void) loadData;
-(void)saveButtonClick:(id)sender;

- (void) refreshTable;

@end
