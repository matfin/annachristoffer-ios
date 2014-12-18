//
//  ProjectTableViewCell.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 16/12/2014.
//  Copyright (c) 2014 Anna Christoffer. All rights reserved.
//

#import "ProjectTableViewCell.h"

@interface ProjectTableViewCell()

@end

@implementation ProjectTableViewCell

@synthesize projectData;
@synthesize titleLabel;
@synthesize thumbnailPreview;
@synthesize loadingSpinner;

-(id)initWithProject:(Project *)project andReuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.projectData = project;
        self.projectData.thumbnailImage.delegate = self;
        [self.projectData.thumbnailImage fetchImageData];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    self.titleLabel = [[TitleLabel alloc] initWithFrame:CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, 30.0f)];
    self.thumbnailPreview = [[UIImageView alloc] initWithFrame:CGRectMake(bounds.origin.x, bounds.origin.y + titleLabel.bounds.size.height, bounds.size.width, 150.0f)];
    
    self.loadingSpinner = [[UIActivityIndicatorView alloc] initWithFrame:[self.thumbnailPreview frame]];
    
    [self.loadingSpinner setColor:[UIColor colorWithRed:(255.0f / 255.0f) green:(51.0f / 255.0f) blue:(153.0f / 255.0f) alpha:1.0f]];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.thumbnailPreview];
    [self.contentView addSubview:self.loadingSpinner];
    [self.loadingSpinner startAnimating];
    [self.titleLabel setText:self.projectData.title];
    
}

-(void)imageDataFetched:(NSData *)imageData {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.loadingSpinner stopAnimating];
        [self.loadingSpinner removeFromSuperview];
        [self.thumbnailPreview setImage:[UIImage imageWithData:imageData]];
    });
}

-(void)imageDataFetchFailedWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.thumbnailPreview setImage:[UIImage imageWithContentsOfFile:@"placeholder"]];
    });
}

-(void)prepareForReuse {
    [super prepareForReuse];
    for(UIView *subview in [self.contentView subviews]) {
        [subview removeFromSuperview];
    }
}

-(void)viewDidLoad {
    //TODO: Set up view related stuff in here when loaded
}

-(void)viewWillAppear {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
