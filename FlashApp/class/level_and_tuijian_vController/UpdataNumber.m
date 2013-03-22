//
//  UpdataNumber.m
//  FlashApp
//
//  Created by 七 叶 on 13-2-1.
//  Copyright (c) 2013年 lidiansen. All rights reserved.
//

#import "UpdataNumber.h"

@implementation UpdataNumber
@synthesize numLabel;
@synthesize imageView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

    }
    return self;
}

-(void)dealloc{
    self.imageView=nil;
    self.numLabel=nil;
    [super dealloc];

}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIImage*image=[UIImage imageNamed:@"tuijian_count.png"];
    image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    self.imageView.image=image;
}



+(UpdataNumber *)creatUpdataNumberView{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"UpdataNumber" owner:nil options:nil];
    NSLog(@"nibView===%@",nibView);
    return [nibView objectAtIndex:0];
}

@end
