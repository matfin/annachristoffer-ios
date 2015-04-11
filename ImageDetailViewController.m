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

@interface ImageDetailViewController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGestureRecognizer;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ImageDetailViewController

@synthesize pinchGestureRecognizer;
@synthesize imageView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    /**
     *  The image view
     */
    self.imageView = [UIImageView autoLayoutView];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:self.imageView];
    
    /**
     *  Adding the pinch gesture recogniser
     */
    self.pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(viewWasPinched:)];
    [self.pinchGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:self.pinchGestureRecognizer];
    
    /**
     *  Then setting up the constraints
     */
    [self setupConstraints];
}

#pragma mark - setting up constraints

- (void)setupConstraints {
    
    NSDictionary *views = @{@"imageView": self.imageView};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]|" options:0 metrics:nil views:views]];
}

- (void)updateImageView:(Image *)image {
    [self animateFadeIn];
    [self.imageView setImage:[UIImage imageWithData:image.data]];
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

#pragma mark - Pinch gesture recogniser

- (void)viewWasPinched:(UIPinchGestureRecognizer *)pinchGestureRegogniser {
    
    CGFloat scale = [pinchGestureRecognizer scale];
    
    switch([pinchGestureRecognizer state]) {
        case UIGestureRecognizerStateBegan: {
            
            break;
        }
        case UIGestureRecognizerStateChanged: {
            
            /**
             *  Adjusting the alpha properties of the views, when it dips below 1.0f
             */
            [self.view setBackgroundColor:[UIColor getColor:colorBlack withAlpha:(scale > 1.0f ? 1.0f : scale)]];
            [self.imageView setAlpha:scale];
            
            /**
             *  Setting the scale of the image in the image view
             */
            if(scale > 1.0) {
                [self.imageView setImage:nil];
            }
            
            break;
        }
        case UIGestureRecognizerStateEnded: {
            
            if(scale < 0.6f) {
                [self animateFadeOut];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"imageViewExitWasCalled" object:nil];
            }
            else if(scale >= 0.6f && scale < 1.0f) {
                [self animateFadeIn];
            }
            
            break;
        }
        default: {
            break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [self.view removeGestureRecognizer:self.pinchGestureRecognizer];
}

@end
