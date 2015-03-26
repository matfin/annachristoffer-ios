//
//  SliderViewController.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 26/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "SliderViewController.h"
#import "SlideImageViewController.h"

@interface SliderViewController ()
@property (nonatomic, strong) NSArray *childViewControllers;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@end

@implementation SliderViewController

@synthesize childViewControllers;

- (id)initWithChildViewControllers:(NSArray *)viewControllers {
    if(self = [super init]) {
        self.childViewControllers = viewControllers;
    }
    return self;
}

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
    
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
}

#pragma mark - Page view controller delegates

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    return [self.childViewControllers objectAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(SlideImageViewController *)viewController index];
    
    if(index == 0) {
        index = [self.childViewControllers count] - 1;
    }
    else {
        index--;
    }
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(SlideImageViewController *)viewController index];
    index++;
    
    if(index == [self.childViewControllers count]) {
        return [self viewControllerAtIndex:0];
    }
    else {
        return [self viewControllerAtIndex:index];
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
