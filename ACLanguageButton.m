//
//  ACLanguageButton.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 03/04/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "ACLanguageButton.h"

@implementation ACLanguageButton

@synthesize buttonLocale;

- (id)initWithLocale:(Locale *)locale {
    if(self = [super init]) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.buttonLocale = locale;
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self setTitle:locale.name forState:UIControlStateNormal];
        [self setTitleColor:[UIColor getColor:colorFuscia] forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont fontWithName:@"OpenSans-SemiBold" size:16.0f]];
    }
    return self;
}

- (void)setActive:(BOOL)active {
    [UIView animateWithDuration:0.125 animations:^{
        if(active) {
            [self setBackgroundColor:[UIColor getColor:colorLightPink]];
        }
        else {
            [self setBackgroundColor:[UIColor getColor:colorWhite withAlpha:0.4f]];
        }
    }];
}

- (void)addBorder {
    CALayer *top = [CALayer layer];
    top.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, 0.5f);
    top.backgroundColor = [UIColor getColor:colorFuscia withAlpha:0.6f].CGColor;
    [self.layer addSublayer:top];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addBorder];
}

@end

