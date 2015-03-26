//
//  NSArray+MessageCodes.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 25/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "NSArray+MessageCodes.h"

@implementation NSArray (MessageCodes)
+ (NSArray *)messagesFromOrderedSet:(NSOrderedSet *)messageCodeSet withLanguageCode:(NSString *)languageCode {
    NSPredicate *messageCodesPredicate = [NSPredicate predicateWithFormat:@"SELF.messageKey MATCHES %@ and self.languageCode MATCHES %@", @"content", languageCode];
    
    NSArray *filteredMessageCodes = [[messageCodeSet filteredOrderedSetUsingPredicate:messageCodesPredicate] array];
    
    return filteredMessageCodes;
}

@end
