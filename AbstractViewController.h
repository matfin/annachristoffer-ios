//
//  AbstractViewController.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 18/12/2014.
//  Copyright (c) 2014 Anna Christoffer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Autolayout.h"
#import "NSString+FontIcon.h"
#import "UIColor+ACColor.h"
#import "UIButton+ACButton.h"

@interface AbstractViewController : UIViewController
@property (nonatomic, strong) UIImageView *backgroundImageView;
- (void)setupConstraints;
@end
