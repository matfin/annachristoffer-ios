//
//  SlideIndicatorItemView.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 27/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+ACColor.h"

@interface SlideIndicatorItemView : UIView
- (id)initWithIndex:(NSUInteger)index;
- (void)setToActiveState;
- (void)resetToNormalState;
@end
