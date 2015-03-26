//
//  NSArray+MessageCodes.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 25/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (MessageCodes)
+ (NSArray *)messagesFromOrderedSet:(NSOrderedSet *)messageCodeSet withLanguageCode:(NSString *)languageCode;
@end
