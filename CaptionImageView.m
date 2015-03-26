//
//  CaptionImageView.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 25/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "CaptionImageView.h"

@interface CaptionImageView ()
@property (nonatomic, strong) UIImageView *captionImageView;
@property (nonatomic, strong) NSArray *contentParagraphs;
@end

@implementation CaptionImageView

@synthesize caption;
@synthesize contentParagraphs;

- (id)initWithCaption:(Caption *)captionItem {
    if(self = [super init]) {
        self.caption = captionItem;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.captionImageView = [UIImageView autoLayoutView];
        [self addSubview:self.captionImageView];

        self.contentParagraphs = [NSArray messagesFromOrderedSet:self.caption.messageCodes withLanguageCode:@"en"];
        
        for(MessageCode *messageCode in self.contentParagraphs) {
            UITextView *contentTextView = [UITextView autoLayoutView];
            [contentTextView setEditable:NO];
            [contentTextView setScrollEnabled:NO];
            [contentTextView setText:messageCode.messageContent];
            [self addSubview:contentTextView];
        }
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints {
    
    /**
     *  Use this as a reference
     */
    UIView *prevView = nil;
    
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
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]" options:0 metrics:nil views:@{@"view": view}]];
        }
        else {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[prevView]-[view]" options:0 metrics:nil views:@{@"prevView": prevView, @"view": view}]];
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

@end
