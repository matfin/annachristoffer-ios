//
//  ProjectTableViewCell.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 08/01/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACLabel.h"

@interface ProjectTableViewCell : UITableViewCell
@property (nonatomic, strong) ACLabel *projectTitleLabel;
@property (nonatomic, strong) UIImageView *projectThumbnailView;
- (void)setPlaceHolderImageAnimated;
- (void)removePlaceholderImage;
@end
