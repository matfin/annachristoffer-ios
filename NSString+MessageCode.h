//
//  NSString+MessageCode.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 24/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MessageCode)
+ (NSString *)messageFromSet:(NSSet *)messageCodeSet withKey:(NSString *)key withLanguageCode:(NSString *)languageCode;
@end
