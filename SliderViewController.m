//
//  SliderViewController.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 26/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "SliderViewController.h"

@interface SliderViewController ()

@end

@implementation SliderViewController

@synthesize childViewControllers;

- (id)initWithChildViewControllers:(NSArray *)viewControllers {
    if(self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil]) {
        [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        
        [self.view setBackgroundColor:[UIColor blackColor]];
        
        self.childViewControllers = viewControllers;
//        self.dataSource = self;
//        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
