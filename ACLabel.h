//
//  ACLabel.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 18/12/2014.
//  Copyright (c) 2014 Anna Christoffer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LanguageController.h"
#import "MessageCode.h"
#import "ContentItem.h"
#import "Date.h"

@interface ACLabel : UILabel
@property (nonatomic, strong) NSSet *messageCodes;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) ContentItem *contentItem;
- (void)updateTextFromMessageCodes;
- (void)updateDateLabel;
@end
