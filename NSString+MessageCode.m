//
//  NSString+MessageCode.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 24/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "NSString+MessageCode.h"
#import "MessageCode.h"
#import "NSString+Encoded.h"

@implementation NSString (MessageCode)

+ (NSString *)messageFromSet:(NSSet *)messageCodeSet withKey:(NSString *)key withLanguageCode:(NSString *)languageCode {
    
    /**
     *  Creating the set predicate so we can pull out a message code by the key and language
     */
    NSPredicate *messageCodePredicate = [NSPredicate predicateWithFormat:@"SELF.messageKey MATCHES %@ and self.languageCode MATCHES %@", key, languageCode];
    
    /**
     *  Filter the incoming set and set it as an array
     */
    NSArray *filteredMessageCodes = [[messageCodeSet filteredSetUsingPredicate:messageCodePredicate] allObjects];
    
    /**
     *  Grab the string
     */
    MessageCode *filteredMessageCode = (MessageCode *)[filteredMessageCodes objectAtIndex:0];
        
    return filteredMessageCode.messageContent;
}

@end
