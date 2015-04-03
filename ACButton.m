//
//  ACButton.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 02/04/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "ACButton.h"
#import "LanguageController.h"
#import "Locale.h"
#import "UIColor+ACColor.h"

@interface ACButton ()
@property (nonatomic, strong) NSString *languageCode;
@property (nonatomic, strong) NSString *messageKey;
@end

@implementation ACButton


- (id)initWithTitleKey:(NSString *)messageKey {
    if(self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageDidChange:) name:@"languageDidChange" object:nil];
        self.languageCode = [[LanguageController sharedInstance] getCurrentLocale].languageCode;
        self.messageKey = messageKey;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self setButtonTitle];
    }
    return self;
}

- (void)languageDidChange:(NSNotification *)notification {
    Locale *locale = (Locale *)[notification object];
    self.languageCode = locale.languageCode;
    [self setButtonTitle];
}

- (void)setButtonTitle {
    [self setTitle:[[LanguageController sharedInstance] getTranslationForKey:self.messageKey] forState:UIControlStateNormal];
}

- (void)addBorder {
    CALayer *bottom = [CALayer layer];
    bottom.frame = CGRectMake(0.0f, self.frame.size.height - 0.5f, self.frame.size.width, 0.5f);
    bottom.backgroundColor = [UIColor getColor:colorFuscia withAlpha:0.6f].CGColor;
    [self.layer addSublayer:bottom];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addBorder];
}

@end
