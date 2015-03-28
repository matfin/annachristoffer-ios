//
//  ContentController.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 28/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "ContentController.h"

static ContentController *sharedInstance = nil;

@interface ContentController ()
@property (nonatomic, strong) NSDictionary *environmentDictionary;
@end

@implementation ContentController

@synthesize fetchRequest;
@synthesize fetchedResultsController;

- (id)init {
    if(self = [super init]) {
        self.environmentDictionary = [Environment sharedInstance].environmentDictionary;
    }
    return self;
}

+ (ContentController *)sharedInstance {
    if(sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

#pragma mark - Fetching and saving data from the endpoint

- (void)fetchPageContent {
    
}

- (void)startFetchedResultsControllerWithDelegate:(id)clientDelegate {
    
}

- (void)cleanupFetchedResultsController {
    
}

@end
