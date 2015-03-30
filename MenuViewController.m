//
//  MenuViewController.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 30/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "MenuViewController.h"
#import "UIColor+ACColor.h"
#import "UISegmentedControl+ACSegmentedControl.h"

@interface MenuViewController ()
@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UISegmentedControl *languageControl;
@property (nonatomic, strong) UIButton *infoButton;
@property (nonatomic, strong) NSArray *languageLabels;
@property (nonatomic, strong) NSArray *languageCodes;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     *  Language labels and codes
     */
    self.languageCodes = @[@"en", @"de"];
    self.languageLabels = @[@"English", @"Deutsch"];
    
    /**
     *  The container view
     */
    self.containerView = [UIView autoLayoutView];
    [self.view addSubview:self.containerView];
    
    /**
     *  Language select
     */
    self.languageControl = [UISegmentedControl initWithItems:self.languageLabels andColor:[UIColor getColor:colorFuscia] withSelectedIndex:0];
    [self.languageControl addTarget:self action:@selector(languageControlSegmentWasChanged) forControlEvents:UIControlEventValueChanged];
    [self.containerView addSubview:self.languageControl];
    
    /**
     *  Infobutton
     */
    self.infoButton = [UIButton autoLayoutView];
    [self.infoButton setTitle:@"About me" forState:UIControlStateNormal];
    [self.infoButton setBackgroundColor:[UIColor getColor:colorLightPink]];
    [self.infoButton setTitleColor:[UIColor getColor:colorFuscia] forState:UIControlStateNormal];
    [self.infoButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:16.0f]];
    [self.infoButton.layer setBorderColor:[UIColor getColor:colorFuscia].CGColor];
    [self.infoButton.layer setBorderWidth:1.0f];
    [self.infoButton.layer setCornerRadius:4.0f];
    [self.containerView addSubview:self.infoButton];
    
    [self setupConstraints];
}

- (void)setupConstraints {
    [super setupConstraints];
    
    NSDictionary *views = @{
        @"languageControl": self.languageControl,
        @"infoButton": self.infoButton
    };
    NSDictionary *metrics = @{
        @"assetSpacing": @(30.0f),
        @"assetHeight": @(30.0f)
    };
    
    /**
     *  Container view constraints
     */
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0
    ]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0
    ]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:0.9
                                                           constant:0
    ]];
    
    /**
     *  Language segmented control
     */
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[languageControl]|" options:0 metrics:metrics views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[infoButton]|" options:0 metrics:metrics views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[languageControl(assetHeight)]-(assetSpacing)-[infoButton(assetHeight)]|" options:0 metrics:metrics views:views]];
}

#pragma mark - Events

- (void)languageControlSegmentWasChanged {
    NSString *languageCode = [self.languageCodes objectAtIndex:self.languageControl.selectedSegmentIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
