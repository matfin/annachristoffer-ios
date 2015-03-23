//
//  UILabel+ACLabel.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 23/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "UILabel+ACLabel.h"

@implementation UILabel (ACLabel)

+ (UILabel *)initWithFontIcon:(FontIcon)icon withColor:(UIColor *)color andSize:(CGFloat)size {
    UILabel *label = [UILabel autoLayoutView];
    [label setFont:[UIFont fontWithName:@"anna" size:size]];
    [label setText:[NSString initWithFontIcon:icon]];
    [label setTextColor:color];
    [label setTextAlignment:NSTextAlignmentCenter];
    return label;
}

+ (UILabel *)initWithFont:(UIFont *)font withColor:(UIColor *)color andSize:(CGFloat)size {
    UILabel *label = [UILabel autoLayoutView];
    [label setFont:[UIFont fontWithName:@"anna" size:size]];
    [label setTextColor:color];
    [label setTextAlignment:NSTextAlignmentLeft];
    return label;
}

@end
