//
//  UIView+Autolayout.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 19/12/2014.
//  Copyright (c) 2014 Anna Christoffer. All rights reserved.
//

#import "UIView+Autolayout.h"

@implementation UIView (Autolayout)
+(id)autoLayoutView {
    UIView *view = [self new];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    return view;
}
@end
