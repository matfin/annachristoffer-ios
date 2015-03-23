//
//  FigCaptionView.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 18/12/2014.
//  Copyright (c) 2014 Anna Christoffer. All rights reserved.
//

#import "FigCaptionView.h"
#import "UIView+Autolayout.h"
#import "NSString+Encoded.h"

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

-(void)imageDataFetched:(NSData *)imageData {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.figCaptionImageView setImage:[UIImage imageWithData:imageData]];
    });
}

-(void)imageDataFetchFailedWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.figCaptionImageView setImage:[UIImage imageWithContentsOfFile:@"placeholder"]];
    });
}

-(NSString *)paragraphs {
    NSString *textContent = nil;
    NSString *intro, *captionString = nil;
    NSDictionary *captions = nil;
    
    if((intro = self.figCaptionData[@"intro"][@"description"][@"de"]) != nil) {
        textContent = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@\n", intro]];
    }
    
    if((captions = self.figCaptionData[@"captions"]) != nil) {
        for(NSDictionary *captionContent in captions) {
            if((captionString = captionContent[@"content"][@"de"]) != nil) {
                if(textContent == nil) {
                    textContent = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@\n", captionString]];
                }
                else {
                    //[textContent appendString:[NSString stringWithFormat:@"%@", captionString]];
                    textContent = [textContent stringByAppendingString:[NSString stringWithFormat:@"%@\n", captionString]];
                }
            }
        }
    }
    
    if(textContent != nil) {
        textContent = [textContent asDecodedHTML];
    }
    
    return textContent;
}

//-(Image *)figCaptionImage {
//    
//    NSString *imageUrlString = nil;
//    Image *figCaptionImage = nil;
//    
//    if((imageUrlString = self.figCaptionData[@"img"]) != nil) {
//        
//        NSString *imageUrl = [NSString stringWithFormat:@"%@%@%@", @"images/projects/", imageUrlString, @"@2x.jpg"];
//        figCaptionImage = [[Image alloc] initWithURLString:imageUrl];
//    }
//    
//    return figCaptionImage;
//}

-(void)addContentViews {
    [super layoutSubviews];
    
    /**
     *  Set up and add the subviews to display the content
     */
    self.figCaptionImageView = [UIImageView autoLayoutView];
    [self.figCaptionImageView setBackgroundColor:[UIColor lightGrayColor]];
    [self addSubview:figCaptionImageView];
    
    /**
     *  If we have text for this fig caption
     */
    self.figCaptionTextView = [UITextView autoLayoutView];
    NSString *figCaptionText;
    if((figCaptionText = [self paragraphs]) != nil) {
        self.figCaptionHasText = YES;
        [self.figCaptionTextView setScrollEnabled:NO];
        [self.figCaptionTextView setText:[self paragraphs]];
        [self addSubview:figCaptionTextView];
    }
    
    /**
     *  If we have a standard image for this view
     */
//    Image *figCaptionImage;
//    if((figCaptionImage = [self figCaptionImage]) != nil) {
//        [figCaptionImage setDelegate:self];
//        [figCaptionImage fetchImageData];
//    }
    
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
    
    /**
     *  Different VFL strings depending on whether we have text to accompany a caption or not.
     *  Without this, constraints will fail if we specify a constraint for a view that has not
     *  been added to the superview.
     */
    NSString *constraintVFL = self.figCaptionHasText ? @"V:|[figCaptionImageView][figCaptionTextView]|" : @"V:|[figCaptionImageView]|";
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
