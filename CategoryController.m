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

#pragma mark - Coredata persistence

- (void)saveFetchedData:(NSData *)data {
    
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
    [self attachMessageCodesToManagedObject:category withContentDictionary:categoryDictionary andContentKeys:@[@"title", @"description", @"slug"]];
    
    /**
     *  Then saving it
     */
    NSError *categorySaveError = nil;
    if(![self.managedObjectContext save:&categorySaveError]) {
        //TODO: Handle this save error
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
