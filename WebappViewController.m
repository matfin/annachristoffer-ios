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
@property (nonatomic, strong) NSString *callbackScheme;
@end

@implementation WebappViewController

@synthesize webappWebView;
@synthesize callbackScheme;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webappWebView = [UIWebView autoLayoutView];
    self.webappWebView.delegate = self;
    [self.webappWebView setBackgroundColor:[UIColor getColor:colorLightPink]];
    [self.view setBackgroundColor:[UIColor getColor:colorLightPink]];
    [self.view addSubview:self.webappWebView];
    
    /**
     *  Getting the callback scheme
     */
    self.callbackScheme = [[Environment sharedInstance].environmentDictionary objectForKey:@"callbackScheme"];
    
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
    [urlRequest setValue:userAgentString forHTTPHeaderField:@"UserAgent"];
    
    [self.webappWebView loadRequest:urlRequest];
}

#pragma mark - Web view delegate functions

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return [self handleWebappCallbackWithRequest:request];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
}

#pragma mark - handling custom protocol url requests

- (BOOL)handleWebappCallbackWithRequest:(NSURLRequest *)request {
    
    NSString *scheme = [[request URL] scheme];
    /**
     *  Checking for the webapps callback schemes to match the correct one
     */
    if([self.callbackScheme isEqualToString:scheme]) {
        /**
         *  Checking the content of the scheme by converting the 
         *  json query returned to an NSDictionary
         */
        NSString *queryASString = [[[request URL] query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *queryData = [queryASString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *jsonError = nil;
        NSDictionary *messageDictionary = [NSJSONSerialization JSONObjectWithData:queryData
                                                                          options:NSJSONReadingAllowFragments
                                                                            error:&jsonError
        ];
        
        /**
         *  If there was an error, exit the webview and return to the native app.
         */
        if(jsonError != nil) {
            [self exitWebView];
        }
        else {
            /**
             *  Checking the content of the callback message
             */
            if([[messageDictionary valueForKey:@"templateRendered"] isEqualToString:@"components_mobile_header"]) {
                /**
                 *  When the template header has been loaded, call this JS function inside the webview
                 *  which will then render the button to exit from the webapp.
                 */
                [self.webappWebView stringByEvaluatingJavaScriptFromString:@"Device.wasLoadedInsideWebView();"];
            }
            else if([[messageDictionary valueForKey:@"action"] isEqualToString:@"exit"]) {
                [self exitWebView];
            }
        }
    }
    
    return YES;
}

#pragma mark - Exit the webview

- (void)exitWebView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Setting up constraints

- (void)setupConstraints {
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[webappWebView]|" options:0 metrics:nil views:@{@"webappWebView": self.webappWebView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(16)-[webappWebView]|" options:0 metrics:nil views:@{@"webappWebView": self.webappWebView}]];
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
