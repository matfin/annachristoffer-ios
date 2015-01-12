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

@interface ProjectTableViewCell() <ImageFetcherDelegate>
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, assign) BOOL didLoadPreviewImage;
@property (nonatomic, strong) Project *project;
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
        [self.projectThumbnailView setBackgroundColor:[UIColor redColor]];
        [self.contentView addSubview:projectThumbnailView];
    }

    return self;
}

-(void)loadProjectThumbnailWithImage:(Image *)thumbnailImage {
    thumbnailImage.delegate = self;
    [thumbnailImage fetchImageData];
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
    
    format = @"V:|-[projectTitleLabel]-[projectThumbnailView(160@500)]|";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views];
    [self.contentView addConstraints:constraints];
    
    /**
     *  Make sure the width of the content view is the same width as the cell view - 100%
     */
    self.didSetupConstraints = YES;
}

@end
