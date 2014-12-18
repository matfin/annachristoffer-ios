//
//  FigCaptionView.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 18/12/2014.
//  Copyright (c) 2014 Anna Christoffer. All rights reserved.
//

#import "FigCaptionView.h"

@interface FigCaptionView(){}
@property (nonatomic, strong) UIImageView *captionImageView;
@property (nonatomic, strong) UITextView *captionTextView;
@property (nonatomic, strong) NSDictionary *contentItem;
-(id)initWithContentItem:(NSDictionary *)contentItem;
-(void)layoutItems;
@end

@implementation FigCaptionView

@synthesize captionImageView;
@synthesize captionTextView;

-(id)initWithContentItem:(NSDictionary *)contentItem {
    if(self = [super init]) {
        self.contentItem = contentItem;
    }
    return self;
}

-(void)layoutItems {
    
    CGRect imageViewBounds, textViewBounds = [self.superview bounds];
    
    imageViewBounds.size.height *= 0.75;
    self.captionImageView = [[UIImageView alloc] initWithFrame:imageViewBounds];
    
    self.captionTextView = [[UITextView alloc] initWithFrame:textViewBounds];
    
}

@end
