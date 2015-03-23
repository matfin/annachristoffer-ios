//
//  TitleLabel.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 18/12/2014.
//  Copyright (c) 2014 Anna Christoffer. All rights reserved.
//

#import "TitleLabel.h"

@implementation TitleLabel

- (void)drawRect:(CGRect)rect {
    UIEdgeInsets insets = {0, 10, 0, 10};
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect,insets)];
}


@end
