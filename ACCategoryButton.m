//
//  ACCategoryButton.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 03/04/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "ACCategoryButton.h"
#import "NSString+Encoded.h"
#import "NSString+MessageCode.h"
#import "Locale.h"
#import "UIColor+ACColor.h"


@interface ACCategoryButton ()
@property (nonatomic, strong) Locale *locale;
@end

@implementation ACCategoryButton

- (id)init {
    if(self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageDidChange:) name:@"languageDidChange" object:nil];
        self.locale = [[LanguageController sharedInstance] getCurrentLocale];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self setTitleColor:[UIColor getColor:colorFuscia] forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont fontWithName:@"OpenSans-SemiBold" size:16.0f]];
    }
    return self;
}

- (void)languageDidChange:(NSNotification *)notification {
    Locale *locale = (Locale *)[notification object];
    self.locale = locale;
    [self updateTextFromMessageCodes];
}

- (void)updateTextFromMessageCodes {
    NSString *title = [NSString messageFromSet:self.category.messageCodes withKey:self.key withLanguageCode:self.locale.languageCode];
    [self setTitle:title forState:UIControlStateNormal];
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
