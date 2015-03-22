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
#import "ProjectsManager.h"
#import "Project.h"

/**
 *  The table view cell identifier
 */
static NSString *tableViewCellIdentifier = @"projectTableViewCell";

@interface ListViewController() <UITableViewDataSource, UITableViewDelegate, ProjectsManagerDelegate>

@property (nonatomic, strong) NSArray *projects;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DetailViewController *detailViewController;
@property (nonatomic, strong) ProjectsManager *projectsManager;

@end

@implementation ListViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [UITableView new];
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:@{@"tableView": self.tableView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|" options:0 metrics:nil views:@{@"tableView": self.tableView}]];
    
    /**
     *  Registering table view cell class
     */
    [self.tableView registerClass:[ProjectTableViewCell class] forCellReuseIdentifier:tableViewCellIdentifier];
    
    /**
     *  Set up to fetch project data
     */
    self.projectsManager = [[ProjectsManager alloc] init];
    self.projectsManager.projectFetcher = [[ProjectFetcher alloc] init];
    self.projectsManager.projectFetcher.delegate = self.projectsManager;
    self.projectsManager.delegate = self;
    [self.projectsManager fetchProjects];
}

#pragma mark - Delegated projecr data fetching

-(void)didReceiveProjects:(NSArray *)projects {
    /**
     *  Assign projects fetched
     */
    self.projects = projects;
    
    /**
     *  Then reload table data
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

-(void)projectReceiveFailedWithError:(NSError *)error {
    //TODO: Present a toast error
    NSLog(@"Could not fetch project data: %@", [error localizedDescription]);
}

#pragma mark - TableView and cell view set up

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.projects.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /**
     *  Grab the cell and then the project data.
     */
    ProjectTableViewCell *cell = (ProjectTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier forIndexPath:indexPath];
    Project *project = [self.projects objectAtIndex:indexPath.row];
    
    /**
     *  Set the cell up
     */
    [cell.projectTitleLabel setText:project.title];
    [cell loadProjectThumbnailWithImage:project.thumbnailImage];
    [cell setNeedsUpdateConstraints];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProjectTableViewCell *cell = (ProjectTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier];
    Project *project = [self.projects objectAtIndex:indexPath.row];
    
    [cell.projectTitleLabel setText:project.title];
        
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    [cell.contentView setNeedsLayout];
    [cell.contentView layoutIfNeeded];
    
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 500.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //[tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    Project *project = [self.projects objectAtIndex:indexPath.row];
    self.detailViewController = [[DetailViewController alloc] initWithProject:project];
    [self.navigationController pushViewController:self.detailViewController animated:YES];
}

#pragma mark - Cleanup

- (void)dealloc {
    /**
     *  Cleanup
     */
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
    self.projectsManager.delegate = nil;
    self.projectsManager.projectFetcher.delegate = nil;
}

@end
