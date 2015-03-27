//
//  ProjectTableViewCell.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 08/01/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "ProjectTableViewCell.h"
#import "UIView+Autolayout.h"
#import "UIView+Animate.h"
#import "UIColor+ACColor.h"

@interface ProjectTableViewCell()
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, assign) BOOL didAddPlaceholderImage;
@property (nonatomic, strong) UIView *projectThumbnailContainerView;
@property (nonatomic, strong) UIImageView *placeholderImageView;
@end

@implementation ProjectTableViewCell

@synthesize projectTitleLabel;
@synthesize projectThumbnailView;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        /**
         *  Setting up the title label
         */
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.projectTitleLabel = [TitleLabel autoLayoutView];
        [self.projectTitleLabel setFont:[UIFont fontWithName:@"OpenSansLight-Italic" size:22.0f]];
        [self.projectTitleLabel setTextAlignment:NSTextAlignmentLeft];
        [self.projectTitleLabel setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:projectTitleLabel];
        
        /**
         *  Setting up the thumbnail image view
         */
        self.projectThumbnailContainerView = [UIView autoLayoutView];
        [self.projectThumbnailContainerView setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.projectThumbnailContainerView];
        self.projectThumbnailView = [UIImageView autoLayoutView];
        [self.projectThumbnailView setContentMode:UIViewContentModeScaleAspectFill];
        [self.projectThumbnailContainerView addSubview:projectThumbnailView];
    }

    return self;
}

-(void)prepareForReuse {
    self.placeholderImageView.image = nil;
    self.projectThumbnailView.image = nil;
    self.projectTitleLabel.text = nil;
    [self setNeedsUpdateConstraints];
}

-(BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - constraint setup

-(void)updateConstraints {
    [super updateConstraints];
    
    /**
     *  Exit if constraints have already been applied
     */
    if(self.didSetupConstraints)  return;
    
    NSDictionary *views = @{@"projectTitleLabel": self.projectTitleLabel, @"projectThumbnailContainerView": self.projectThumbnailContainerView, @"projectThumbnailView": self.projectThumbnailView};
    NSDictionary *metrics = @{
        @"margin": @(8.0f),
        @"titleLabelHeight": @(48.0f),
        @"tableCellMargin": (@30.0f)
    };
    NSString *format;
    NSArray *constraints;
    
    /**
     *  Creating and assigning the constraints
     */
    
    format = @"H:|[projectTitleLabel]|";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:metrics views:views];
    [self.contentView addConstraints:constraints];
    
    format = @"H:|[projectThumbnailContainerView]|";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views];
    [self.contentView addConstraints:constraints];
    
    format = @"V:|[projectTitleLabel(titleLabelHeight@750)][projectThumbnailContainerView]-(tableCellMargin)-|";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:metrics views:views];
    [self.contentView addConstraints:constraints];
    
    format = @"H:|[projectThumbnailView]|";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:metrics views:views];
    [self.projectThumbnailContainerView addConstraints:constraints];
    
    format = @"V:|[projectThumbnailView(160@750)]-(margin)-|";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:metrics views:views];
    [self.projectThumbnailContainerView addConstraints:constraints];
    
    /**
     *  Make sure the width of the content view is the same width as the cell view - 100%
     */
    self.didSetupConstraints = YES;
}

#pragma mark - Placeholder image view

- (void)setPlaceHolderImageAnimated {
    
    if(self.didAddPlaceholderImage) return;
    
    /**
     *  Adding the placeholder image view
     */
    self.placeholderImageView = [UIImageView rotatingViewWithDuration:100.0f andRotations:0.5f andRepeatCount:10];
    [self.placeholderImageView setImage:[UIImage imageNamed:@"LaunchScreenImage"]];
    [self.contentView addSubview:self.placeholderImageView];
    [self.contentView bringSubviewToFront:self.placeholderImageView];
    
    /**
     *  Then setting up its constarints
     */
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderImageView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1.0f
                                                                  constant:0.0f
    ]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderImageView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0f
                                                                  constant:0.0f
    ]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderImageView
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0f
                                                                  constant:120.0f
    ]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderImageView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0f
                                                                  constant:120.0f
    ]];
    
    /**
     *  Animating
     */
    
    
    self.didAddPlaceholderImage = YES;
}

- (void)removePlaceholderImage {
    
    [self.placeholderImageView removeFromSuperview];
}

@end
