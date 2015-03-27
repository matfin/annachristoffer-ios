//
//  SlideIndicatorItemView.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 27/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "SlideIndicatorItemView.h"
#import "UIColor+ACColor.h"

@interface SlideIndicatorItemView ()
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, strong) UIColor *indicatorColor;
@end

@implementation SlideIndicatorItemView

- (id)initWithIndex:(NSUInteger)index {
    if(self = [super init]) {
        
        self.index = index;
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        if(index % 2 == 0) {
            [self setIndicatorColor:[UIColor getColor:colorPink withAlpha:0.35f]];
        }
        else {
            [self setIndicatorColor:[UIColor getColor:colorPink withAlpha:0.425f]];
        }
        [self setBackgroundColor:self.indicatorColor];
    }
    return self;
}

- (void)setToActiveState {
    [self setBackgroundColor:[UIColor getColor:colorPink withAlpha:0.6f]];
}

- (void)resetToNormalState {
    [self setBackgroundColor:self.indicatorColor];
}

@end
