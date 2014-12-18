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
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, 30.0f)];
    self.thumbnailPreview = [[UIImageView alloc] initWithFrame:CGRectMake(bounds.origin.x, bounds.origin.y + titleLabel.bounds.size.height, bounds.size.width, 150.0f)];

    [self fetchImage];
    
    self.loadingSpinner = [[UIActivityIndicatorView alloc] initWithFrame:[self.thumbnailPreview frame]];
    
    [self.loadingSpinner setColor:[UIColor colorWithRed:(255.0f / 255.0f) green:(51.0f / 255.0f) blue:(153.0f / 255.0f) alpha:1.0f]];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.thumbnailPreview];
    [self.contentView addSubview:self.loadingSpinner];
    [self.loadingSpinner startAnimating];
    [self.titleLabel setText:self.projectData.title];
}

-(void)placeImageFromData:(NSData *)imageData {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *image = [UIImage imageWithData:imageData];
        
        [self.thumbnailPreview setImage:image];
        [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
        
        [self.loadingSpinner stopAnimating];
        [self.loadingSpinner removeFromSuperview];
    });
    
}

-(void)prepareForReuse {
    [super prepareForReuse];
    for(UIView *subview in [self.contentView subviews]) {
        [subview removeFromSuperview];
    }
}

-(void)fetchImage {
    NSString *urlAsString = @"http://media.annachristoffer.com/images/projects/thumbnails/carnival.jpg";
    
    NSURL *imageURL = [NSURL URLWithString:urlAsString];
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
    
    [NSURLConnection
     sendAsynchronousRequest:request
     queue:[[NSOperationQueue alloc] init]
     completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         if(connectionError) {
             NSLog(@"Could not fetch image due to a connection error: %@", connectionError.localizedDescription);
         }
         else {
             [self placeImageFromData:data];
         }
     }];
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
