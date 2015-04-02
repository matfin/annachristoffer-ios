//
//  TitleLabel.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 18/12/2014.
//  Copyright (c) 2014 Anna Christoffer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LanguageController.h"
#import "MessageCode.h"

@interface TitleLabel : UILabel
@property (nonatomic, strong) NSSet *messageCodes;
@property (nonatomic, strong) NSString *key;
- (void)updateTextFromMessageCodes;
@end
