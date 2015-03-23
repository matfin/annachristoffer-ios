//
//  ACNavigationController.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 22/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "ACNavigationController.h"
#import "UIColor+ACColor.h"
#import "UIView+Autolayout.h"

@interface ACNavigationController ()
@end

@implementation ACNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     *  Navigtion bar styling
     */
    [self.navigationBar setTranslucent:YES];
    [self.navigationBar setBarTintColor:[UIColor getColor:colorLightPink withAlpha:0.96f]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
        NSForegroundColorAttributeName:[UIColor getColor:colorFuscia],
        NSFontAttributeName:[UIFont fontWithName:@"OpenSans-Semibold" size:16.0f]
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
