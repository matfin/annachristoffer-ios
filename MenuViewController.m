//
//  MenuViewController.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 30/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "MenuViewController.h"
#import "LanguageController.h"
#import "CategoryController.h"
#import "UIColor+ACColor.h"
#import "NSString+Encoded.h"
#import "ACButton.h"
#import "Locale.h"
#import "UISegmentedControl+ACSegmentedControl.h"

@interface MenuViewController ()
@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UISegmentedControl *languageControl;
@property (nonatomic, strong) ACButton *infoButton;
@property (nonatomic, strong) NSArray *locales;
@property (nonatomic, strong) NSMutableArray *languageLabels;
@property (nonatomic, strong) Locale *locale;

@end

@implementation MenuViewController

@synthesize languageControl;
@synthesize infoButton;
@synthesize locales;
@synthesize locale;
@synthesize languageLabels;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     *  Language labels and codes
     */
    self.locales = [[LanguageController sharedInstance] availableLocales];
    self.locale = [[LanguageController sharedInstance] getCurrentLocale];
    self.languageLabels = [NSMutableArray new];
    for(Locale *localeItem in self.locales) {
        [self.languageLabels addObject:localeItem.name];
    }
    
    /**
     *  The container view
     */
    self.containerView = [UIView autoLayoutView];
    [self.view addSubview:self.containerView];
    
    /**
     *  Language select
     */
    self.languageControl = [UISegmentedControl initWithItems:[NSArray arrayWithArray:self.languageLabels] andColor:[UIColor getColor:colorFuscia] withSelectedIndex:self.locale.index];
    [self.languageControl addTarget:self action:@selector(languageControlSegmentWasChanged) forControlEvents:UIControlEventValueChanged];
    [self.containerView addSubview:self.languageControl];
    
    /**
     *  Infobutton
     */
    self.infoButton = [[ACButton alloc] initWithTitleKey:@"button.aboutme"];
    [self.infoButton setBackgroundColor:[UIColor getColor:colorLightPink]];
    [self.infoButton setTitleColor:[UIColor getColor:colorFuscia] forState:UIControlStateNormal];
    [self.infoButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:16.0f]];
    [self.infoButton.layer setBorderColor:[UIColor getColor:colorFuscia].CGColor];
    [self.infoButton.layer setBorderWidth:1.0f];
    [self.infoButton.layer setCornerRadius:4.0f];
    [self.infoButton addTarget:self action:@selector(infoButtonWasPushed) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.infoButton];
    
    /**
     *  Grabbing the categories from the endpoint
     */
    [[CategoryController sharedInstance] fetchCategoryContent];
    
    /**
     *  Setting up the constraints
     */
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

- (void)infoButtonWasPushed {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"infoButtonWasPushed" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menuBarToggleWasCalled" object:nil];
}

- (void)languageControlSegmentWasChanged {
    [[LanguageController sharedInstance] updateLanguageWithLocale:[self.locales objectAtIndex:self.languageControl.selectedSegmentIndex]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menuBarToggleWasCalled" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
