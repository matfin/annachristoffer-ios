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

#pragma mark - persisting using core data

- (void)saveFetchedData:(NSData *)data {
    NSError *jsonError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
    
    if(jsonError != nil) {
        //TODO: Handle this error
        return;
    }
    
    NSArray *results = [parsedObject objectForKey:@"items"];
    
    for(NSDictionary *pageDictionary in results) {
        
        NSNumber *persistentID = [NSNumber numberWithInteger:[pageDictionary[@"id"] intValue]];
        
        if([self pageExistsWithPersistentID:persistentID]) continue;
        
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
    [self attachMessageCodesToManagedObject:page withContentDictionary:pageDictionary andContentKeys:@[@"title", @"slug"]];
    
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
        [self attachGroupsToPageSection:pageSection withGroupsDictionary:[pageSectionDictionary objectForKey:@"groups"]];
        
        /**
         *  Then attach to the page in reverse, to overcome a core data bug
         *  where adding a child to the parent would cause the app to crash
         *  when the relationship must be ordered.
         */
        [pageSection setPage:page];
    }
}

- (void)attachGroupsToPageSection:(PageSection *)pageSection withGroupsDictionary:(NSDictionary *)groupsDictionary {
    NSEntityDescription *sectionGroupEntity = [NSEntityDescription entityForName:@"SectionGroup" inManagedObjectContext:self.managedObjectContext];
    for(NSDictionary *sectionGroupDictionary in groupsDictionary) {
        SectionGroup *sectionGroup = [[SectionGroup alloc] initWithEntity:sectionGroupEntity insertIntoManagedObjectContext:self.managedObjectContext];
        
        /**
         *  Grab and populate the groups content items
         */
        [self attachContentItemsToGroup:sectionGroup withContentItemsDictionary:[sectionGroupDictionary objectForKey:@"items"]];
        
        /**
         *  Then attach to the page section
         */
        [sectionGroup setPageSection:pageSection];
    }
}

- (void)attachContentItemsToGroup:(SectionGroup *)sectionGroup withContentItemsDictionary:(NSDictionary *)contentItemsDictionary {
    NSEntityDescription *contentItemEntity = [NSEntityDescription entityForName:@"ContentItem" inManagedObjectContext:self.managedObjectContext];
    for(NSDictionary *contentItemDictionary in contentItemsDictionary) {
        
        /**
         *  Create a content item and attach it to the group
         */
        ContentItem *contentItem = [[ContentItem alloc] initWithEntity:contentItemEntity insertIntoManagedObjectContext:self.managedObjectContext];
        
        /**
         *  Dictionary to assign keys to content types
         */
        NSDictionary *contentTypes = @{
            @"h1": @(contentItemTypeHeadingOne),
            @"h2": @(contentItemTypeHeadingTwo),
            @"h3": @(contentItemTypeHeadingThree),
            @"date": @(contentItemTypeDate),
            @"p": @(contentItemTypeParagraph)
        };
        
        /**
         *  Assigning the type
         */
        contentItem.type = [contentTypes objectForKey:[contentItemDictionary objectForKey:@"type"]];
        
        /**
         *  Assigning content
         */
        switch([contentItem.type integerValue]) {
            case contentItemTypeDate: {
                [self attachDatesToContentItem:contentItem withItemsDictionary:[contentItemDictionary objectForKey:@"content"]];
                break;
            }
            default: {
                [self attachMessageCodesToManagedObject:contentItem withContentDictionary:contentItemDictionary andContentKeys:@[@"content"]];
                break;
            }
        }
        
        /**
         *  Then saving to the section group
         */
        [contentItem setSectionGroup:sectionGroup];
    }
}

- (void)attachDatesToContentItem:(ContentItem *)contentItem withItemsDictionary:(NSDictionary *)itemsDictionary {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSEntityDescription *dateEntity = [NSEntityDescription entityForName:@"Date" inManagedObjectContext:self.managedObjectContext];
    NSArray *contentKeys = @[@"from", @"to"];
    Date *date = [[Date alloc] initWithEntity:dateEntity insertIntoManagedObjectContext:self.managedObjectContext];
    
    for(NSString *contentKey in contentKeys) {
        if([itemsDictionary valueForKey:contentKey] != nil) {
            if([contentKey isEqualToString:@"from"]) {
                date.from = [dateFormatter dateFromString:[itemsDictionary valueForKey:contentKey]];
            }
            else if([contentKey isEqualToString:@"to"]) {
                date.to = [dateFormatter dateFromString:[itemsDictionary valueForKey:contentKey]];
            }
        }
    }
    
    contentItem.date = date;
}

#pragma mark - Fetching pages

- (NSArray *)fetchPages {
    NSFetchRequest *pageFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Page"];
    NSError *pageFetchError = nil;
    NSArray *pages = [self.managedObjectContext executeFetchRequest:pageFetchRequest error:&pageFetchError];
    if(pageFetchError != nil) {
        //TODO: Handle fetch error
        return nil;
    }
    
    return pages;
}

- (Page *)fetchPageWithTitle:(NSString *)title {
    
    NSFetchRequest *pageFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Page"];
    [pageFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"ANY messageCodes.messageContent MATCHES %@", title]];
    [pageFetchRequest setFetchLimit:1];
    NSError *pageFetchError = nil;
    NSArray *pages = [self.managedObjectContext executeFetchRequest:pageFetchRequest error:&pageFetchError];
    if(pageFetchError != nil) {
        //TODO: Handle fetch error
        return nil;
    }
    else if([pages count] == 0) {
        return nil;
    }
    return [pages objectAtIndex:0];
}

#pragma mark - checking content already exists

- (BOOL)pageExistsWithPersistentID:(NSNumber *)persistentID {
    
    NSFetchRequest *pageFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Page"];
    NSError *error = nil;
    [pageFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"SELF.persistentID == %ld", [persistentID longLongValue]]];
    [pageFetchRequest setFetchLimit:1];
    NSUInteger count = [self.managedObjectContext countForFetchRequest:pageFetchRequest error:&error];
    
    if(count == NSNotFound) {
        return NO;
    }
    else if(count == 0) {
        return NO;
    }
    
    return YES;
}

@end
