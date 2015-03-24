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
#import "ProjectController.h"
#import "NSString+MessageCode.h"

@interface ListViewController() <NSFetchedResultsControllerDelegate, ProjectControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DetailViewController *detailViewController;
@property (nonatomic, strong) ProjectController *projectController;

@end

@implementation ListViewController

static NSString *tableViewCellIdentifier = @"projectCell";
static NSString *languageCode = @"en";

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
    
    /**
     *  Setting up the constraints for the tableview
     */
    [self setupConstraints];
    
    /**
     *  Setting up the project controller and start fetching results
     */
    self.projectController = [ProjectController sharedInstance];
    [self.projectController setDelegate:self];
    /**
     *  Fetch and store project data if needed
     */
    [self.projectController fetchProjectData];
}

- (void)setupConstraints {
    
    [super setupConstraints];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:@{@"tableView": self.tableView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|" options:0 metrics:nil views:@{@"tableView": self.tableView}]];
}

#pragma mark - The Fetched Results controller

- (void)projectDataFetchedAndStored {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.projectController startFetchedResultsControllerWithDelegate:self];
        [self.tableView reloadData];
    });
    
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch(type) {
        case NSFetchedResultsChangeInsert: {
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            //TODO: Configure cell on an update.
            break;
        }
        case NSFetchedResultsChangeMove: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}

#pragma mark - TableView and cell view set up

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[[self.projectController fetchedResultsController] sections] count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sections = [self.projectController.fetchedResultsController sections];
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /**
     *  Grab the cell and then the project data.
     */
    ProjectTableViewCell *cell = (ProjectTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier forIndexPath:indexPath];
    Project *project = [self.projectController.fetchedResultsController objectAtIndexPath:indexPath];
    
    /**
     *  Set the cell up
     */
    [self configureCell:cell withProject:project];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProjectTableViewCell *cell = (ProjectTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier];
    Project *project = [self.projectController.fetchedResultsController objectAtIndexPath:indexPath];
    
    [self configureCell:cell withProject:project];
        
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    [cell.contentView setNeedsLayout];
    [cell.contentView layoutIfNeeded];
    
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    return height;
}

- (void)configureCell:(ProjectTableViewCell *)cell withProject:(Project *)project {

    /**
     *  Fetch the data from the project
     */
    NSSet *messageCodes = project.messageCodes;
    
    NSString *title = [NSString messageFromSet:messageCodes withKey:@"title" withLanguageCode:languageCode];
    
    /**
     *  Populate the cell with data
     */
    [cell.projectTitleLabel setText:title];
    //[cell loadProjectThumbnailWithImage:nil];
    
    
    [cell setNeedsUpdateConstraints];
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 500.0f;
}

#pragma mark - Cleanup

- (void)dealloc {
    /**
     *  Cleanup
     */
    [self.projectController cleanupFetchedResultsController];
}

@end
