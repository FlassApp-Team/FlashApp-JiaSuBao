//
//  cnvUILabel.h
//  Label
//
//  Created by xiong xiongwenjie on 11-8-2.
//  Copyright 2011 CareLand. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <CoreGraphics/CoreGraphics.h>

@interface cnvUILabel : UILabel {
    UIColor *  stringColor;                //字符串的颜色，
    UIColor * keywordColor;          //关键字的颜色，
    NSMutableArray *list;              // 用于存储关键字的NSRange。
 //   NSString *text;
}
@property (retain,nonatomic)  UIColor *stringColor;//CGColorRef
@property (retain,nonatomic)  UIColor *keywordColor;
@property (retain, nonatomic) NSMutableArray *list;

//-(id) initWithStringColor:(UIColor *)strColor keyColor:(UIColor *)keyColor;

//设置字符串颜色和关键字颜色
- (void) cnv_setUIlabelTextColor:(UIColor *) strColor andKeyWordColor: (UIColor *) keyColor;

//设置显示的字符串和关键字。即将显示时调用此函数。
- (void) cnv_setUILabelText:(NSString *)string andKeyWord:(NSString *)keyword;

//将关键字的位置和长度，存放在list中。
- (void) saveKeywordRangeOfText:(NSString *)keyWord;
@end
