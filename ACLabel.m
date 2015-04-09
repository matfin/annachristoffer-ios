//
//  ACLabel.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 18/12/2014.
//  Copyright (c) 2014 Anna Christoffer. All rights reserved.
//

#import "ACLabel.h"
#import "NSString+Encoded.h"
#import "Locale.h"
#import "NSString+MessageCode.h"
#import "Date.h"

@interface ACLabel ()
@property (nonatomic, strong) Locale *locale;
@end

@implementation ACLabel

@synthesize messageCodes;
@synthesize key;

- (id)init {
    if(self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageDidChange:) name:@"languageDidChange" object:nil];
        self.locale = [[LanguageController sharedInstance] getCurrentLocale];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    UIEdgeInsets insets = {0, 10, 0, 10};
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect,insets)];
}

- (void)languageDidChange:(NSNotification *)languageNotification {
    Locale *locale = (Locale *)[languageNotification object];
    self.locale = locale;
    [self updateTextFromMessageCodes];
    [self updateDateLabel];
}

- (void)updateTextFromMessageCodes {
    NSString *title = [NSString messageFromSet:self.messageCodes withKey:self.key withLanguageCode:self.locale.languageCode];
    [self setText:[title asDecodedFromEntities]];
}

- (void)updateDateLabel {
    if(self.contentItem == nil) return;
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MMMM YYYY"];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:self.locale.languageCode]];
    NSString *dateString = @"";
    NSString *dateFromString = @"";
    NSString *dateToString = @"";
    
    if(self.contentItem.date.from != nil) {
        dateFromString = [dateFormatter stringFromDate:self.contentItem.date.from];
        dateString = [NSString stringWithFormat:@"%@", dateFromString];
    }
    if(self.contentItem.date.to != nil) {
        dateToString = [dateFormatter stringFromDate:self.contentItem.date.to];
        dateString = [NSString stringWithFormat:@"%@ - %@", dateFromString, dateToString];
    }
    [self setText:dateString];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
