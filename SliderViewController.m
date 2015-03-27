//
//  SliderViewController.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 26/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "SliderViewController.h"
#import "SlideImageViewController.h"
#import "SliderIndicatorView.h"

@interface SliderViewController ()
@property (nonatomic, strong) NSArray *childViewControllers;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) SliderIndicatorView *sliderIndicatorView;
@end

@implementation SliderViewController

@synthesize childViewControllers;
@synthesize pageViewController;
@synthesize sliderIndicatorView;

- (id)initWithChildViewControllers:(NSArray *)viewControllers {
    if(self = [super init]) {
        self.childViewControllers = viewControllers;
    }
    return self;
}

#pragma mark - View controller setup

- (void)viewDidLoad {
    /**
     *  Setting up the page view controller
     */
    self.pageViewController = [[UIPageViewController alloc]  initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                               navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                             options:nil
                               ];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    /**
     *  Setting up the initial child view controller
     */
    if([self.childViewControllers count] > 0) {
        NSArray *initialChildViewControllers = [NSArray arrayWithObject:[self viewControllerAtIndex:0]];
        [self.pageViewController setViewControllers:initialChildViewControllers
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:nil
        ];
        
        [self.view addSubview:self.pageViewController.view];
        [self.pageViewController didMoveToParentViewController:self];
    }
    
    /**
     *  Adding the slider indicator
     */
    self.sliderIndicatorView = [[SliderIndicatorView alloc] initWithNumberOfSlides:[self.childViewControllers count]];
    [self.view addSubview:self.sliderIndicatorView];
    
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self setupConstraints];
}

- (void)setupConstraints {
    
    NSDictionary *metrics = @{@"indicatorHeight": @(8.0f)};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[sliderIndicatorView]|" options:0 metrics:nil views:@{@"sliderIndicatorView": self.sliderIndicatorView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[sliderIndicatorView(indicatorHeight)]|" options:0 metrics:metrics views:@{@"sliderIndicatorView": self.sliderIndicatorView}]];
    
}

#pragma mark - Page view controller delegates

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    return [self.childViewControllers objectAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(SlideImageViewController *)viewController slideIndex];
    
    if(index == 0) {
        index = [self.childViewControllers count] - 1;
    }
    else {
        index--;
    }
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(SlideImageViewController *)viewController slideIndex];
    index++;
    
    if(index == [self.childViewControllers count]) {
        return [self viewControllerAtIndex:0];
    }
    else {
        return [self viewControllerAtIndex:index];
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    SlideImageViewController *currentSlide = (SlideImageViewController *)[self.pageViewController.viewControllers lastObject];
    NSUInteger index = [currentSlide slideIndex];
    [self.sliderIndicatorView setCurrentSlideNumber:index];
}

#pragma mark - Cleanup

- (void)stopAllSlideImageDownloads {
    [self.childViewControllers makeObjectsPerformSelector:@selector(stopImageDownload)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self stopAllSlideImageDownloads];
}

- (void)dealloc {
    [self stopAllSlideImageDownloads];
}

@end
