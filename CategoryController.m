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
    
    [self.delegate categoryDataFetchedAndStored];
}

- (void)saveCategory:(NSDictionary *)categoryDictionary {
    NSEntityDescription *categoryEntity = [NSEntityDescription entityForName:@"ProjectCategory" inManagedObjectContext:self.managedObjectContext];
    ProjectCategory *category = [[ProjectCategory alloc] initWithEntity:categoryEntity insertIntoManagedObjectContext:self.managedObjectContext];
    
    /**
     *  Setting up the id and message codes for the category.
     */
    category.persistentID = @([[categoryDictionary objectForKey:@"id"] integerValue]);
    [self attachMessageCodesToCategory:category withContentDictionary:categoryDictionary];
    
    /**
     *  Then saving it
     */
    NSError *categorySaveError = nil;
    if(![self.managedObjectContext save:&categorySaveError]) {
        //TODO: Handle this save error
    }
}

- (void)attachMessageCodesToCategory:(ProjectCategory *)projectCategory withContentDictionary:(NSDictionary *)contentDictionary {
    
    NSEntityDescription *messageCodeEntity = [NSEntityDescription entityForName:@"MessageCode" inManagedObjectContext:self.managedObjectContext];
    NSArray *contentKeys = @[@"title", @"description", @"slug"];
    
    for(NSString *keyString in contentKeys) {
        NSDictionary *contentItemDictionary = [contentDictionary objectForKey:keyString];
        for(NSString *key in contentItemDictionary) {
            MessageCode *messageCode = [[MessageCode alloc] initWithEntity:messageCodeEntity insertIntoManagedObjectContext:self.managedObjectContext];
            messageCode.messageKey = keyString;
            messageCode.messageContent = [contentItemDictionary valueForKey:key];
            messageCode.languageCode = key;
            [projectCategory addMessageCodesObject:messageCode];
        }
    }
}

#pragma mark - Fetching category data

- (NSArray *)fetchCategories {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"ProjectCategory"];
    NSError *fetchError = nil;
    NSArray *categories = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    if(fetchError != nil) {
        return nil;
    }
    return categories;
}

- (ProjectCategory *)fetchCategoryWithPersistentID:(NSNumber *)persistentID {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"ProjectCategory"];
    NSError *fetchError = nil;
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"SELF.persistentID == %ld", [persistentID longLongValue]]];
    [fetchRequest setFetchLimit:1];
    
    NSArray *fetchedCategory = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    
    if(fetchError != nil) {
        return nil;
    }
    if([fetchedCategory count] < 1) {
        return nil;
    }
    else {
        return [fetchedCategory objectAtIndex:0];
    }
}

#pragma mark - Checking to see if the category exists before adding it.

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
