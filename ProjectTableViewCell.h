//
//  ProjectTableViewCell.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 08/01/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <UIKit/UIKit.h>

#define labelHorizontalInsets       15.0f;
#define labelVerticalInsets         10.0f;

@interface ProjectTableViewCell : UITableViewCell

@property(nonatomic, strong) UILabel *projectTitleLabel;
@property(nonatomic, strong) UIImageView *projectThumbnailView;

@end
