//
//  ProjectTableViewCell.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 08/01/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "ProjectTableViewCell.h"
#import "Image.h"
#import "UIView+Autolayout.h"
#import "UIColor+ACColor.h"

@interface ProjectTableViewCell() <ImageFetcherDelegate>
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, assign) BOOL didLoadPreviewImage;
@property (nonatomic, strong) UIImageView *projectThumbnailView;
@property (nonatomic, strong) UIView *projectThumbnailContainerView;
@property (nonatomic, strong) Image *thumbnailImage;
@end

@implementation ProjectTableViewCell

@synthesize projectTitleLabel;
@synthesize projectThumbnailView;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        
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

-(void)loadProjectThumbnailWithImage:(Image *)thumbnailImage {
    self.thumbnailImage = thumbnailImage;
    self.thumbnailImage.delegate = self;
    [self.thumbnailImage fetchImageData];
    self.didLoadPreviewImage = YES;
}

-(void)imageDataFetched:(NSData *)imageData {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.projectThumbnailView setImage:[UIImage imageWithData:imageData]];
    });
}

-(void)imageDataFetchFailedWithError:(NSError *)error {
    //@TODO: Present a message or load a placeholder on image load failure
    NSLog(@"Image could not be loaded.");
}

-(void)prepareForReuse {
    self.projectThumbnailView.image = nil;
    self.didLoadPreviewImage = NO;
    self.thumbnailImage.delegate = nil;
    [self setNeedsUpdateConstraints];
}

-(BOOL)requiresConstraintBasedLayout {
    return YES;
}

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
    
    format = @"V:|[projectThumbnailView(160@500)]-(margin)-|";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:metrics views:views];
    [self.projectThumbnailContainerView addConstraints:constraints];
    
    /**
     *  Make sure the width of the content view is the same width as the cell view - 100%
     */
    self.didSetupConstraints = YES;
}

@end
