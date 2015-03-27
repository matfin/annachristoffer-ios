//
//  DetailViewController.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 16/12/2014.
//  Copyright (c) 2014 Anna Christoffer. All rights reserved.
//

#import "DetailViewController.h"
#import "UIView+Autolayout.h"
#import "CaptionImageView.h"
#import "CaptionSliderView.h"

#import "Project.h"
#import "Image.h"
#import "Caption.h"
#import "Slider.h"

#import "ProjectController.h"
#import "ImageController.h"

@interface DetailViewController()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@end

@implementation DetailViewController

@synthesize project;
@synthesize scrollView;

-(void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    /**
     *  Add the scrollView
     */
    self.scrollView = [UIScrollView autoLayoutView];
    [self.view addSubview:self.scrollView];
    
    self.contentView = [UIView autoLayoutView];
    [self.scrollView addSubview:self.contentView];
    
    NSArray *projectCaptions = [project.captions array];
    
    for(Caption *caption in projectCaptions) {
        switch([caption.captionType integerValue]) {
            case captionTypeImage: {
                CaptionImageView *captionImageView = [[CaptionImageView alloc] initWithCaption:caption];
                [self.contentView addSubview:captionImageView];
                break;
            }
            case captionTypeSlider: {
                CaptionSliderView *captionSliderView = [[CaptionSliderView alloc] initWithCaption:caption];
                [self.contentView addSubview:captionSliderView];
                break;
            }
            case captionTypeVideo: {
                
                break;
            }
        }
    }
    [self setupConstraints];
    [self setupBackButton];
}

#pragma mark - the back button

- (void)setupBackButton {
    /**
     *  Customised back button
     */
    UIButton *backButton = [UIButton initWithFontIcon:iconArrowLeft withColor:[UIColor getColor:colorFuscia] andSize:24.0f andAlignment:NSTextAlignmentLeft];
    [backButton setTranslatesAutoresizingMaskIntoConstraints:YES];
    [backButton setFrame:CGRectMake(0.0f, 0.0f, 48.0f, 40.0f)];
    [backButton addTarget:self action:@selector(popToListViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
}

- (void)popToListViewController {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - constraints

- (void)setupConstraints {
    [super setupConstraints];
    
    /**
     *  Constraints for the scrollview
     */
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics:nil views:@{@"scrollView": self.scrollView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics:nil views:@{@"scrollView": self.scrollView}]];
    /**
     *  Setting up the horizontal constraint using items to explicitely pin the width to the scrollview width,
     *  which will prevent any unnecessary horizontal scrolling.
     */
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0]];
    
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:0 metrics:0 views:@{@"contentView":self.contentView}]];
    
    UIView *prevView = nil;
    
    for(UIView *view in self.contentView.subviews) {
        if([view isKindOfClass:[CaptionImageView class]] || [view isKindOfClass:[CaptionSliderView class]]) {
            /**
             *  Horizontal constraints
             */
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": view}]];
            
            /**
             *  Vertical constraints, pinning the first view to the top of the superview
             *  or else pinning the following views to the bottom of the previous view
             */
            if(prevView == nil) {
                [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]" options:0 metrics:nil views:@{@"view": view}]];
            }
            else {
                [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[prevView][view]" options:0 metrics:nil views:@{@"prevView": prevView, @"view": view}]];
            }
            prevView = view;
        }
    }
    
    /**
     *  The last vertical constraint - pin to the bottom of the superview
     */
    if(prevView != nil) {
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[prevView]|" options:0 metrics:nil views:@{@"prevView": prevView}]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[prevView]|" options:0 metrics:nil views:@{@"prevView": prevView}]];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

@end
