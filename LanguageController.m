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

@synthesize availableLocales;

+ (LanguageController *)sharedInstance {
    if(sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

- (id)init {
    if(self = [super init]) {
        
        /**
         *  The locales this app currently supports
         */
        Locale *english = [[Locale alloc] initWithLanguageCode:@"en" andCountryCode:@"gb" andName:@"English" andIndex:0];
        Locale *german = [[Locale alloc] initWithLanguageCode:@"de" andCountryCode:@"de" andName:@"Deutsch" andIndex:1];
        self.availableLocales = @[english, german];
        
        /**
         *  Checking the set language and setting a default if none has been chosen before
         */
        if([[NSUserDefaults standardUserDefaults] valueForKey:@"language"] == nil) {
            
            NSLocale *currentLocale = [NSLocale currentLocale];
            for(Locale *locale in self.availableLocales) {
                if([locale.languageCode caseInsensitiveCompare:[currentLocale objectForKey:NSLocaleLanguageCode]] == NSOrderedSame) {
                    [self setLanguageWithLocale:locale];
                }
            }
            
            /**
             *  If we still don't have a matching language for the devices locale, set English as the default
             */
            if([[NSUserDefaults standardUserDefaults] valueForKey:@"language"] == nil) {
                [self setLanguageWithLocale:[self.availableLocales objectAtIndex:0]];
            }
        }
    }
    return self;
}

- (void)setLanguageWithLocale:(Locale *)locale {
    [[NSUserDefaults standardUserDefaults] setObject:locale.languageCode forKey:@"language"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)updateLanguageWithLocale:(Locale *)locale {
    [self setLanguageWithLocale:locale];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"languageDidChange" object:locale];
}

- (Locale *)getCurrentLocale {
    Locale *selectedLocale = nil;
    NSString *languageCode = [[[NSUserDefaults standardUserDefaults] stringForKey:@"language"] lowercaseString];
    
    for(Locale *locale in self.availableLocales) {
        if([locale.languageCode caseInsensitiveCompare:languageCode] == NSOrderedSame) {
            selectedLocale = locale;
            break;
        }
    }
    
    return selectedLocale;
}

- (NSString *)getTranslationForKey:(NSString *)key {
    NSString *languageCode = [[[NSUserDefaults standardUserDefaults] stringForKey:@"language"] lowercaseString];
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:languageCode ofType:@"lproj"];
    NSBundle *languageBundle = [NSBundle bundleWithPath:bundlePath];
    NSString *translatedString = [languageBundle localizedStringForKey:key value:@"" table:nil];
    
    if(translatedString.length < 1) {
        translatedString = @"Not found";
    }
    
    return translatedString;
}

@end
