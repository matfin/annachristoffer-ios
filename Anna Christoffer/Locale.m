//
//  Locale.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 02/04/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "Locale.h"

@implementation Locale

- (id)initWithLanguageCode:(NSString *)languageCode andCountryCode:(NSString *)countryCode andName:(NSString *)name andIndex:(NSInteger)index{
    if(self = [super init]) {
        self.index = index;
        self.languageCode = languageCode;
        self.countryCode = countryCode;
        self.name = name;
    }
    return self;
}

@end
