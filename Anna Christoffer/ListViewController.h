//
//  ViewController.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 16/12/2014.
//  Copyright (c) 2014 Anna Christoffer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectsManager.h"
#import "ProjectFetcher.h"

@interface ListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ProjectsManagerDelegate>

@property (nonatomic, strong) UITableView *projectTableView;
@property (nonatomic, strong) NSArray *projects;
@property (nonatomic, strong) ProjectsManager *manager;

- (id)initWithFrame:(CGRect)bounds;

@end

