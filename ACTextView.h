//
//  ACTextView.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 02/04/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACTextView : UITextView
@property (nonatomic, strong) NSSet *messageCodes;
@property (nonatomic, strong) NSString *key;
- (void)updateTextFromMessageCodes;
@end
