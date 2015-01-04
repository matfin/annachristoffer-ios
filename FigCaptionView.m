//
//  FigCaptionView.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 18/12/2014.
//  Copyright (c) 2014 Anna Christoffer. All rights reserved.
//

#import "FigCaptionView.h"
#import "UIView+Autolayout.h"

@interface FigCaptionView(){}
@property (nonatomic, strong) UIImageView   *figCaptionImageView;
@property (nonatomic, strong) UITextView    *figCaptionTextView;
@end

@implementation FigCaptionView

@synthesize figCaptionImageView;
@synthesize figCaptionTextView;

-(id)initWithData:(NSDictionary *)viewData {
    if((self = [FigCaptionView autoLayoutView])) {
        self.figCaptionData = viewData;
    }
    
    return self;
}

-(void)loadImage:(NSString *)imageURLPath {
    
}

-(void)addContentViews {
    [super layoutSubviews];
    
    /**
     *  Set up and add the subviews to display the content
     */
    self.figCaptionImageView = [UIImageView autoLayoutView];
    [self.figCaptionImageView setBackgroundColor:[UIColor lightGrayColor]];
    [self addSubview:figCaptionImageView];
    
    self.figCaptionTextView = [UITextView autoLayoutView];
    [self.figCaptionTextView setScrollEnabled:NO];
    [self.figCaptionTextView setText:@"Some sample text will go in here and this will run ok!! Some sample text will go in here and this will run ok!! Some sample text will go in here and this will run ok!! Some sample text will go in here and this will run ok!! Some sample text will go in here and this will run ok!! Some sample text will go in here and this will run ok!!"];
        
    [self addSubview:figCaptionTextView];
    
    /**
     *  Then apply the constraints
     */
    [self autoLayoutAddConstraints];
}

-(void)autoLayoutAddConstraints {
    
    /**
     *  Any set up values that we need
     */
    CGRect windowBounds = [[UIScreen mainScreen] bounds];
    
    /**
     *  Dictionary of views and metrics
     */
    NSDictionary *views = NSDictionaryOfVariableBindings(self, figCaptionImageView, figCaptionTextView);
    NSDictionary *metrics = @{@"imageWidth": @(windowBounds.size.width), @"margin": @20.0f};
    
    /**
     *  Constraints for this view (Vertical and horizontal)
     */
    [self addConstraints:[NSLayoutConstraint    constraintsWithVisualFormat:@"H:|[figCaptionImageView(imageWidth)]|"
                                                options:0
                                                metrics:metrics
                                                views:views
    ]];
    [self addConstraints:[NSLayoutConstraint    constraintsWithVisualFormat:@"V:|[figCaptionImageView][figCaptionTextView]|"
                                                                    options:0
                                                                    metrics:metrics
                                                                    views:views
    ]];
    
    /**
     *  Constraints for the caption image view to maintain ratio
     */
    [self.figCaptionImageView addConstraint:[NSLayoutConstraint     constraintWithItem:self.figCaptionImageView
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.figCaptionImageView
                                                                    attribute:NSLayoutAttributeWidth
                                                                    multiplier:0.75f
                                                                    constant:0.0f
    ]];
    
    /**
     *  Constraints for the caption text view vertical and horizontal
     */
//    [self.figCaptionTextView addConstraints:[NSLayoutConstraint     constraintsWithVisualFormat:@"H:|[figCaptionTextView]|"
//                                                                    options:0
//                                                                    metrics:metrics
//                                                                    views:views
//    ]];
//    [self.figCaptionTextView addConstraints:[NSLayoutConstraint     constraintsWithVisualFormat:@"V:[figCaptionImageView]-(margin)-[figCaptionTextView]|"
//                                                                    options:0
//                                                                    metrics:metrics
//                                                                    views:views
//    ]];
    
}

@end
