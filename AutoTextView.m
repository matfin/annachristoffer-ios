//
//  AutoTextView.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 06/01/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "AutoTextView.h"

@implementation AutoTextView

- (void)layoutSubViews {
    
    [super layoutSubviews];
    
//    if(!CGSizeEqualToSize(self.bounds.size, [self intrinsicContentSize])) {
//        [self invalidateIntrinsicContentSize];
//    }
    
}

- (CGSize)intrinsicContentSize {
    
    [super intrinsicContentSize];
    
    CGSize intrinsicContentSize = self.contentSize;
    intrinsicContentSize.width += ((self.textContainerInset.left + self.textContainerInset.right) / 2.0f);
    intrinsicContentSize.height += ((self.textContainerInset.top + self.textContainerInset.bottom) / 2.0f);
    return intrinsicContentSize;
}

@end
