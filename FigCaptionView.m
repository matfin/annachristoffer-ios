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
@property (nonatomic, strong) NSDictionary  *figCaptionData;
@property (nonatomic)         BOOL          figCaptionHasText;
@end

@implementation FigCaptionView

@synthesize figCaptionImageView;
@synthesize figCaptionTextView;
@synthesize figCaptionData;
@synthesize figCaptionHasText;

-(id)initWithData:(NSDictionary *)viewData {
    if((self = [FigCaptionView autoLayoutView])) {
        self.figCaptionData = viewData;
        self.figCaptionHasText = NO;
    }
    
    return self;
}

-(void)loadImage:(NSString *)imageURLPath {
    
}

-(NSString *)paragraphs {
    NSMutableString *textContent = nil;
    NSString *intro, *captionString = nil;
    NSDictionary *captions = nil;
    
    if((intro = self.figCaptionData[@"intro"][@"description"][@"en"]) != nil) {
        textContent = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@\n", intro]];
    }
    
    if((captions = self.figCaptionData[@"captions"]) != nil) {
        for(NSDictionary *captionContent in captions) {
            if((captionString = captionContent[@"content"][@"en"]) != nil) {
                if(textContent == nil) {
                    textContent = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@", captionString]];
                }
                else {
                    [textContent appendString:[NSString stringWithFormat:@"%@", captionString]];
                }
            }
        }
    }
    else {
        NSLog(@"Captions nil!");
    }

    return textContent;
    
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
    
    /**
     *  If we have text for this fig caption
     */
    NSString *figCaptionText = [self paragraphs];
    if((figCaptionText = [self paragraphs]) != nil) {
        self.figCaptionHasText = YES;
        [self.figCaptionTextView setText:[self paragraphs]];
        [self addSubview:figCaptionTextView];
    }
    
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
    
    NSString *constraintVFL = self.figCaptionHasText ? @"V:|[figCaptionImageView][figCaptionTextView]|" : @"V:|[figCaptionImageView]-(margin)-|";
    [self addConstraints:[NSLayoutConstraint    constraintsWithVisualFormat:constraintVFL
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
     *  Constraints for the caption text view - horizontal
     */
    if(self.figCaptionHasText) {
        [self addConstraints:[NSLayoutConstraint    constraintsWithVisualFormat:@"H:|[figCaptionTextView]|"
                                                    options:0
                                                    metrics:metrics
                                                    views:views
        ]];
    }
}

@end
