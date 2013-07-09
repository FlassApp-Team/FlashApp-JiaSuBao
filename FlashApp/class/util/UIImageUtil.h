//
//  UIImageUtil.h
//  flashapp
//
//  Created by Zhao Qi on 12-10-26.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (UIImageUtil)

- (UIImage *)scaleImage:(float)scaleSize;
- (UIImage *)resizeImage:(CGSize)resize;
-(UIImage*)getSubImage:(CGRect)rect;

@end
