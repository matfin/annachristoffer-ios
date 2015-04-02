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
#import "LanguageController.h"

@interface CaptionSliderView ()
@property (nonatomic, strong) Caption *caption;
@property (nonatomic, strong) Slider *slider;
@property (nonatomic, strong) NSMutableDictionary *contentParagraphs;
@property (nonatomic, strong) NSArray *slideImages;
@property (nonatomic, strong) SliderViewController *sliderViewController;
@property (nonatomic, strong) ImageController *imageController;
@property (nonatomic, assign) ACLanguageCode languageCode;
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
         *  To store the text views so we can update them on language switch
         */
        self.contentParagraphs = [NSMutableDictionary new];
        
        /**
         *  Observer to refresh content on language change
         */
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageDidChange:) name:@"languageDidChange" object:nil];
        
        /**
         *  The current language code
         */
        self.languageCode = [[LanguageController sharedInstance] currentLanguageCode];
        
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
        
        [self refreshCaptionTextContent];
        [self setupConstraints];
    }
    return self;
}

#pragma mark - Handling language changes

- (void)languageDidChange:(NSNotification *)notification {
    self.languageCode = (ACLanguageCode)[[notification valueForKey:@"object"] integerValue];
    [self refreshCaptionTextContent];
}

- (void)refreshCaptionTextContent {
    
    NSArray *messageCodes = [NSArray messagesFromOrderedSet:self.caption.messageCodes withLanguageCode:self.languageCode];
    NSUInteger index = 0;
    for(MessageCode *messageCode in messageCodes) {
        
        if([self.contentParagraphs objectForKey:[NSNumber numberWithInteger:index]] == nil) {
            UITextView *textView = [UITextView initAsCaptionTextView];
            [textView setText:[messageCode.messageContent asDecodedFromEntities]];
            [self.contentParagraphs setObject:textView forKey:[NSNumber numberWithInteger:index]];
            [self addSubview:textView];
        }
        else {
            UITextView *textView = [self.contentParagraphs objectForKey:[NSNumber numberWithInteger:index]];
            [textView setText:[messageCode.messageContent asDecodedFromEntities]];
            [self setNeedsUpdateConstraints];
            [self layoutIfNeeded];
        }
        index++;
    }
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
