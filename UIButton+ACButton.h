//
//  UIButton+ACButton.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 23/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Autolayout.h"
#import "NSString+FontIcon.h"
#import "UIColor+ACColor.h"

@interface UIButton (ACButton)
+ (UIButton *)initWithFontIcon:(FontIcon)fontIcon withColor:(UIColor *)color andSize:(CGFloat)size andAlignment:(NSTextAlignment)alignment;
@end
