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
#import "ACLanguageButton.h"
#import "ACCategoryButton.h"
#import "Locale.h"

@interface MenuViewController () <CategoryControllerDelegate>

@property (nonatomic, strong) NSArray *locales;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) Locale *locale;
@property (nonatomic, strong) UIView *buttonsView;
@property (nonatomic, strong) NSMutableArray *languageButtons;
@property (nonatomic, strong) NSMutableArray *categoryButtons;
@property (nonatomic, strong) ACButton *infoButton;
@property (nonatomic, strong) CategoryController *categoryController;

@end

@implementation MenuViewController

@synthesize locales;
@synthesize categories;
@synthesize locale;
@synthesize buttonsView;
@synthesize categoryController;
@synthesize categoryButtons;
@synthesize infoButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     *  The category controller
     */
    self.categoryController = [CategoryController sharedInstance];
    [self.categoryController setDelegate:self];
    [[CategoryController sharedInstance] fetchCategoryContent];
    
    /**
     *  The view containing the buttons
     */
    self.buttonsView = [UIView autoLayoutView];
    [self.view addSubview:self.buttonsView];
    self.languageButtons = [NSMutableArray new];
    
    /**
     *  Language labels and codes
     */
    self.locales = [[LanguageController sharedInstance] availableLocales];
    self.locale = [[LanguageController sharedInstance] getCurrentLocale];
    for(Locale *localeItem in self.locales) {
        ACLanguageButton *languageButton = [[ACLanguageButton alloc] initWithLocale:localeItem];
        [languageButton setActive:[languageButton.buttonLocale.languageCode isEqualToString:self.locale.languageCode]];
        [languageButton addTarget:self action:@selector(languageButtonWasPushed:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonsView addSubview:languageButton];
        [self.languageButtons addObject:languageButton];
    }
    
    /**
     *  Setting up the constraints
     */
    [self setupConstraints];
}

- (void)setupConstraints {
    [super setupConstraints];
    /**
     *  Button view container
     */
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[buttonsView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"buttonsView": self.buttonsView}
    ]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[buttonsView(40)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"buttonsView": self.buttonsView}
    ]];
    
    UIView *prev = nil;
    for(UIView *view in self.buttonsView.subviews) {
        if(prev == nil) {
            [self.buttonsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]"
                                                                                     options:0
                                                                                     metrics:nil
                                                                                       views:@{@"view": view}
            ]];
        }
        else {
            [self.buttonsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[prev][view(==prev)]"
                                                                                     options:0
                                                                                     metrics:nil
                                                                                       views:@{@"prev": prev, @"view": view}
            ]];
        }
        
        [self.buttonsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:@{@"view": view}
        ]];
        
        prev = view;
    }
    
    [self.buttonsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[prev]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:@{@"prev": prev}
    ]];
    
    [self.buttonsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[prev]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:@{@"prev": prev}
    ]];
}

#pragma mark - Categories 

- (void)categoryDataFetchedAndStored {
    self.categories = [self.categoryController fetchCategories];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addCategoryButtons];
    });
}

- (void)addCategoryButtons {
    
    self.categoryButtons = [NSMutableArray new];
    
    NSDictionary *metrics = @{
        @"buttonHeight": @(40.0f)
    };
    
    UIView *categoryButtonContainer = [UIView autoLayoutView];
    [categoryButtonContainer setBackgroundColor:[UIColor getColor:colorLightPink]];
    [self.view addSubview:categoryButtonContainer];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[categoryButtonContainer]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"categoryButtonContainer": categoryButtonContainer}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[categoryButtonContainer]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"categoryButtonContainer": categoryButtonContainer}]];
    
    UIView *prev = nil;
    
    for(ProjectCategory *category in self.categories) {
        
        ACCategoryButton *categoryButton = [[ACCategoryButton alloc] init];
        [categoryButton setCategory:category];
        [categoryButton setKey:@"title"];
        [categoryButton updateTextFromMessageCodes];
        [categoryButtonContainer addSubview:categoryButton];
        [self.categoryButtons addObject:categoryButton];
        
        if(prev == nil) {
            [categoryButtonContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(24)-[button(buttonHeight)]"
                                                                              options:0
                                                                              metrics:metrics
                                                                                views:@{@"button": categoryButton}
            ]];
        }
        else {
            [categoryButtonContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[prev][button(buttonHeight)]"
                                                                              options:0
                                                                              metrics:metrics
                                                                                views:@{@"prev": prev, @"button": categoryButton}
            ]];
        }
        
        [categoryButtonContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[button]|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:@{@"button": categoryButton}
        ]];
        
        prev = categoryButton;
    }
    
    [categoryButtonContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[prev]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"prev": prev}
    ]];
    
    [categoryButtonContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[prev]"
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:@{@"prev": prev}
    ]];

    /**
     *  The info button
     */
    self.infoButton = [[ACButton alloc] initWithTitleKey:@"button.aboutme"];
    [self.infoButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans-SemiBold" size:16.0f]];
    [self.infoButton setTitleColor:[UIColor getColor:colorFuscia] forState:UIControlStateNormal];
    [categoryButtonContainer addSubview:self.infoButton];
    
    [categoryButtonContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[infoButton]|" options:0 metrics:metrics views:@{@"infoButton": self.infoButton}]];
    [categoryButtonContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[prev][infoButton(buttonHeight)]|" options:0 metrics:metrics views:@{@"prev": prev, @"infoButton": self.infoButton}]];
}

#pragma mark - Events

- (void)languageButtonWasPushed:(id)sender {
    ACLanguageButton *pushedButton = (ACLanguageButton *)sender;
    Locale *chosenLocale = pushedButton.buttonLocale;
    for(ACLanguageButton *button in self.languageButtons) {
        [button setActive:NO];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"languageDidChange" object:chosenLocale];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menuBarToggleWasCalled" object:nil];
    
    [pushedButton setActive:YES];
    
}

- (void)infoButtonWasPushed {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"infoButtonWasPushed" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menuBarToggleWasCalled" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
