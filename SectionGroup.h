//
//  SectionGroup.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 03/04/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ContentItem, PageSection;

@interface SectionGroup : NSManagedObject

@property (nonatomic, retain) NSOrderedSet *contentItems;
@property (nonatomic, retain) PageSection *pageSection;
@end

@interface SectionGroup (CoreDataGeneratedAccessors)

- (void)insertObject:(ContentItem *)value inContentItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromContentItemsAtIndex:(NSUInteger)idx;
- (void)insertContentItems:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeContentItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInContentItemsAtIndex:(NSUInteger)idx withObject:(ContentItem *)value;
- (void)replaceContentItemsAtIndexes:(NSIndexSet *)indexes withContentItems:(NSArray *)values;
- (void)addContentItemsObject:(ContentItem *)value;
- (void)removeContentItemsObject:(ContentItem *)value;
- (void)addContentItems:(NSOrderedSet *)values;
- (void)removeContentItems:(NSOrderedSet *)values;
@end
