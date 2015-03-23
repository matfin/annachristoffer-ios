//
//  ProjectTableViewCell.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 08/01/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "Image.h"
//#import "Project.h"
#import "UILabel+ACLabel.h"
#import "TitleLabel.h"

@interface ProjectTableViewCell : UITableViewCell

@property(nonatomic, strong) TitleLabel *projectTitleLabel;
//-(void)loadProjectThumbnailWithImage:(Image *)thumbnailImage;
@end
