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
@property (nonatomic, strong) UIScrollView *scrollView;
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
@synthesize scrollView;
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
    self.scrollView = [UIScrollView autoLayoutView];
    [self.scrollView setDelegate:self];
    [self.scrollView setMinimumZoomScale:1.0f];
    [self.scrollView setMaximumZoomScale:3.0f];
    
    self.imageContainerView = [UIView autoLayoutView];
    

    self.imageView = [UIImageView autoLayoutView];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.imageContainerView addSubview:self.imageView];
    [self.scrollView addSubview:self.imageContainerView];
    [self.view addSubview:self.scrollView];
    
    /**
     *  Then setting up the constraints
     */
    [self setupConstraints];
}

#pragma mark - set up and update constraints

- (void)setupConstraints {
    
    NSDictionary *views = @{
        @"scrollView": self.scrollView,
        @"imageContainerView": self.imageContainerView,
        @"imageView": self.imageView
    };
    
    
    /**
     *  Constraint for the scrollView
     */
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageContainerView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageContainerView]|" options:0 metrics:nil views:views]];
    
//    [self.imageContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:0 metrics:nil views:views]];
//    [self.imageContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]|" options:0 metrics:nil views:views]];
    
    [self.imageContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView
                                                                        attribute:NSLayoutAttributeCenterX
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.imageContainerView
                                                                        attribute:NSLayoutAttributeCenterX
                                                                       multiplier:1.0f
                                                                         constant:0
    ]];
    
    [self.imageContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView
                                                                        attribute:NSLayoutAttributeCenterY
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.imageContainerView
                                                                        attribute:NSLayoutAttributeCenterY
                                                                       multiplier:1.0f
                                                                         constant:0
    ]];
    
    [self.imageContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.imageContainerView
                                                                        attribute:NSLayoutAttributeWidth
                                                                       multiplier:1.0f
                                                                         constant:0
    ]];
    
    [self.imageContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.imageContainerView
                                                                        attribute:NSLayoutAttributeHeight
                                                                       multiplier:1.0f
                                                                         constant:0
    ]];
    
}

- (void)updateImageViewConstraintsWithOrigin:(CGPoint)center andSize:(CGSize)size{
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)updateImageView:(Image *)image {
    [self animateFadeIn];
    [self.imageView setImage:[UIImage imageWithData:image.data]];
    [self setupConstraints];
}

#pragma mark - UI update when image is set

- (void)updateDetailView {

}

#pragma mark - handling zoom

- (void)refreshZoom {
    float minimumZoom = MIN(self.view.bounds.size.width / self.imageView.bounds.size.width, self.view.bounds.size.height / self.imageView.image.size.height);
    if(minimumZoom > 1) minimumZoom = 1;
    self.scrollView.minimumZoomScale = minimumZoom;
    
    if(minimumZoom == self.zoomScale) minimumZoom += 0.000001;
    
    self.zoomScale = self.scrollView.zoomScale = minimumZoom;
}

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
