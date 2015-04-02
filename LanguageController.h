//
//  LanguageController.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 30/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Encoded.h"
#import "Locale.h"

@interface LanguageController : NSObject
@property (nonatomic, strong) NSArray *availableLocales;
+ (LanguageController *)sharedInstance;
- (void)updateLanguageWithLocale:(Locale *)locale;
- (Locale *)getCurrentLocale;
- (NSString *)getTranslationForKey:(NSString *)key;
@end
