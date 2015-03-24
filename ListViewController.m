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
#import "ImageController.h"
#import "NSString+MessageCode.h"
#import "NSString+Encoded.h"

@interface ListViewController() <NSFetchedResultsControllerDelegate, ProjectControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DetailViewController *detailViewController;
@property (nonatomic, strong) ProjectController *projectController;
@property (nonatomic, strong) NSMutableDictionary *imageControllers;

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
     *  Set up the image controllers responsible for populating the project
     *  thumbnail images
     */
    self.imageControllers = [NSMutableDictionary dictionary];
    
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
    
    /**
     *  Set the cell up
     */
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProjectTableViewCell *cell = (ProjectTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier];
    
    [self configureCell:cell atIndexPath:indexPath];
        
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    [cell.contentView setNeedsLayout];
    [cell.contentView layoutIfNeeded];
    
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    return height;
}

- (void)configureCell:(ProjectTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    /**
     *  Grab the project
     */
    Project *project = [self.projectController.fetchedResultsController objectAtIndexPath:indexPath];
    
    /**
     *  Fetch the data from the project
     */
    NSSet *messageCodes = project.messageCodes;
    NSString *title = [NSString messageFromSet:messageCodes withKey:@"title" withLanguageCode:languageCode];
    
    Image *projectImage = (Image *)project.thumbnail;
    if(projectImage.data == nil) {
        [self startDownloadForImage:projectImage atIndexPath:indexPath];
    }
    else {
        [cell.projectThumbnailView setImage:[UIImage imageWithData:projectImage.data]];
    }
    
    /**
     *  Populate the cell with data
     */
    [cell.projectTitleLabel setText:[title asDecodedFromEntities]];
    
    
    [cell setNeedsUpdateConstraints];
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 500.0f;
}

#pragma mark - Image downloads

- (void)startDownloadForImage:(Image *)image atIndexPath:(NSIndexPath *)indexPath {
    /**
     *  Set up the image controller.
     */
    ImageController *imageController = (self.imageControllers)[indexPath];
    if(imageController == nil) {
        /**
         *  No image controller for the image associated with the project at the indexpath,
         *  so we need to create one and then start the download.
         */
        imageController = [[ImageController alloc] init];
        imageController.imageObject = image;
        [imageController setCompletionHandler:^{
            /**
             *  Set the image to the table view cell once loaded
             */
            ProjectTableViewCell *cell = (ProjectTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                 [cell.projectThumbnailView setImage:[UIImage imageWithData:image.data]];
            });
        }];
        (self.imageControllers)[indexPath] = imageController;
        /**
         *  Kick off the download.
         */
        [imageController startImageDownload];
    }
}

- (void)stopAllImageDownloads {
    NSArray *allImageControllers = [self.imageControllers allValues];
    [allImageControllers makeObjectsPerformSelector:@selector(stopImageDownload)];
    [self.imageControllers removeAllObjects];
}

#pragma mark - Cleanup

- (void)dealloc {
    /**
     *  Cleanup
     */
    [self stopAllImageDownloads];
    [self.projectController cleanupFetchedResultsController];
}

@end
