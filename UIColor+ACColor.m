//
//  UIColor+ACColor.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 23/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "UIColor+ACColor.h"

@implementation UIColor (ACColor)

+ (UIColor *)getColor:(Color)color {
    return [UIColor colors][color];
}

+ (UIColor *)getColor:(Color)color withAlpha:(CGFloat)alpha {
    return [[UIColor getColor:color] colorWithAlphaComponent:alpha];
}

+ (NSArray *)colors {
    static NSArray *colors;
    static dispatch_once_t colorsToken;
    
    dispatch_once(&colorsToken, ^{
        colors = @[
            [UIColor colorWithRed:221.0f / 255.0f green:121.0f / 255.0f blue:227.0f / 255.0f alpha:1.0f],    //colorFuscia
            [UIColor colorWithRed:255.0f / 255.0f green:51.0f / 255.0f blue:153.0f / 255.0f alpha:1.0f],    //colorPink
            [UIColor colorWithRed:254.0f / 255.0f green:236.0f / 255.0f blue:251.0f / 255.0f alpha:1.0f]    //colorLightPink
        ];
    });
    
    return colors;
}

@end