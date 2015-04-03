//
//  Page.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 03/04/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MessageCode, PageSection;

@interface Page : NSManagedObject

@property (nonatomic, retain) NSNumber * persistentID;
@property (nonatomic, retain) NSSet *messageCodes;
@property (nonatomic, retain) NSOrderedSet *pageSections;
@end

@interface Page (CoreDataGeneratedAccessors)

- (void)addMessageCodesObject:(MessageCode *)value;
- (void)removeMessageCodesObject:(MessageCode *)value;
- (void)addMessageCodes:(NSSet *)values;
- (void)removeMessageCodes:(NSSet *)values;

- (void)insertObject:(PageSection *)value inPageSectionsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPageSectionsAtIndex:(NSUInteger)idx;
- (void)insertPageSections:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePageSectionsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPageSectionsAtIndex:(NSUInteger)idx withObject:(PageSection *)value;
- (void)replacePageSectionsAtIndexes:(NSIndexSet *)indexes withPageSections:(NSArray *)values;
- (void)addPageSectionsObject:(PageSection *)value;
- (void)removePageSectionsObject:(PageSection *)value;
- (void)addPageSections:(NSOrderedSet *)values;
- (void)removePageSections:(NSOrderedSet *)values;
@end
