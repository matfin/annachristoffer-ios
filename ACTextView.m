//
//  ACTextView.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 02/04/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "ACTextView.h"
#import "Locale.h"
#import "NSString+MessageCode.h"
#import "LanguageController.h"

@interface ACTextView ()
@property (nonatomic, strong) Locale *locale;
@end

@implementation ACTextView

@synthesize locale;
@synthesize key;

- (id)init {
    if(self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageDidChange:) name:@"languageDidChange" object:nil];
        self.locale = [[LanguageController sharedInstance] getCurrentLocale];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.editable = NO;
        self.scrollEnabled = NO;
        self.font = [UIFont fontWithName:@"OpenSans-Light" size:14.0f];
        self.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5);
    }
    return self;
}

- (void)languageDidChange:(NSNotification *)notification {
    Locale *newLocale = (Locale *)[notification object];
    self.locale = newLocale;
    [self updateTextFromMessageCodes];
}

- (void)updateTextFromMessageCodes {
    NSString *content = [NSString messageFromSet:self.messageCodes withKey:self.key withLanguageCode:self.locale.languageCode];
    [self setText:[NSString decodeFromHTMLEntites:content]];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
