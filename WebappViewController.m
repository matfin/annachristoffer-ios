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
#import "Environment.h"
#import "LanguageController.h"

@interface WebappViewController ()
@property (nonatomic, strong) UIWebView *webappWebView;
@end

@implementation WebappViewController

@synthesize webappWebView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webappWebView = [UIWebView autoLayoutView];
    self.webappWebView.delegate = self;
    [self.webappWebView setBackgroundColor:[UIColor getColor:colorLightPink]];
    [self.view addSubview:self.webappWebView];
    
    /**
     *  Set up the constraints for the webview and then Load the contents of the webapp
     */
    [self setupConstraints];
    [self loadWebApp];
}

#pragma mark - Loading the web view content

- (void)loadWebApp {
    /**
     *  Grabbing the url from the info plist file and the current locale,
     *  so that the webapp and native app languages match up.
     */
    NSString *webappUrlString = [[Environment sharedInstance].environmentDictionary objectForKey:@"webappUrl"];
    Locale *currentLocale = [[LanguageController sharedInstance] getCurrentLocale];
    NSURL *webappURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", webappUrlString, currentLocale.languageCode]];
    
    /**
     *  Load the content into the webview. We set a custom user agent string 
     *  so the webapp knows its sitting inside the UIWebView for the native app.
     */
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:webappURL];
    NSString *userAgentString = @"com.annachristoffer.webview";
    [urlRequest setValue:userAgentString forHTTPHeaderField:@"User-Agent"];
    
    [self.webappWebView loadRequest:urlRequest];
}

#pragma mark - Web view delegate functions

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

#pragma mark - Setting up constraints

- (void)setupConstraints {
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[webappWebView]|" options:0 metrics:nil views:@{@"webappWebView": self.webappWebView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[webappWebView]|" options:0 metrics:nil views:@{@"webappWebView": self.webappWebView}]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    /**
     *  Cleanup
     */
    [self.webappWebView stopLoading];
}

@end
