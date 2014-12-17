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

-(id)initWithProject:(Project *)project andReuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.projectData = project;
//        CGRect bounds = self.bounds;
//        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, 30.0f)];
//        self.thumbnailPreview = [[UIImageView alloc] initWithFrame:CGRectMake(bounds.origin.x, bounds.origin.y + titleLabel.bounds.size.height, bounds.size.width, 150.0f)];
//        [self.contentView addSubview:self.titleLabel];
//        [self.contentView addSubview:self.thumbnailPreview];
//        [self.titleLabel setText:self.projectData.title];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, 30.0f)];
    self.thumbnailPreview = [[UIImageView alloc] initWithFrame:CGRectMake(bounds.origin.x, bounds.origin.y + titleLabel.bounds.size.height, bounds.size.width, 150.0f)];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.thumbnailPreview];
    [self.titleLabel setText:self.projectData.title];
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
    //TODO: Set up view related stuff here when view will appear
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
