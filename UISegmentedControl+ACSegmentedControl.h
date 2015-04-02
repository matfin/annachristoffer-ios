//
//  UISegmentedControl+ACSegmentedControl.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 30/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+Encoded.h"

@interface UISegmentedControl (ACSegmentedControl)
+ (id)initWithItems:(NSArray *)items andColor:(UIColor *)color withSelectedIndex:(NSInteger)selectedIndex;
@end
