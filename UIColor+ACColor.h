//
//  UIColor+ACColor.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 23/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, Color) {
    colorFuscia,
    colorPink,
    colorLightPink
};

@interface UIColor (ACColor)
+ (UIColor *)getColor:(Color)color;
+ (UIColor *)getColor:(Color)color withAlpha:(CGFloat)alpha;
@end
