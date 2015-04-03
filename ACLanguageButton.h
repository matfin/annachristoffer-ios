//
//  ACLanguageButton.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 03/04/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Autolayout.h"
#import "NSString+Encoded.h"
#import "Locale.h"
#import "UIColor+ACColor.h"
#import "LanguageController.h"

@interface ACLanguageButton : UIButton
@property (nonatomic, strong) Locale *buttonLocale;
- (id)initWithLocale:(Locale *)locale;
- (void)setActive:(BOOL)active;
@end
