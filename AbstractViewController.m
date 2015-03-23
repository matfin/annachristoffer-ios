//
//  AbstractViewController.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 18/12/2014.
//  Copyright (c) 2014 Anna Christoffer. All rights reserved.
//

#import "AbstractViewController.h"

@interface AbstractViewController ()
@end

@implementation AbstractViewController

@synthesize backgroundImageView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     *  View controller setup
     */
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self setTitle:@"Anna Claire Christoffer"];
    self.backgroundImageView = [UIImageView autoLayoutView];
    [self.backgroundImageView setImage:[UIImage imageNamed:@"BackgroundImage"]];
    [self.backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.view sendSubviewToBack:self.backgroundImageView];
    [self.view addSubview:self.backgroundImageView];
    
    /**
     *  Navigation bar button
     */
    UIButton *menuBarButton = [UIButton initWithFontIcon:iconMenu withColor:[UIColor getColor:colorFuscia] andSize:20.0f];
    [menuBarButton setTranslatesAutoresizingMaskIntoConstraints:YES];
    [menuBarButton setFrame:CGRectMake(0, 0, 48.0f, 48.0f)];
    UIBarButtonItem *menuBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBarButton];
    [self.navigationItem setRightBarButtonItem:menuBarButtonItem];
}

- (void)setupConstraints {
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[backgroundImageView]|" options:0 metrics:nil views:@{@"backgroundImageView": self.backgroundImageView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[backgroundImageView]|" options:0 metrics:nil views:@{@"backgroundImageView": self.backgroundImageView}]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
