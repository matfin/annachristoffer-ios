//
//  NSMutableString+Encoded.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 06/01/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ACLanguageCode) {
    en,
    de
};

@interface NSString (Encoded)
- (NSString *)asDecodedFromEntities;
@end
