//
//  UIImage+ACImage.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 27/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "UIImage+ACImage.h"

@implementation UIImage (ACImage)

+ (UIImage *)image:(UIImage *)originalImage scaledToSize:(CGSize)size {
    if(CGSizeEqualToSize(originalImage.size, size)) {
        return originalImage;
    }
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    [originalImage drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
