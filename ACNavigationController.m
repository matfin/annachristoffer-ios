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
#import "NSString+FontIcon.h"

@interface ACNavigationController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecogniser;
@end

@implementation ACNavigationController

@synthesize panGestureRecogniser;

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
    
    /**
     *  Pan gesture recogniser for the navigation bar
     */
    [self setupGestures];
}

- (void)setupGestures {
    self.panGestureRecogniser = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tabBarWasPanned:)];
    [self.panGestureRecogniser setMinimumNumberOfTouches:1];
    [self.panGestureRecogniser setMaximumNumberOfTouches:1];
    [self.panGestureRecogniser setDelegate:self];
    [self.navigationBar addGestureRecognizer:self.panGestureRecogniser];
}

- (void)tabBarWasPanned:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"navigationBarWasPanned" object:sender];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
