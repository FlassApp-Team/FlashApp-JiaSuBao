//
//  UIImageUtil.m
//  flashapp
//
//  Created by Zhao Qi on 12-10-26.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import "UIImageUtil.h"

@implementation UIImage (UIImageUtil)


- (UIImage *)scaleImage:(float)scaleSize
{
    float width = self.size.width * scaleSize;
    float height = self.size.height * scaleSize;
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [self drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
                                
    return scaledImage;
}


- (UIImage *)resizeImage:(CGSize)resize
{
    UIGraphicsBeginImageContext(CGSizeMake(resize.width, resize.height));
    [self drawInRect:CGRectMake(0, 0, resize.width, resize.height)];
    UIImage *resizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return resizeImage;
}


-(UIImage*)getSubImage:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    
    return smallImage;
}



@end
