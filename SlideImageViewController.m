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

@interface SlideImageViewController ()
@property (nonatomic, strong) Image *slideImage;
@property (nonatomic, strong) UIImageView *slideImageView;
@property (nonatomic, strong) ImageController *imageController;
@end

@implementation SlideImageViewController

@synthesize slideImageView;
@synthesize slideImage;

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
    [self.view addSubview:self.slideImageView];
    [self setupConstraints];
    [self startSlideImageDownload];
}

- (void)setupConstraints {
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[slideImageView]|" options:0 metrics:nil views:@{@"slideImageView": self.slideImageView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[slideImageView]|" options:0 metrics:nil views:@{@"slideImageView": self.slideImageView}]];
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
    }];
    
    [self.imageController startImageDownload];
}

#pragma mark - Cleanup

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.imageController stopImageDownload];
}

- (void)dealloc {
    [self.imageController stopImageDownload];
}

@end
