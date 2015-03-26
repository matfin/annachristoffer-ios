//
//  SlideImageViewController.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 26/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "SlideImageViewController.h"

@interface SlideImageViewController ()

@end

@implementation SlideImageViewController

@synthesize slideImageView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.slideImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
