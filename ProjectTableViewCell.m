//
//  ProjectTableViewCell.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 08/01/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "ProjectTableViewCell.h"
#import "UIView+Autolayout.h"
#import "UIColor+ACColor.h"

@interface ProjectTableViewCell()
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, strong) UIView *projectThumbnailContainerView;
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
        [self.projectThumbnailContainerView addSubview:projectThumbnailView];
    }

    return self;
}

-(void)prepareForReuse {
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

@end
