//
//  UpdataNumber.h
//  FlashApp
//
//  Created by 七 叶 on 13-2-1.
//  Copyright (c) 2013年 lidiansen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdataNumber : UIView

@property(nonatomic,retain)IBOutlet UILabel *numLabel;
@property(nonatomic,retain)IBOutlet UIImageView *imageView;


+(UpdataNumber *)creatUpdataNumberView;

@end
