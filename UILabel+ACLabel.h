//
//  UILabel+ACLabel.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 23/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Autolayout.h"
#import "UIColor+ACColor.h"
#import "NSString+FontIcon.h"
#import "TitleLabel.h"

@interface UILabel (ACLabel)
+ (UILabel *)initWithFontIcon:(FontIcon)icon withColor:(UIColor *)color andSize:(CGFloat)size;
+ (UILabel *)initWithFont:(UIFont *)font withColor:(UIColor *)color;
@end
