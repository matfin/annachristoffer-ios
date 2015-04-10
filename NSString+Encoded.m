//
//  NSMutableString+Encoded.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 06/01/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+Encoded.h"

static NSArray *entities = nil;

@implementation NSString (Encoded)

+ (NSString *)decodeFromHTMLEntites:(NSString *)encodedString {
    
    //return [NSString htmlEntityStrings][0];
    NSMutableString *escaped = [NSMutableString stringWithString:encodedString];
    NSArray *entitiesArray = [NSString htmlEntityStrings];
    NSUInteger i, count = [entitiesArray count];
    
    for(i = 0; i < count; i++) {
        NSRange range = [encodedString rangeOfString:[entitiesArray objectAtIndex:i]];
        
        if(range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:[entitiesArray objectAtIndex:i]
                                     withString:[NSString stringWithFormat:@"%C", (unsigned short) (160 + i)]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])
            ];
        }
    }
    
    return escaped;
}

+ (NSArray *)htmlEntityStrings {
    
    if(entities == nil) {
        static dispatch_once_t entitiesToken;
        
        dispatch_once(&entitiesToken, ^{
            entities = @[
                @"&nbsp;", @"&iexcl;", @"&cent;", @"&pound;", @"&curren;", @"&yen;", @"&brvbar;",
                @"&sect;", @"&uml;", @"&copy;", @"&ordf;", @"&laquo;", @"&not;", @"&shy;", @"&reg;",
                @"&macr;", @"&deg;", @"&plusmn;", @"&sup2;", @"&sup3;", @"&acute;", @"&micro;",
                @"&para;", @"&middot;", @"&cedil;", @"&sup1;", @"&ordm;", @"&raquo;", @"&frac14;",
                @"&frac12;", @"&frac34;", @"&iquest;", @"&Agrave;", @"&Aacute;", @"&Acirc;",
                @"&Atilde;", @"&Auml;", @"&Aring;", @"&AElig;", @"&Ccedil;", @"&Egrave;",
                @"&Eacute;", @"&Ecirc;", @"&Euml;", @"&Igrave;", @"&Iacute;", @"&Icirc;", @"&Iuml;",
                @"&ETH;", @"&Ntilde;", @"&Ograve;", @"&Oacute;", @"&Ocirc;", @"&Otilde;", @"&Ouml;",
                @"&times;", @"&Oslash;", @"&Ugrave;", @"&Uacute;", @"&Ucirc;", @"&Uuml;", @"&Yacute;",
                @"&THORN;", @"&szlig;", @"&agrave;", @"&aacute;", @"&acirc;", @"&atilde;", @"&auml;",
                @"&aring;", @"&aelig;", @"&ccedil;", @"&egrave;", @"&eacute;", @"&ecirc;", @"&euml;",
                @"&igrave;", @"&iacute;", @"&icirc;", @"&iuml;", @"&eth;", @"&ntilde;", @"&ograve;",
                @"&oacute;", @"&ocirc;", @"&otilde;", @"&ouml;", @"&divide;", @"&oslash;", @"&ugrave;",
                @"&uacute;", @"&ucirc;", @"&uuml;", @"&yacute;", @"&thorn;", @"&yuml;"
            ];
        });
    }
    
    return entities;
}

@end

