//
//  ACCategoryButton.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 03/04/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LanguageController.h"
#import "MessageCode.h"
#import "ProjectCategory.h"

@interface ACCategoryButton : UIButton

@property (nonatomic, strong) ProjectCategory *category;
@property (nonatomic, strong) NSString *key;
- (void)updateTextFromMessageCodes;
- (void)setActive:(BOOL)active;
@end
