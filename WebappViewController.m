//
//  WebappViewController.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 08/04/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "WebappViewController.h"
#import "UIView+Autolayout.h"
#import "UIColor+ACColor.m"

@interface WebappViewController () <UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webappWebView;
@end

@implementation WebappViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor getColor:colorLightPink]];
    self.webappWebView = [UIWebView autoLayoutView];
}

- (void)setupConstraints {
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[webappWebView]|" options:0 metrics:nil views:@{@"webappWebView": self.webappWebView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[webappWebView]|" options:0 metrics:nil views:@{@"webappWebView": self.webappWebView}]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
