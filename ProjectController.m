//
//  ProjectController.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 23/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "ProjectController.h"

static ProjectController *sharedInstance = nil;

@implementation ProjectController

@synthesize fetchRequest;
@synthesize fetchedResultsController;

- (id)init {
    self = [super init];
    return self;
}

+ (ProjectController *)sharedInstance {
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

- (void)fetchProjectData {
    
    NSDictionary *environmentDictionary = [Environment sharedInstance].environmentDictionary;
    NSString *baseUrl = [environmentDictionary objectForKey:@"baseURL"];
    NSString *projectsEndpoint = [(NSDictionary *)[environmentDictionary objectForKey:@"contentEndpoints"] objectForKey:@"projects"];
    NSString *contentUrlString = [NSString stringWithFormat:@"%@%@", baseUrl, projectsEndpoint];
    
    NSURL *contentURL = [NSURL URLWithString:contentUrlString];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:contentURL];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               if(error) {
                                   //TODO: Handle error here
                               }
                               else {
                                   [self persistFetchedData:data];
                               }
                           }
    ];
}

- (void)persistFetchedData:(NSData *)fetchedData {
    NSError *jsonError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:fetchedData options:0 error:&jsonError];
    
    if(jsonError != nil) {
        //TODO: Handle json parse error
        return;
    }
    
    NSArray *results = [parsedObject valueForKey:@"items"];
    
    for(NSDictionary *projectDictionary in results) {
        
        /**
         *  Checking to see if the project already exists before saving it
         */
        NSNumber *persistentID = [NSNumber numberWithInteger:[projectDictionary[@"id"] intValue]];
        
        if([self projectExistsWithPersistentID:persistentID]) continue;
        
        [self saveProject:projectDictionary];
    }
    
    [self.delegate projectDataFetchedAndStored];
}

- (void)saveProject:(NSDictionary *)projectDictionary {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *baseUrl = [[[Environment sharedInstance] environmentDictionary] objectForKey:@"baseURL"];
    
    /**
     *  Entity description for the Project managed object model
     */
    NSEntityDescription *projectEntity = [NSEntityDescription entityForName:@"Project" inManagedObjectContext:self.managedObjectContext];
    Project *project = [[Project alloc] initWithEntity:projectEntity insertIntoManagedObjectContext:self.managedObjectContext];
    project.persistentID = @([projectDictionary[@"id"] integerValue]);
    project.dateCreated = [dateFormatter dateFromString:projectDictionary[@"date_created"]];
    
    /**
     *  Call the function to save the basic content to the project,
     *  things like the title and description
     */
    [self attachMessageCodesToProject:project withContentDictionary:projectDictionary];
    
    /**
     *  Entity description for the Image managed object model - the projects thumbnail image
     */
    NSEntityDescription *imageEntity = [NSEntityDescription entityForName:@"Image" inManagedObjectContext:self.managedObjectContext];
    Image *image = [[Image alloc] initWithEntity:imageEntity insertIntoManagedObjectContext:self.managedObjectContext];
    
    /**
     *  Use a predicate filter on the contents dictionary to pull out the thumbnail image for the project
     */
    NSPredicate *thumbnailFilterPredicate = [NSPredicate predicateWithFormat:@"type MATCHES %@", @"thumbnail"];
    NSArray *filteredContents = [[projectDictionary objectForKey:@"contents"] filteredArrayUsingPredicate:thumbnailFilterPredicate];
    
    /**
     *  Grab the result and assign it to the image, then assign the image to the project
     */
    if([filteredContents count] > 0) {
        NSString *imagePath = [[filteredContents objectAtIndex:0] objectForKey:@"img"];
        image.url = [NSString stringWithFormat:@"%@%@%@%@", baseUrl, @"images/projects/",imagePath, @"@2x.jpg"];
        [project setThumbnail:image];
    }
    
    /**
     *  Then save everything
     */
    NSError *projectSaveError = nil;
    if(![self.managedObjectContext save:&projectSaveError]) {
        //TODO: Could not save the project - handle this error
    }
}

- (void)attachMessageCodesToProject:(Project *)project withContentDictionary:(NSDictionary *)contentDictionary {
    /**
     *  Entity description for the message codes managed objects
     */
    NSEntityDescription *messageCodeEntity = [NSEntityDescription entityForName:@"MessageCode" inManagedObjectContext:self.managedObjectContext];
    NSArray *contentKeys = @[@"title", @"description"];
    for(NSString *keyString in contentKeys) {
        NSDictionary *contentItemDictionary = [contentDictionary objectForKey:keyString];
        for(NSString *key in contentItemDictionary) {
            /**
             *  Create a new messageCode object to add to the project. This will deal with one or more languages
             */
            MessageCode *projectMessageCode = [[MessageCode alloc] initWithEntity:messageCodeEntity insertIntoManagedObjectContext:self.managedObjectContext];
            projectMessageCode.languageCode = key;
            projectMessageCode.messageContent = [contentItemDictionary valueForKey:key];
            projectMessageCode.messageKey = keyString;
            [project addMessageCodesObject:projectMessageCode];
        }
    }
}

#pragma mark - Returning data from the CoreData store

- (void)startFetchedResultsControllerWithDelegate:(id)clientDelegate {
    /**
     *  The fetch request
     */
    self.fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Project"];
    [self.fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"dateCreated" ascending:NO]]];
    
    /**
     *  The fetched results controller
     */
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    [self.fetchedResultsController setDelegate:clientDelegate];
    
    /**
     *  Performing the fetch
     */
    NSError *fetchError = nil;
    [self.fetchedResultsController performFetch:&fetchError];
    if(fetchError != nil) {
        //TODO: Manage fetch error
    }
}

#pragma mark - Checking existing data

- (BOOL)projectExistsWithPersistentID:(NSNumber *)persistentID {
    NSFetchRequest *projectFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Project"];
    NSError *error = nil;
    [projectFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"SELF.persistentID == %ld", [persistentID longLongValue]]];
    [projectFetchRequest setFetchLimit:1];
    NSUInteger count = [self.managedObjectContext countForFetchRequest:projectFetchRequest error:&error];
    
    if(count == NSNotFound) {
        return NO;
    }
    else if(count == 0) {
        return NO;
    }

    return YES;
}

#pragma mark - Cleanup

- (void)cleanupFetchedResultsController {
    [self.fetchedResultsController setDelegate:nil];
    [self setFetchedResultsController:nil];
    [self setFetchRequest:nil];
}

@end
