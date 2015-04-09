//
//  SlideImageViewController.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 26/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "SlideImageViewController.h"
#import "ImageController.h"
#import "UIView+Autolayout.h"
#import "UIView+Animate.h"

@interface SlideImageViewController ()
@property (nonatomic, strong) Image *slideImage;
@property (nonatomic, strong) UIImageView *slideImageView;
@property (nonatomic, strong) UIImageView *placeholderImageView;
@property (nonatomic, strong) ImageController *imageController;
@end

@implementation SlideImageViewController

@synthesize slideImageView;
@synthesize slideImage;
@synthesize placeholderImageView;

- (id)initWithImage:(Image *)image withIndex:(NSUInteger)index {
    if(self = [super init]) {
        self.slideImage = image;
        self.slideIndex = index;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.slideImageView = [UIImageView autoLayoutView];
    [self.slideImageView setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.slideImageView];
    
    if(self.slideImage.data == nil) {
        /**
         *  The placeholder image view if needed.
         */
        self.placeholderImageView = [UIImageView rotatingViewWithDuration:100.0f andRotations:0.5f andRepeatCount:10.0f];
        [self.placeholderImageView setImage:[UIImage imageNamed:@"LaunchScreenImage"]];
        [self.view addSubview:self.placeholderImageView];
        [self.view bringSubviewToFront:self.placeholderImageView];
        
        [self startSlideImageDownload];
    }
    else {
        self.placeholderImageView = nil;
        [self.slideImageView setImage:[UIImage imageWithData:slideImage.data]];
    }
    
    [self setupConstraints];
    
}

- (void)setupConstraints {
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[slideImageView]|" options:0 metrics:nil views:@{@"slideImageView": self.slideImageView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[slideImageView]|" options:0 metrics:nil views:@{@"slideImageView": self.slideImageView}]];
    
    if(self.placeholderImageView != nil) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderImageView
                                                              attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeCenterX
                                                             multiplier:1.0f
                                                               constant:0.0f
        ]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderImageView
                                                              attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeCenterY
                                                             multiplier:1.0f
                                                               constant:0.0f
        ]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderImageView
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0f
                                                               constant:120.0f
        ]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderImageView
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0f
                                                               constant:120.0f
        ]];
    }
}

#pragma mark - Image downloads

- (void)startSlideImageDownload {
    self.imageController = [ImageController new];
    self.imageController.imageObject = self.slideImage;
    
    __weak SlideImageViewController *weakSelf = self;
    [self.imageController setCompletionHandler:^{
        UIImage *fetchedSlideImage = [[UIImage alloc] initWithData:weakSelf.slideImage.data];
        [weakSelf.slideImageView setImage:fetchedSlideImage];
        weakSelf.imageController = nil;
        /**
         *  Get rid of the image placeholder view
         */
        [weakSelf.placeholderImageView.layer removeAllAnimations];
        [weakSelf.placeholderImageView removeFromSuperview];
        weakSelf.placeholderImageView = nil;
    }];
    
    [self.imageController startImageDownload];
}

- (void)stopImageDownload {
    [self.imageController stopImageDownload];
    self.imageController = nil;
}

#pragma mark - Cleanup

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self stopImageDownload];
}

- (void)dealloc {
    [self.imageController stopImageDownload];
}

@end
