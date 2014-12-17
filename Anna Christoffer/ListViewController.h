//
//  ViewController.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 16/12/2014.
//  Copyright (c) 2014 Anna Christoffer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *projectTableView;
@property (nonatomic, strong) NSMutableArray *projects;

- (id)initWithFrame:(CGRect)bounds;
- (id)initWithFrame:(CGRect)bounds withProjects:(NSMutableArray *)theProjects;

@end

