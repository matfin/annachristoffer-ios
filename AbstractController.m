//
//  AbstractController.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 07/04/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "AbstractController.h"

@implementation AbstractController

@synthesize fetchRequest;
@synthesize fetchedResultsController;

- (id)init {
    if(self = [super init]) {
        self.environmentDictionary = [Environment sharedInstance].environmentDictionary;
    }
    return self;
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)fetchEndpointDataWithKey:(NSString *)key {
    
    NSString *baseUrl = [self.environmentDictionary objectForKey:@"baseURL"];
    NSString *projectsEndpoint = [(NSDictionary *)[self.environmentDictionary objectForKey:@"contentEndpoints"] objectForKey:key];
    NSString *contentUrlString = [NSString stringWithFormat:@"%@%@", baseUrl, projectsEndpoint];
    
    NSURL *contentURL = [NSURL URLWithString:contentUrlString];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:contentURL];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               if(error) {
                                   [self handleEndpointError:error];
                               }
                               else {
                                   [self saveFetchedData:data];
                               }
                           }
     ];
}

- (void)saveFetchedData:(NSData *)data {
    
}

- (void)handleEndpointError:(NSError *)error {
    
}

- (void)attachMessageCodesToManagedObject:(NSManagedObject *)managedObject withContentDictionary:(NSDictionary *)contentDictionary andContentKeys:(NSArray *)contentKeys {
    /**
     *  Grabbing the entity description for MessageCodes
     */
    NSEntityDescription *messageCodeEntity = [NSEntityDescription entityForName:@"MessageCode" inManagedObjectContext:self.managedObjectContext];
    
    /**
     *  Loop through the content keys which we will need to pull out the data from the dictionary
     */
    for(NSString *keyString in contentKeys) {
        if([contentDictionary objectForKey:keyString] != nil) {
            /**
             *  Grab the nested content if it exists
             */
            NSDictionary *itemDictionary = [contentDictionary objectForKey:keyString];
            
            /**
             *  Loop through the item dictionary keys. The itemKey in this case
             *  is the language for the message code (2 digit code).
             */
            for(NSString *itemKey in itemDictionary) {
                /**
                 *  Creating the message code entity and assigning data
                 */
                MessageCode *messageCode = [[MessageCode alloc] initWithEntity:messageCodeEntity insertIntoManagedObjectContext:self.managedObjectContext];
                messageCode.messageKey      = keyString;
                messageCode.messageContent  = [itemDictionary valueForKey:itemKey];
                messageCode.languageCode    = itemKey;
                
                /**
                 *  Then assign the message code to managedObject
                 */
                if([managedObject isKindOfClass:[ProjectCategory class]]) {
                    [(ProjectCategory *)managedObject addMessageCodesObject:messageCode];
                }
                else if([managedObject isKindOfClass:[Project class]]) {
                    [(Project *)managedObject addMessageCodesObject:messageCode];
                }
                else if([managedObject isKindOfClass:[ContentItem class]]) {
                    [(ContentItem *)managedObject addMessageCodesObject:messageCode];
                }
                else if([managedObject isKindOfClass:[Page class]]) {
                    [(Page *)managedObject addMessageCodesObject:messageCode];
                }
            }
        }
    }
}

- (BOOL)managedObjectExistsWithEntityName:(NSString *)entityName andPredicate:(NSPredicate *)predicate {
    
    NSFetchRequest *objectFetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    NSError *error = nil;
    [objectFetchRequest setPredicate:predicate];
    [objectFetchRequest setFetchLimit:1];
    NSUInteger count = [self.managedObjectContext countForFetchRequest:objectFetchRequest error:&error];
    if(count == NSNotFound || count == 0) {
        return NO;
    }
    return YES;
}

- (void)startFetchedResultsControllerWithEntityName:(NSString *)entityName andSortDescriptors:(NSArray *)sortDescriptors andClientDelegate:(id)delegate {
    
    self.fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    if(sortDescriptors != nil) {
        [self.fetchRequest setSortDescriptors:sortDescriptors];
    }
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:[NSString stringWithFormat:@"Cache%@", entityName]];
    NSError *fetchError = nil;
    
    [self.fetchedResultsController performFetch:&fetchError];
    
    if(fetchError != nil) {
        //TODO: Handle this error
    }
}

@end
