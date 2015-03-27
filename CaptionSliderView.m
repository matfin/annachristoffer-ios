//
//  CaptionSliderView.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 26/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "CaptionSliderView.h"
#import "ImageController.h"
#import "UITextView+ACTextView.h"
#import "SliderViewController.h"
#import "SlideImageViewController.h"

@interface CaptionSliderView ()
@property (nonatomic, strong) Caption *caption;
@property (nonatomic, strong) Slider *slider;
@property (nonatomic, strong) NSArray *contentParagraphs;
@property (nonatomic, strong) NSArray *slideImages;
@property (nonatomic, strong) SliderViewController *sliderViewController;
@property (nonatomic, strong) ImageController *imageController;
@end

@implementation CaptionSliderView

@synthesize caption;
@synthesize slider;
@synthesize contentParagraphs;
@synthesize slideImages;
@synthesize sliderViewController;
@synthesize imageController;

- (id)initWithCaption:(Caption *)captionItem {
    if(self = [super init]) {
        /**
         *  Setting up the view and the caption items
         */
        self.caption = captionItem;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        /**
         *  Grabbing the slides and setting up the view controllers.
         */
        self.slideImages = [caption.slider.images array];
        NSMutableArray *sliderChildViewControllers = [NSMutableArray new];
        NSUInteger index = 0;
        for(Image *slideImage in self.slideImages) {
            [sliderChildViewControllers addObject:[[SlideImageViewController alloc] initWithImage:slideImage withIndex:index]];
            index++;
        }
        
        /**
         *  Setting up the slider view controller
         */
        self.sliderViewController = [[SliderViewController alloc] initWithChildViewControllers:[NSArray arrayWithArray:sliderChildViewControllers]];
        [self addSubview:self.sliderViewController.view];
        
        /**
         *  The text accompanying the slider
         */
        self.contentParagraphs = [NSArray messagesFromOrderedSet:self.caption.messageCodes withLanguageCode:@"en"];
        
        for(MessageCode *messageCode in self.contentParagraphs) {
            UITextView *contentTextView = [UITextView initAsCaptionTextView];
            [contentTextView setText:messageCode.messageContent];
            [self addSubview:contentTextView];
        }
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints {
    
    UIView *prevView = nil;
    NSDictionary *metrics = @{@"imageSliderHeight": @(240.0f)};
    
    for(UIView *view in self.subviews) {
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": view}]];
        
        if(prevView == nil) {
            if([view isKindOfClass:[UIView class]]) {
                [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view(imageSliderHeight)]" options:0 metrics:metrics views:@{@"view": view}]];
            }
            else {
                [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]" options:0 metrics:nil views:@{@"view": view}]];
            }
        }
        else {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[prevView][view]" options:0 metrics:nil views:@{@"prevView": prevView, @"view": view}]];
        }
        prevView = view;
    }
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[prevView]|" options:0 metrics:nil views:@{@"prevView": prevView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[prevView]|" options:0 metrics:nil views:@{@"prevView": prevView}]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end