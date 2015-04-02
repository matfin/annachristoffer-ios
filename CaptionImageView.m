//
//  CaptionImageView.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 25/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "CaptionImageView.h"
#import "ImageController.h"
#import "UITextView+ACTextView.h"
#import "UIView+Animate.h"
#import "LanguageController.h"
#import "NSString+Encoded.h"

@interface CaptionImageView ()
@property (nonatomic, strong) Caption *caption;
@property (nonatomic, strong) UIImageView *captionImageView;
@property (nonatomic, strong) UIImageView *placeholderImageView;
@property (nonatomic, strong) UIView *imageContainerView;
@property (nonatomic, strong) NSMutableDictionary *contentParagraphs;
@property (nonatomic, strong) ImageController *imageController;
@property (nonatomic, strong) Locale *locale;
@end

@implementation CaptionImageView

@synthesize caption;
@synthesize contentParagraphs;
@synthesize imageController;
@synthesize captionImageView;

#pragma mark - View setup

- (id)initWithCaption:(Caption *)captionItem {
    if(self = [super init]) {
        /**
         *  Setting up the view with the caption
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
        self.locale = [[LanguageController sharedInstance] getCurrentLocale];
        
        /**
         *  Setting up the sub views
         */
        self.captionImageView = [UIImageView autoLayoutView];
        [self.captionImageView setBackgroundColor:[UIColor whiteColor]];
        [self.captionImageView setContentMode:UIViewContentModeScaleAspectFit];
        
        self.imageContainerView = [UIView autoLayoutView];
        [self.imageContainerView setBackgroundColor:[UIColor getColor:colorLightPink]];
        [self.imageContainerView addSubview:self.captionImageView];
        
        if(self.caption.image.data == nil) {
            self.placeholderImageView = [UIImageView rotatingViewWithDuration:100.0f andRotations:0.5f andRepeatCount:10];
            [self.placeholderImageView setImage:[UIImage imageNamed:@"LaunchScreenImage"]];
            [self.imageContainerView addSubview:self.placeholderImageView];
            [self.imageContainerView bringSubviewToFront:self.placeholderImageView];
            [self startCaptionImageDownload];
        }
        else {
            self.placeholderImageView = nil;
            [self.captionImageView setImage:[UIImage imageWithData:caption.image.data]];
        }
        
        [self addSubview:self.imageContainerView];
        [self refreshCaptionTextContent];
        [self setupConstraints];
    }
    return self;
}

#pragma mark - Handling language changes

- (void)languageDidChange:(NSNotification *)notification {
    self.locale = (Locale *)[notification object];
    [self refreshCaptionTextContent];
}

- (void)refreshCaptionTextContent {
    
    NSArray *messageCodes = [NSArray messagesFromOrderedSet:self.caption.messageCodes withLanguageCode:self.locale.languageCode];
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

#pragma mark - Layout

- (void)setupConstraints {
    
    /**
     *  Use this as a reference
     */
    UIView *prevView = nil;
    NSDictionary *metrics = @{@"imageViewHeight": @(240.0f)};
    
    /**
     *  Set constraints for each sub view, loopiong through
     */
    for(UIView *view in self.subviews) {
        /**
         *  Horizontal constraints
         */
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": view}]];
        
        /**
         *  If this is the first view, we should pin it to the top of the superview vertically
         *  or else we pin the view to the preceding view marked by prevView vertically
         */
        if(prevView == nil) {
            if([view isKindOfClass:[UIView class]]) {
                /**
                 *  Constraints for the image view container height
                 */
                [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view(==imageViewHeight)]" options:0 metrics:metrics views:@{@"view": view}]];
                
                /**
                 *  Constraints for the caption image view
                 */
                [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[captionImageView]|" options:0 metrics:nil views:@{@"captionImageView": self.captionImageView}]];
                [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[captionImageView]|" options:0 metrics:nil views:@{@"captionImageView": self.captionImageView}]];
                
                /**
                 *  Consteraints for the placeholder image view if it exists
                 */
                if(self.placeholderImageView != nil) {
                    [view addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderImageView
                                                                     attribute:NSLayoutAttributeCenterX
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:view
                                                                     attribute:NSLayoutAttributeCenterX
                                                                    multiplier:1.0f
                                                                      constant:0
                    ]];
                    [view addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderImageView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:view
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1.0f
                                                                      constant:0
                    ]];
                    [view addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderImageView
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0f
                                                                      constant:120.0f
                    ]];
                    [view addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderImageView
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0f
                                                                      constant:120.0f
                    ]];
                }
                
                
            }
            else {
                /**
                 *  Constraints for the text views
                 */
                [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]" options:0 metrics:nil views:@{@"view": view}]];
            }
        }
        else {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[prevView][view]" options:0 metrics:nil views:@{@"prevView": prevView, @"view": view}]];
        }
        
        /**
         *  This will set up this view as the last, which we can pin to the bottom of the superview.
         */
        prevView = view;
    }
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[prevView]|" options:0 metrics:nil views:@{@"prevView":prevView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[prevView]|" options:0 metrics:nil views:@{@"prevView":prevView}]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - Loading the image

- (void)startCaptionImageDownload {
    self.imageController = [ImageController new];
    self.imageController.imageObject = self.caption.image;
    
    /**
     *  Setting up weak pointer to self to avoid retain cycles
     */
    __weak CaptionImageView *weakSelf = self;
    [self.imageController setCompletionHandler:^{
        /**
         *  Grab the caption image. The image controller persists its data when the image has loaded
         */
        UIImage *captionImage = [[UIImage alloc] initWithData:weakSelf.caption.image.data];
        [weakSelf.captionImageView setImage:captionImage];
        /**
         *  We no longer need the image controller once the image has loaded.
         */
        weakSelf.imageController = nil;
        /**
         *  Remove the placeholder view
         */
        [weakSelf.placeholderImageView.layer removeAllAnimations];
        [weakSelf.placeholderImageView removeFromSuperview];
        weakSelf.placeholderImageView = nil;
    }];
    
    /**
     *  Kick off the image download
     */
    [self.imageController startImageDownload];
}

#pragma mark - cleanup

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.imageController stopImageDownload];
}

@end
