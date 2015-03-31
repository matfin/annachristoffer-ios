//
//  LanguageController.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 30/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Encoded.h"

@interface LanguageController : NSObject
+ (LanguageController *)sharedInstance;
- (void)updateLanguageWithCode:(ACLanguageCode)languageCode;
- (ACLanguageCode)currentLanguageCode;
@end
