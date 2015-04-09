//
//  CaptionImageView.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 25/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Autolayout.h"
#import "NSString+Encoded.h"
#import "UIColor+ACColor.h"
#import "NSString+MessageCode.h"
#import "Caption.h"
#import "MessageCode.h"
#import "NSArray+MessageCodes.h"

@interface CaptionImageView : UIView
- (id)initWithCaption:(Caption *)caption;
@end
