//
//  UIImage+Util.m
//  Crude
//
//  Created by Tomoya Itagawa on 2014/11/23.
//  Copyright (c) 2014年 tomoya itagawa. All rights reserved.
//

#import "UIImage+Util.h"

@implementation UIImage (Util)

- (UIImage *)clipImageWithRect:(CGRect)rect imageViewSize:(CGSize)size
{
    CGFloat scaleW = self.size.width / size.width;
    CGFloat scaleH = self.size.height / size.height;
    rect.origin.x *= scaleW;
    rect.origin.y *= scaleH;
    rect.size.width *= scaleW;
    rect.size.height *= scaleH;
    
    CGImageRef imageRef = [self CGImage];
    CGImageRef clippedImageRef = CGImageCreateWithImageInRect(imageRef, rect);
    return [UIImage imageWithCGImage:clippedImageRef];
}

- (UIImage *)renderImage
{
    UIGraphicsBeginImageContext(self.size);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
