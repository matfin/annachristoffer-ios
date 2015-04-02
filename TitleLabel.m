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
@property (nonatomic, strong) Locale *locale;
@end

@implementation TitleLabel

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
}

- (void)updateTextFromMessageCodes {
    NSString *title = [NSString messageFromSet:self.messageCodes withKey:self.key withLanguageCode:self.locale.languageCode];
    [self setText:[title asDecodedFromEntities]];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
