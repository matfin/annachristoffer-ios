//
//  ProjectTableViewCell.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 08/01/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "ProjectTableViewCell.h"
#import "UIView+Autolayout.h"

@interface ProjectTableViewCell()
@property (nonatomic, assign) BOOL didSetupConstraints;
@end

@implementation ProjectTableViewCell

@synthesize projectTitleLabel;
@synthesize projectThumbnailView;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        /**
         *  Setting up the title label
         */
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.projectTitleLabel = [UILabel autoLayoutView];
        [self.projectTitleLabel setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:projectTitleLabel];
        
        /**
         *  Setting up the thumbnail image view
         */
        self.projectThumbnailView = [UIImageView autoLayoutView];
        [self.projectThumbnailView setContentMode:UIViewContentModeScaleAspectFill];
        [self.contentView addSubview:projectThumbnailView];
    }

    return self;
}

-(void)prepareForReuse {
    [self setNeedsUpdateConstraints];
}

-(void)updateConstraints {
    [super updateConstraints];
    
    if(self.didSetupConstraints)  return;
    
    NSDictionary *views = @{@"projectTitleLabel": self.projectTitleLabel, @"projectThumbnailView": self.projectThumbnailView};
    NSString *format;
    NSArray *constraints;
    
    /**
     *  Creating and assigning the constraints
     */
    
    format = @"H:|[projectTitleLabel]|";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views];
    [self.contentView addConstraints:constraints];
    
    format = @"H:|[projectThumbnailView]|";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views];
    [self.contentView addConstraints:constraints];
    
    format = @"V:|-[projectTitleLabel]-[projectThumbnailView]-|";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views];
    [self.contentView addConstraints:constraints];
    
    
    /**
     *  Item based constraint to ensure the thumbnail image height is always half the width
     */
    
    NSLayoutConstraint *imageHeightConstraint = [NSLayoutConstraint     constraintWithItem:self.projectThumbnailView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.projectThumbnailView
                                                                        attribute:NSLayoutAttributeWidth
                                                                        multiplier: 0.5f
                                                                        constant:0
    ];
    
    imageHeightConstraint.priority = 500;
    
    
    [self.projectThumbnailView addConstraint:imageHeightConstraint];
    
    /**
     *  Make sure the width of the content view is the same width as the cell view - 100%
     */

    
    self.didSetupConstraints = YES;
}

@end
