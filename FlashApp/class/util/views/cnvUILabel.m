//
//  cnvUILabel.m
//  Label
//
//  Created by xiong xiongwenjie on 11-8-2.
//  Copyright 2011 CareLand. All rights reserved.
//

#import "cnvUILabel.h"
#import <CoreText/CoreText.h>

@implementation cnvUILabel

@synthesize stringColor;
@synthesize keywordColor;
@synthesize list;

-(id) init
{
    if (self = [super init]) {
        self.text = nil;
        stringColor = nil;
        keywordColor = nil;
        list = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.text = nil;
        stringColor = nil;
        keywordColor = nil;
        list = [[NSMutableArray alloc] init];
        // Initialization code.
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [list release];
    [super dealloc];
}

//设置字体颜色和关键字的颜色
- (void) cnv_setUIlabelTextColor:(UIColor *) strColor 
                 andKeyWordColor: (UIColor *) keyColor
{
    self.stringColor = strColor;
    self.keywordColor = keyColor;
}
//设置关键字，并且调用保存关键字函数将关键字的Range存再list中。
- (void) cnv_setUILabelText:(NSString *)string andKeyWord:(NSString *)keyword
{
    if (self.text != string) {
        self.text = string;
    }
    [self saveKeywordRangeOfText:keyword];
}

//保存关键字再Text中的位置信息
- (void) saveKeywordRangeOfText:(NSString *)keyWord
{
    //有效性校验
    if (nil == keyWord) {
        return;
    }
    //将所有的字符位置存在list中
    int nLen = [keyWord length];
   // for (int i = 0  ; i < nLen; i++) 
   // {
        //按照所给的位置，长度，从keyword中截取子串
        NSString *strTemp = [keyWord substringWithRange:NSMakeRange(0, nLen)];
        //获取单个关键字符在text中的位置
        NSString *strText = self.text;
        NSRange range = [strText rangeOfString:strTemp];
        //由于结构体不能直接存到NSArray中，所以要转换一下。
        NSValue *value = [NSValue valueWithRange:range];

        if (range.length > 0) 
        {

             [list addObject:value];
        }
       
    //}
    
}


//设置颜色属性和字体属性
- (NSAttributedString *)illuminatedString:(NSString *)text 
                                     font:(UIFont *)AtFont{
	
    int len = [text length];
    //创建一个可变的属性字符串
    NSMutableAttributedString *mutaString = [[[NSMutableAttributedString alloc] initWithString:text] autorelease];
    //改变字符串 从1位 长度为1 这一段的前景色，即字的颜色。
/*    [mutaString addAttribute:(NSString *)(kCTForegroundColorAttributeName) 
                       value:(id)[UIColor darkGrayColor].CGColor 
                       range:NSMakeRange(1, 1)]; */
    [mutaString addAttribute:(NSString *)(kCTForegroundColorAttributeName)
                       value:(id)self.stringColor.CGColor
                       range:NSMakeRange(0, len)];
    
  
    
    if (self.keywordColor != nil)
    {
        for (NSValue *value in list) 
        {
         //   NSValue *value = [list objectAtIndex:i];
            NSRange keyRange = [value rangeValue];
            [mutaString addAttribute:(NSString *)(kCTForegroundColorAttributeName)
                                                    value:(id)self.keywordColor.CGColor
                                                    range:keyRange];
        }
    }

    
    //设置部分字段的字体大小与其他的不同
/*    CTFontRef ctFont = CTFontCreateWithName((CFStringRef)AtFont.fontName, 
                                            AtFont.pointSize, 
                                            NULL);
    [mutaString addAttribute:(NSString *)(kCTFontAttributeName) 
                       value:(id)ctFont 
                       range:NSMakeRange(0, 1)];*/
    
    //设置是否使用连字属性，这里设置为0，表示不使用连字属性。标准的英文连字有FI,FL.默认值为1，既是使用标准连字。也就是当搜索到f时候，会把fl当成一个文字。
    int nNumType = 0;
//    float fNum = 3.0;
    CFNumberRef cfNum = CFNumberCreate(NULL, kCFNumberIntType, &nNumType);
//    CFNumberRef cfNum2 = CFNumberCreate(NULL, kCFNumberFloatType, &fNum);
    [mutaString addAttribute:(NSString *)kCTLigatureAttributeName
                       value:(id)cfNum
                       range:NSMakeRange(0, len)];
    //空心字
//    [mutaString addAttribute:(NSString *)kCTStrokeWidthAttributeName value:(id)cfNum2 range:NSMakeRange(0, len)];
    
    
    CTFontRef ctFont2 = CTFontCreateWithName((CFStringRef)AtFont.fontName, 
                                             AtFont.pointSize,
                                             NULL);
    [mutaString addAttribute:(NSString *)(kCTFontAttributeName) 
                       value:(id)ctFont2 
                       range:NSMakeRange(0, len)];
 //   CFRelease(ctFont);
    CFRelease(ctFont2);
    CFRelease(cfNum);
    return [[mutaString copy] autorelease];
}

//重绘Text
- (void)drawRect:(CGRect)rect 
{
    //获取当前label的上下文以便于之后的绘画，这个是一个离屏。
	CGContextRef context = UIGraphicsGetCurrentContext();
    //压栈，压入图形状态栈中.每个图形上下文维护一个图形状态栈，并不是所有的当前绘画环境的图形状态的元素都被保存。图形状态中不考虑当前路径，所以不保存
    //保存现在得上下文图形状态。不管后续对context上绘制什么都不会影响真正得屏幕。
	CGContextSaveGState(context);
    //x，y轴方向移动
	CGContextTranslateCTM(context, 0.0, 0.0);/*self.bounds.size.height*/
    
    //缩放x，y轴方向缩放，－1.0为反向1.0倍,坐标系转换,沿x轴翻转180度
	CGContextScaleCTM(context, 1, -1);	
	
	NSArray *fontArray = [UIFont familyNames];
	NSString *fontName;
	if ([fontArray count]) {
		fontName = [fontArray objectAtIndex:0];
	}
    //创建一个文本行对象，此对象包含一个字符
	CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef) 
                                                      [self illuminatedString:self.text font:self.font]);	//[UIFont fontWithName:fontName size:60]
    //设置文字绘画的起点坐标。由于前面沿x轴翻转了（上面那条边）所以要移动到与此位置相同，也可以只改变CGContextSetTextPosition函数y的坐标，效果是一样的只是意义不一样
          CGContextTranslateCTM(context, 0.0, - ceill(self.bounds.size.height) + 8);//加8是稍微调整一下位置，让字体完全现实，有时候y，j下面一点点会被遮盖
	CGContextSetTextPosition(context, 0.0, 0.0); /*ceill(self.bounds.size.height) + 8*/
    //在离屏上绘制line
	CTLineDraw(line, context);
    //将离屏上得内容覆盖到屏幕。此处得做法很像windows绘制中的双缓冲。
	CGContextRestoreGState(context);	
	CFRelease(line);
	//CGContextRef	myContext = UIGraphicsGetCurrentContext();
	//CGContextSaveGState(myContext);
	//[self MyColoredPatternPainting:myContext rect:self.bounds];
	//CGContextRestoreGState(myContext);
}
@end
