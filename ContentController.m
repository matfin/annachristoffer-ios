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
    NSString *baseUrl = [self.environmentDictionary objectForKey:@"baseURL"];
    NSString *pageContentEndpoint = [(NSDictionary *)[self.environmentDictionary objectForKey:@"contentEndpoints"] objectForKey:@"pages"];
    NSString *contentURLString = [NSString stringWithFormat:@"%@%@", baseUrl, pageContentEndpoint];
    
    NSURL *contentURL = [NSURL URLWithString:contentURLString];
    NSURLRequest *request =  [[NSURLRequest alloc] initWithURL:contentURL];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if(error) {
                                   //TODO: Handle this error
                               }
                               else {
                                   [self persistFetchedData:data];
                               }
                           }
    ];
}

#pragma mark - persisting using core data

- (void)persistFetchedData:(NSData *)fetchedData {
    NSError *jsonError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:fetchedData options:0 error:&jsonError];
    
    if(jsonError != nil) {
        //TODO: Handle this error
        return;
    }
    
    NSArray *results = [parsedObject objectForKey:@"items"];
    
    for(NSDictionary *pageDictionary in results) {
        [self savePage:pageDictionary];
    }
    
    [self.delegate pageContentFetchedAndStored];
}

- (void)savePage:(NSDictionary *)pageDictionary {
    /**
     *  Setting up the entity description for the page and adding basic data
     */
    NSEntityDescription *pageEntity = [NSEntityDescription entityForName:@"Page" inManagedObjectContext:self.managedObjectContext];
    Page *page = [[Page alloc] initWithEntity:pageEntity insertIntoManagedObjectContext:self.managedObjectContext];
    page.persistentID = @([[pageDictionary objectForKey:@"id"] integerValue]);
    
    
    /**
     *  Then we need to add immediate content, like the title and slug
     */
    [self attachMessageCodesToPage:page withContentDictionary:pageDictionary];
    
    /**
     *  Then attach page sections, groups and content items
     */
    [self attachPageSectionsToPage:(Page *)page withPageSectionsDictionary:[pageDictionary objectForKey:@"sections"]];
    
    
    /**
     *  Then save the page
     */
    NSError *pageSaveError = nil;
    
    if(![self.managedObjectContext save:&pageSaveError]) {
        //TODO: Handle this save error
    }
}

- (void)attachPageSectionsToPage:(Page *)page withPageSectionsDictionary:(NSDictionary *)pageSectionsDictionary {
    
    NSEntityDescription *pageSectionEntity = [NSEntityDescription entityForName:@"PageSection" inManagedObjectContext:self.managedObjectContext];
    for(NSDictionary *pageSectionDictionary in pageSectionsDictionary) {
        /**
         *  Populating basic page section data
         */
        PageSection *pageSection = [[PageSection alloc] initWithEntity:pageSectionEntity insertIntoManagedObjectContext:self.managedObjectContext];
        pageSection.order = @([[pageSectionDictionary objectForKey:@"order"] integerValue]);
        pageSection.name = [pageSectionDictionary objectForKey:@"name"];
        
        /**
         *  Grab and populate the page groups
         */
        
        /**
         *  Then attach to the page in reverse, to overcome a core data bug
         *  where adding a child to the parent would cause the app to crash
         *  when the relationship must be ordered.
         */
        [pageSection setPage:page];
        
    }
    
}

- (void)attachMessageCodesToPage:(Page *)page withContentDictionary:(NSDictionary *)contentDictionary {
    NSEntityDescription *messageCodeEntity = [NSEntityDescription entityForName:@"MessageCode" inManagedObjectContext:self.managedObjectContext];
    NSArray *contentKeys = @[@"title", @"slug"];
    for(NSString *keyString in contentKeys) {
        NSDictionary *contentItemDictionary = [contentDictionary objectForKey:keyString];
        for(NSString *key in contentItemDictionary) {
            MessageCode *pageMessageCode = [[MessageCode alloc] initWithEntity:messageCodeEntity insertIntoManagedObjectContext:self.managedObjectContext];
            pageMessageCode.languageCode = key;
            pageMessageCode.messageContent = [contentItemDictionary valueForKey:key];
            pageMessageCode.messageKey = keyString;
            [page addMessageCodesObject:pageMessageCode];
        }
    }
}

- (void)startFetchedResultsControllerWithDelegate:(id)clientDelegate {
    
}

- (void)cleanupFetchedResultsController {
    
}

@end
