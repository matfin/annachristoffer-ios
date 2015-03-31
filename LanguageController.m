//
//  LanguageController.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 30/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "LanguageController.h"

static LanguageController *sharedInstance = nil;

@implementation LanguageController

- (id)init {
    if(self = [super init]) {
        /**
         *  Checking the set language and setting a default
         */
        if([[NSUserDefaults standardUserDefaults] valueForKey:@"language"] == nil) {
            [[NSUserDefaults standardUserDefaults] setValue:en forKey:@"language"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    return self;
}

+ (LanguageController *)sharedInstance {
    if(sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

- (void)updateLanguageWithCode:(ACLanguageCode)languageCode {
    [[NSUserDefaults standardUserDefaults] setValue:@(languageCode) forKey:@"language"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.delegate languageDidChangeWithCode:languageCode];
}

- (ACLanguageCode)currentLanguageCode {
    return [[[NSUserDefaults standardUserDefaults] valueForKey:@"language"] integerValue];
}

@end
