//
//  ImageDetailViewController.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 10/04/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "ImageDetailViewController.h"
#import "UIColor+ACColor.h"
#import "UIView+Autolayout.m"

@interface ImageDetailViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *imageScrollView;
@property (nonatomic, strong) UIView *imageContainerView;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) NSLayoutConstraint *centerXConstraint;
@property (nonatomic, strong) NSLayoutConstraint *centerYConstraint;
@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;

@property (nonatomic) CGFloat zoomScale;

@end

@implementation ImageDetailViewController

@synthesize imageView;
@synthesize imageScrollView;
@synthesize centerXConstraint;
@synthesize centerYConstraint;
@synthesize widthConstraint;
@synthesize heightConstraint;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor clearColor]];

    /**
     *  The scrollview and the image view
     */
    self.imageScrollView = [UIScrollView autoLayoutView];
    [self.imageScrollView setDelegate:self];
    [self.imageScrollView setMinimumZoomScale:0.6f];
    [self.imageScrollView setMaximumZoomScale:3.0f];
    
    self.imageContainerView = [UIView autoLayoutView];
    

    self.imageView = [UIImageView autoLayoutView];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.imageContainerView addSubview:self.imageView];
    [self.imageScrollView addSubview:self.imageContainerView];
    [self.view addSubview:self.imageScrollView];
    
    /**
     *  Then setting up the constraints
     */
    [self setupConstraints];
}

#pragma mark - set up and update constraints

- (void)setupConstraints {
    
    NSDictionary *views = @{
        @"imageScrollView": self.imageScrollView,
        @"imageContainerView": self.imageContainerView,
        @"imageView": self.imageView
    };
    
    NSDictionary *metrics = @{
        @"windowWidth": @(self.view.frame.size.width),
        @"windowHeight": @(self.view.frame.size.height)
    };
    
    /**
     *  Constraint for the scrollView
     */
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageScrollView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageScrollView]|" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageContainerView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageContainerView]|" options:0 metrics:nil views:views]];
    
    [self.imageContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView(windowWidth)]" options:0 metrics:metrics views:views]];
    [self.imageContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView(windowHeight)]" options:0 metrics:metrics views:views]];
    
//    [self.imageContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView
//                                                                        attribute:NSLayoutAttributeCenterX
//                                                                        relatedBy:NSLayoutRelationEqual
//                                                                           toItem:self.imageContainerView
//                                                                        attribute:NSLayoutAttributeCenterX
//                                                                       multiplier:1.0f
//                                                                         constant:0
//    ]];
//    
//    [self.imageContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView
//                                                                        attribute:NSLayoutAttributeCenterY
//                                                                        relatedBy:NSLayoutRelationEqual
//                                                                           toItem:self.imageContainerView
//                                                                        attribute:NSLayoutAttributeCenterY
//                                                                       multiplier:1.0f
//                                                                         constant:0
//    ]];
//    
//    [self.imageContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView
//                                                                        attribute:NSLayoutAttributeWidth
//                                                                        relatedBy:NSLayoutRelationEqual
//                                                                           toItem:self.imageContainerView
//                                                                        attribute:NSLayoutAttributeWidth
//                                                                       multiplier:1.0f
//                                                                         constant:0
//    ]];
//    
//    [self.imageContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView
//                                                                        attribute:NSLayoutAttributeHeight
//                                                                        relatedBy:NSLayoutRelationEqual
//                                                                           toItem:self.imageContainerView
//                                                                        attribute:NSLayoutAttributeHeight
//                                                                       multiplier:1.0f
//                                                                         constant:0
//    ]];
    
}

- (void)updateImageView:(Image *)image {
    [self animateFadeIn];
    [self.imageView setImage:[UIImage imageWithData:image.data]];
    //[self setupConstraints];
}

#pragma mark - handling zoom

- (void)animateFadeIn {
    [self.view.layer removeAllAnimations];
    [self.imageView.layer removeAllAnimations];
    [UIView animateWithDuration:0.25 animations:^{
        [self.view setBackgroundColor:[UIColor getColor:colorBlack]];
        [self.imageView setAlpha:1.0];
    }];
}

- (void)animateFadeOut {
    [self.view.layer removeAllAnimations];
    [self.imageView.layer removeAllAnimations];
    [UIView animateWithDuration:0.25 animations:^{
        [self.view setBackgroundColor:[UIColor clearColor]];
        [self.imageView setAlpha:0];
    }];
}

#pragma mark - scrollview delegate 

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    CGFloat scale = [scrollView zoomScale];
    
    if(scale < 1.0f) {
        [self.view setBackgroundColor:[UIColor getColor:colorBlack withAlpha:(scale > 1.0f ? 1.0f : scale)]];
        [self.imageView setAlpha:scale];
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    if(scale <= 0.6f) {
        [self animateFadeOut];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"imageViewExitWasCalled" object:nil];
    }
    else {
        [self animateFadeIn];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
}

@end
