//
//  PageSection.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 28/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Page;

@interface PageSection : NSManagedObject

@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Page *page;
@property (nonatomic, retain) NSSet *sectionGroups;
@end

@interface PageSection (CoreDataGeneratedAccessors)

- (void)addSectionGroupsObject:(NSManagedObject *)value;
- (void)removeSectionGroupsObject:(NSManagedObject *)value;
- (void)addSectionGroups:(NSSet *)values;
- (void)removeSectionGroups:(NSSet *)values;

@end
