//
//  SectionGroup.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 28/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ConentItem, PageSection;

@interface SectionGroup : NSManagedObject

@property (nonatomic, retain) PageSection *pageSection;
@property (nonatomic, retain) NSSet *contentItems;
@end

@interface SectionGroup (CoreDataGeneratedAccessors)

- (void)addContentItemsObject:(ConentItem *)value;
- (void)removeContentItemsObject:(ConentItem *)value;
- (void)addContentItems:(NSSet *)values;
- (void)removeContentItems:(NSSet *)values;

@end
