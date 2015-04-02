//
//  PageSection.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 02/04/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Page, SectionGroup;

@interface PageSection : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) Page *page;
@property (nonatomic, retain) NSOrderedSet *sectionGroups;
@end

@interface PageSection (CoreDataGeneratedAccessors)

- (void)insertObject:(SectionGroup *)value inSectionGroupsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSectionGroupsAtIndex:(NSUInteger)idx;
- (void)insertSectionGroups:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSectionGroupsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSectionGroupsAtIndex:(NSUInteger)idx withObject:(SectionGroup *)value;
- (void)replaceSectionGroupsAtIndexes:(NSIndexSet *)indexes withSectionGroups:(NSArray *)values;
- (void)addSectionGroupsObject:(SectionGroup *)value;
- (void)removeSectionGroupsObject:(SectionGroup *)value;
- (void)addSectionGroups:(NSOrderedSet *)values;
- (void)removeSectionGroups:(NSOrderedSet *)values;
@end
