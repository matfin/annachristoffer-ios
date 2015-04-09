//
//  UIButton+ACButton.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 23/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "UIButton+ACButton.h"

@implementation UIButton (ACButton)

+ (UIButton *)initWithFontIcon:(FontIcon)fontIcon withColor:(UIColor *)color andSize:(CGFloat)size andAlignment:(NSTextAlignment)alignment{
    UIButton *fontButton = [UIButton autoLayoutView];
    UILabel *buttonLabel = [UILabel autoLayoutView];
    [buttonLabel setFont:[UIFont fontWithName:@"anna" size:size]];
    [buttonLabel setText:[NSString initWithFontIcon:fontIcon]];
    [buttonLabel setTextColor:color];
    [buttonLabel setTextAlignment:alignment];
    [fontButton addSubview:buttonLabel];
    
    [fontButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[buttonLabel]|" options:0 metrics:nil views:@{@"buttonLabel":buttonLabel}]];
    [fontButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[buttonLabel]|" options:0 metrics:nil views:@{@"buttonLabel":buttonLabel}]];
    
    return fontButton;
}

@end
