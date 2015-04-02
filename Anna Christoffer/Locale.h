//
//  Locale.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 02/04/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Locale : NSObject

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *countryCode;
@property (nonatomic, strong) NSString *languageCode;

- (id)initWithLanguageCode:(NSString *)languageCode andCountryCode:(NSString *)countryCode andName:(NSString *)name andIndex:(NSInteger)index;

@end
