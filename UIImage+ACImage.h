//
//  UIImage+ACImage.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 27/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIImage (ACImage)
+ (UIImage *)image:(UIImage *)originalImage scaledToSize:(CGSize)size;
@end
