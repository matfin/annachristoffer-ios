//
//  ProjectTableViewCell.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 16/12/2014.
//  Copyright (c) 2014 Anna Christoffer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"

@interface ProjectTableViewCell : UITableViewCell
@property (nonatomic, strong) Project *projectData;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *thumbnailPreview;
@property (nonatomic, strong) UIActivityIndicatorView *loadingSpinner;
-(id)initWithProject:(Project *)project andReuseIdentifier:(NSString *)reuseIdentifier;
@end
