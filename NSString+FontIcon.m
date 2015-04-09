//
//  NSString+FontIcon.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 23/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "NSString+FontIcon.h"

@implementation NSString (FontIcon)
+ (NSString *)initWithFontIcon:(FontIcon)fontIcon {
    return [NSString fontIconStrings][fontIcon];
}

+ (NSArray *)fontIconStrings {
    static NSArray *iconStrings;
    static dispatch_once_t fontIconsToken;
    
    dispatch_once(&fontIconsToken, ^{
        iconStrings = @[
            @"\ue605",     //iconDots
            @"\ue601",     //iconInfo
            @"\ue602",     //iconMenu
            @"\ue603",     //iconProjects
            @"\ue607",     //iconRightArrow
            @"\ue608",     //iconLeftArrow
            @"\ue60e",     //iconLargePlay
            @"\ue60f",     //iconFullscreen
            @"\ue610",     //iconXing
            @"\ue604",     //iconBubble
            @"\ue609",     //iconPlay
            @"\ue60a",     //iconPause
            @"\ue600",     //iconShare
            @"\ue615",     //iconProgress
            @"\ue94a",     //iconWeb
            @"\ue606",     //iconTwitter
            @"\ue60b",     //iconFacebook
            @"\ue611",     //iconPinterest
            @"\ue60c",     //iconLinkedIn
            @"\ue60d",     //iconArrowLeft
            @"\ue612",     //iconArrowDown
            @"\ue613",     //iconArrowUp
            @"\ue614"      //iconArrowRight
        ];
    });
    
    return iconStrings;
}

@end
