//
//  CategoryController.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 02/04/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "CategoryController.h"

static CategoryController *sharedInstance = nil;

@interface CategoryController ()
@property (nonatomic, strong) NSDictionary *environmentDictionary;
@end

@implementation CategoryController

- (id)init {
    if(self = [super init]) {
        self.environmentDictionary = [Environment sharedInstance].environmentDictionary;
    }
    return self;
}

+ (CategoryController *)sharedInstance {
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

- (void)fetchCategoryContent {
    NSString *baseUrl = [self.environmentDictionary objectForKey:@"baseURL"];
    NSString *categoryContentEndpoint = [(NSDictionary *)[self.environmentDictionary objectForKey:@"contentEndpoints"] objectForKey:@"categories"];
    NSString *contentURLString = [NSString stringWithFormat:@"%@%@", baseUrl, categoryContentEndpoint];
    
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

#pragma mark - Coredata persistence

- (void)persistFetchedData:(NSData *)data {
    
    NSError *jsonParseError = nil;
    
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParseError];
    
    if(jsonParseError != nil) {
        return;
    }
    
    NSArray *results = [parsedObject objectForKey:@"items"];
    
    for(NSDictionary *categoryDictionary in results) {
        
        NSNumber *persistentID = [NSNumber numberWithInteger:[categoryDictionary[@"id"] intValue]];
        
        if([self categoryExistsWithPersistentID:persistentID]) continue;
        
        [self saveCategory:categoryDictionary];
        
    }
}

- (void)saveCategory:(NSDictionary *)categoryDictionary {
    
}

- (BOOL)categoryExistsWithPersistentID:(NSNumber *)persistentID {
    NSFetchRequest *categoryFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"ProjectCategory"];
    NSError *error = nil;
    [categoryFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"SELF.persistentID == %ld", [persistentID longLongValue]]];
    [categoryFetchRequest setFetchLimit:1];
    NSUInteger count = [self.managedObjectContext countForFetchRequest:categoryFetchRequest error:&error];
    
    if(count == NSNotFound) {
        return NO;
    }
    else if(count == 0) {
        return NO;
    }
    
    return YES;
}

@end
