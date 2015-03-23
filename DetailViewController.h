//
//  DetailViewController.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 16/12/2014.
//  Copyright (c) 2014 Anna Christoffer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractViewController.h"
#import "Project.h"

@interface DetailViewController : AbstractViewController
@property (nonatomic, strong) Project *projectData;
- (id)initWithProject:(Project *)projectData;
@end
