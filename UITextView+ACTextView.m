//
//  UITextView+ACTextView.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 26/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "UITextView+ACTextView.h"
#import "UIView+Autolayout.h"

@implementation UITextView (ACTextView)

+ (UITextView *)initAsCaptionTextView {
    UITextView *textView = [UITextView autoLayoutView];
    [textView setEditable:NO];
    [textView setScrollEnabled:NO];
    [textView setFont:[UIFont fontWithName:@"OpenSans-Light" size:14.0f]];
    return textView;
}

@end
