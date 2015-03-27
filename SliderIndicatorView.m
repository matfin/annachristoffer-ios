//
//  SliderIndicatorView.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 26/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "SliderIndicatorView.h"
#import "UIView+Autolayout.h"
#import "UIColor+ACColor.h"
#import "SlideIndicatorItemView.h"

@interface SliderIndicatorView ()
@property (nonatomic, strong) NSMutableArray *indicatorViews;
@end

@implementation SliderIndicatorView

- (id)initWithNumberOfSlides:(NSUInteger)numberOfSlides {
    if(self = [super init]) {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self setBackgroundColor:[UIColor whiteColor]];
        self.indicatorViews = [NSMutableArray new];
        for(NSUInteger i = 0; i < numberOfSlides; i++) {
            SlideIndicatorItemView *indicatorItemView = [[SlideIndicatorItemView alloc] initWithIndex:i];
            [self.indicatorViews addObject:indicatorItemView];
            [self addSubview:indicatorItemView];
        }
        [self setCurrentSlideNumber:0];
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints {
    UIView *prevView = nil;
    for(UIView *view in self.subviews) {
        /**
         *  Vertical constraints, pinned to the bottom with a given height
         */
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": view}]];
        
        if(prevView == nil) {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]" options:0 metrics:nil views:@{@"view": view}]];
        }
        else {
            /**
             *  Give the view the same width as the previous view, to make their widths evenly distributed
             */
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[prevView][view(==prevView)]" options:0 metrics:nil views:@{@"prevView": prevView, @"view": view}]];
        }
        prevView = view;
    }
    
    /**
     *  Finally, pin to the right
     */
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[prevView]|" options:0 metrics:nil views:@{@"prevView": prevView}]];
}

- (void)setCurrentSlideNumber:(NSUInteger)currentSlideNumber {
    
    for(SlideIndicatorItemView *slideIndicatorItemView in self.indicatorViews) {
        [slideIndicatorItemView resetToNormalState];
    }
    
    [(SlideIndicatorItemView *)[self.indicatorViews objectAtIndex:currentSlideNumber] setToActiveState];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}


@end
