//
//  UIButton+ACButton.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 23/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "UIButton+ACButton.h"

@implementation UIButton (ACButton)
+ (UIButton *)initWithFontIcon:(FontIcon)fontIcon withColor:(UIColor *)color andSize:(CGFloat)size {
    UIButton *fontButton = [UIButton autoLayoutView];
    UILabel *buttonLabel = [UILabel initWithFontIcon:fontIcon withColor:color andSize:size];
    [fontButton addSubview:buttonLabel];
    
    [fontButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[buttonLabel]|" options:0 metrics:nil views:@{@"buttonLabel":buttonLabel}]];
    [fontButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[buttonLabel]|" options:0 metrics:nil views:@{@"buttonLabel":buttonLabel}]];
    
    return fontButton;
}
@end