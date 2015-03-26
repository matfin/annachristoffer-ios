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

@interface CaptionImageView ()
@property (nonatomic, strong) Caption *caption;
@property (nonatomic, strong) UIImageView *captionImageView;
@property (nonatomic, strong) NSArray *contentParagraphs;
@property (nonatomic, strong) ImageController *imageController;
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
         *  Setting up the sub views
         */
        self.captionImageView = [UIImageView autoLayoutView];
        [self.captionImageView setBackgroundColor:[UIColor whiteColor]];
        [self.captionImageView setContentMode:UIViewContentModeScaleAspectFit];
        
        if(self.caption.image.data == nil) {
            [self startCaptionImageDownload];
        }
        else {
            [self.captionImageView setImage:[UIImage imageWithData:caption.image.data]];
        }
        
        [self addSubview:self.captionImageView];
        
        
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
            if([view isKindOfClass:[UIImageView class]]) {
                /**
                 *  Constraints for the image view height
                 */
                [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view(imageViewHeight)]" options:0 metrics:metrics views:@{@"view": view}]];
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
    }];
    
    /**
     *  Kick off the image download
     */
    [self.imageController startImageDownload];
}

@end
