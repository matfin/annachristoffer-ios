//
//  NSMutableString+Encoded.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 06/01/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+Encoded.h"

@implementation NSString (Encoded)
- (NSString *)asDecodedFromEntities {
    
    NSData *stringData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *encodingAttributes = @{
        NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
        NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]
    };
    NSMutableAttributedString *decodedString = [[NSMutableAttributedString alloc] initWithData:stringData
                                                                    options:encodingAttributes
                                                                    documentAttributes:nil
                                                                    error:nil
    ];
    
    return [decodedString string];
}

@end

