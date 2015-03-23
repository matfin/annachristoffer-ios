//
//  ListTableViewController.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 08/01/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "ListViewController.h"
#import "DetailViewController.h"
#import "ProjectTableViewCell.h"

/**
 *  The table view cell identifier
 */
static NSString *tableViewCellIdentifier = @"projectTableViewCell";

@interface ListViewController() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DetailViewController *detailViewController;

@end

@implementation ListViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [UITableView autoLayoutView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.tableView];
    
    /**
     *  Registering table view cell class
     */
    [self.tableView registerClass:[ProjectTableViewCell class] forCellReuseIdentifier:tableViewCellIdentifier];
    
   
    
    [self setupConstraints];
}

- (void)setupConstraints {
    
    [super setupConstraints];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:@{@"tableView": self.tableView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|" options:0 metrics:nil views:@{@"tableView": self.tableView}]];
}

#pragma mark - TableView and cell view set up

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /**
     *  Grab the cell and then the project data.
     */
    ProjectTableViewCell *cell = (ProjectTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier forIndexPath:indexPath];
    //Project *project = [self.projects objectAtIndex:indexPath.row];
    
    /**
     *  Set the cell up
     */
    //[self configureCell:cell withProject:project];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProjectTableViewCell *cell = (ProjectTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier];
    //Project *project = [self.projects objectAtIndex:indexPath.row];
    
    //[self configureCell:cell withProject:project];
        
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    [cell.contentView setNeedsLayout];
    [cell.contentView layoutIfNeeded];
    
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    return height;
}

//- (void)configureCell:(ProjectTableViewCell *)cell withProject:(Project *)project {
//    
//    /**
//     *  Populate the cell with data
//     */
//    [cell.projectTitleLabel setText:project.title];
//    [cell loadProjectThumbnailWithImage:project.thumbnailImage];
//    [cell setNeedsUpdateConstraints];
//}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 500.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        
//    Project *project = [self.projects objectAtIndex:indexPath.row];
//    self.detailViewController = [[DetailViewController alloc] initWithProject:project];
//    [self.navigationController pushViewController:self.detailViewController animated:YES];
}

#pragma mark - Cleanup

- (void)dealloc {
    /**
     *  Cleanup
     */
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
}

@end
