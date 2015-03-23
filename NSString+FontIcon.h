//
//  NSString+FontIcon.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 23/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FontIcon) {
    iconDots,
    iconInfo,
    iconMenu,
    iconProjects,
    iconRightArrow,
    iconLeftArrow,
    iconLargePlay,
    iconFullscreen,
    iconXing,
    iconBubble,
    iconPlay,
    iconPause,
    iconWeb,
    iconTwitter,
    iconFacebook,
    iconLinkedIn,
    iconArrowLeft,
    iconArrowDown,
    iconArrowUp,
    iconArrowRight
};

@interface NSString (FontIcon)
+ (NSString *)initWithFontIcon:(FontIcon)fontIcon;
@end
