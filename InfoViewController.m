//
//  InfoViewController.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 27/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "InfoViewController.h"
#import "ContentController.h"

@interface InfoViewController () <NSFetchedResultsControllerDelegate, ContentControllerDelegate>
@property (nonatomic, strong) ContentController *contentController;
@property (nonatomic, strong) Page *page;
@end

@implementation InfoViewController

@synthesize contentController;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupConstraints];
    
    self.contentController = [ContentController sharedInstance];
    [self.contentController fetchPageContent];
    [self.contentController setDelegate:self];
}



#pragma mark - content delegate

- (void)pageContentFetchedAndStored {
    dispatch_async(dispatch_get_main_queue(), ^{
        /**
         *  When ready, we can now populate the content
         */
        self.page = [self.contentController fetchPageWithTitle:@"About"];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [self.contentController setDelegate:nil];
}

@end
