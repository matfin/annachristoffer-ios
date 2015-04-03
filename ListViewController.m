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
#import "UIColor+ACColor.h"
#import "UIView+Animate.h"
#import "ProjectCategory.h"

@interface ListViewController() <NSFetchedResultsControllerDelegate, ProjectControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UIImageView *loadingImageView;
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
    
    self.loadingView = [UIView autoLayoutView];
    [self.loadingView setBackgroundColor:[UIColor getColor:colorLightBeige]];
    self.loadingImageView = [UIImageView rotatingViewWithDuration:100.0f andRotations:0.5f andRepeatCount:10.0f];
    [self.loadingImageView setImage:[UIImage imageNamed:@"LaunchScreenImage"]];
    [self.loadingView addSubview:self.loadingImageView];
    [self.view addSubview:self.loadingView];
    [self.view bringSubviewToFront:self.loadingView];
    
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
    [self.projectController startFetchingProjectData];
    
    /**
     *  Notification for when a category was chosen
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(filterProjectsByCategory:) name:@"categoryWasSelected" object:nil];
}

- (void)setupConstraints {
    
    [super setupConstraints];
    
    /**
     *  The constraints for the tableview
     */
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:@{@"tableView": self.tableView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|" options:0 metrics:nil views:@{@"tableView": self.tableView}]];
    
    /**
     *  Constraints for the loading view and loading image view
     */
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[loadingView]|" options:0 metrics:nil views:@{@"loadingView": self.loadingView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[loadingView]|" options:0 metrics:nil views:@{@"loadingView": self.loadingView}]];
    [self.loadingView addConstraint:[NSLayoutConstraint constraintWithItem:self.loadingImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.loadingView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0]];
    [self.loadingView addConstraint:[NSLayoutConstraint constraintWithItem:self.loadingImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.loadingView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:-32.0f]];
    [self.loadingView addConstraint:[NSLayoutConstraint constraintWithItem:self.loadingImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:64.0f]];
    [self.loadingView addConstraint:[NSLayoutConstraint constraintWithItem:self.loadingImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:64.0f]];
}

#pragma mark - Category filter applied

- (void)filterProjectsByCategory:(NSNotification *)notification {
    //ProjectCategory *category = (ProjectCategory *)[notification object];
}

#pragma mark - The Fetched Results controller

- (void)projectDataFetchedAndStored {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.projectController startFetchedResultsControllerWithDelegate:self];
        [self.tableView reloadData];
        [self.loadingView removeFromSuperview];
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
    
    Image *projectImage = (Image *)project.thumbnail;
    if(projectImage.data == nil) {
        /**
         *  Then when the tableview dragging stops, start loading the image
         */
        
        [cell setPlaceHolderImageAnimated];
        
        if(self.tableView.dragging == NO && self.tableView.decelerating == NO) {
            [self startDownloadForImage:projectImage atIndexPath:indexPath];
        }
    }
    else {
        [cell.projectThumbnailView setImage:[UIImage imageWithData:projectImage.data]];
    }
    
    /**
     *  Populate the cell with data
     */
    [cell.projectTitleLabel setMessageCodes:project.messageCodes];
    [cell.projectTitleLabel setKey:@"title"];
    [cell.projectTitleLabel updateTextFromMessageCodes];
    
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
    ImageController *imageController = [self.imageControllers objectForKey:@(indexPath.row)];
    if(imageController == nil) {
        /**
         *  No image controller for the image associated with the project at the indexpath,
         *  so we need to create one and then start the download.
         */
        imageController = [[ImageController alloc] init];
        imageController.imageObject = image;
        [imageController setCompletionHandler:^{
            
            ProjectTableViewCell *tableViewCell = (ProjectTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [tableViewCell removePlaceholderImage];
            [self configureCell:tableViewCell atIndexPath:indexPath];
            
            [self.imageControllers removeObjectForKey:@(indexPath.row)];
        }];
        [self.imageControllers setObject:imageController forKey:@(indexPath.row)];
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

- (void)loadImagesForVisibleRows {
    NSArray *sections = [self.projectController.fetchedResultsController sections];
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:0];
    NSInteger projectCount = [sectionInfo numberOfObjects];
    
    if(projectCount > 0) {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for(NSIndexPath *indexPath in visiblePaths) {
            Project *project = [self.projectController.fetchedResultsController objectAtIndexPath:indexPath];
            Image *projectImage = (Image *)project.thumbnail;
            if(projectImage.data == nil) {
                [self startDownloadForImage:projectImage atIndexPath:indexPath];
            }
        }
    }
}

#pragma mark - Table view actions

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Project *project = [self.projectController.fetchedResultsController objectAtIndexPath:indexPath];
    DetailViewController *detailViewController = [DetailViewController new];
    detailViewController.project = project;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - The scrollview delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self loadImagesForVisibleRows];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(!decelerate) {
        [self loadImagesForVisibleRows];
    }
}

#pragma mark - Cleanup

- (void)dealloc {
    /**
     *  Cleanup
     */
    [self stopAllImageDownloads];
    [self.projectController cleanupFetchedResultsController];
    [self.projectController setDelegate:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
