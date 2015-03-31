//
//  LanguageController.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 30/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Encoded.h"

@protocol LanguageProtocol <NSObject>
- (void)languageDidChangeWithCode:(ACLanguageCode)languageCode;
@end

@interface LanguageController : NSObject
@property (nonatomic, weak) id<LanguageProtocol> delegate;
+ (LanguageController *)sharedInstance;
- (void)updateLanguageWithCode:(ACLanguageCode)languageCode;
- (ACLanguageCode)currentLanguageCode;
@end
