//
//  TitleLabel.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 18/12/2014.
//  Copyright (c) 2014 Anna Christoffer. All rights reserved.
//

#import "TitleLabel.h"
#import "NSString+Encoded.h"
#import "Locale.h"
#import "NSString+MessageCode.h"
#import "LanguageController.h"

@interface TitleLabel ()
@property (nonatomic, strong) NSString *languageCode;
@end

@implementation TitleLabel

@synthesize messageCodes;

- (id)init {
    if(self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageDidChange:) name:@"languageDidChange" object:nil];
        self.languageCode = [[LanguageController sharedInstance] getCurrentLocale].languageCode;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    UIEdgeInsets insets = {0, 10, 0, 10};
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect,insets)];
}

- (void)languageDidChange:(NSNotification *)languageNotification {
    Locale *locale = (Locale *)[languageNotification object];
    self.languageCode = locale.languageCode;
    [self updateTextFromMessageCodes];
}

- (void)updateTextFromMessageCodes {
    NSString *title = [NSString messageFromSet:self.messageCodes withKey:@"title" withLanguageCode:self.languageCode];
    [self setText:title];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
