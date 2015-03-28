//
//  PageSection.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 28/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Page, SectionGroup;

@interface PageSection : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) Page *page;
@property (nonatomic, retain) NSSet *sectionGroups;
@end

@interface PageSection (CoreDataGeneratedAccessors)

- (void)addSectionGroupsObject:(SectionGroup *)value;
- (void)removeSectionGroupsObject:(SectionGroup *)value;
- (void)addSectionGroups:(NSSet *)values;
- (void)removeSectionGroups:(NSSet *)values;

@end
