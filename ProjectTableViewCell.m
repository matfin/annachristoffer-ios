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

@synthesize titleLabel;
@synthesize thumbnailView;
@synthesize project;

-(ProjectTableViewCell *)initWithProject:(id)theProject andIdentifier:(NSString *)identifier {
    if(self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]) {
        self.project = theProject;
    }
    return self;
}

-(void)layoutSubviews {
    
    CGRect bounds = self.bounds;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, 30.0f)];
    
    self.thumbnailView = [[UIImageView alloc] initWithFrame:CGRectMake(bounds.origin.x, bounds.origin.y + self.titleLabel.bounds.size.height, bounds.size.width, 150.0f)];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.thumbnailView];
    
    [self.titleLabel setText:self.project.title];
    
    [self.thumbnailView setBackgroundColor:[UIColor redColor]];
    [self.titleLabel setBackgroundColor:[UIColor blueColor]];
    [self setBackgroundColor:[UIColor greenColor]];
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
