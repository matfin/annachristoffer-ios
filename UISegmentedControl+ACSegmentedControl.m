//
//  UISegmentedControl+ACSegmentedControl.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 30/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "UISegmentedControl+ACSegmentedControl.h"
#import "UIColor+ACColor.h"

@implementation UISegmentedControl (ACSegmentedControl)

+ (id)initWithItems:(NSArray *)items andColor:(UIColor *)color withSelectedIndex:(NSInteger)selectedIndex {
    
    /**
     *  Initial set up
     */
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
    [segmentedControl setTranslatesAutoresizingMaskIntoConstraints:NO];
    [segmentedControl setSelectedSegmentIndex:selectedIndex];
    
    /**
     *  Segmented control appearance
     */
    [segmentedControl setBackgroundColor:[UIColor getColor:colorLightPink]];
    [segmentedControl setTintColor:[UIColor getColor:colorFuscia]];
    [segmentedControl setDividerImage:nil forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    NSDictionary *controlStateNormalAppearance = @{
        NSForegroundColorAttributeName: [UIColor getColor:colorFuscia],
        NSFontAttributeName: [UIFont fontWithName:@"OpenSans-Light" size:16.0f]
    };
    
    NSDictionary *controlStateSelectedAppearance = @{
        NSForegroundColorAttributeName: [UIColor getColor:colorLightPink],
        NSFontAttributeName: [UIFont fontWithName:@"OpenSans-Semibold" size:16.0f]
    };
    
    [segmentedControl setTitleTextAttributes:controlStateNormalAppearance forState:UIControlStateNormal];
    [segmentedControl setTitleTextAttributes:controlStateSelectedAppearance forState:UIControlStateSelected];
    
    return segmentedControl;
}

@end
