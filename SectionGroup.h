//
//  SectionGroup.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 29/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ContentItem, PageSection;

@interface SectionGroup : NSManagedObject

@property (nonatomic, retain) NSSet *contentItems;
@property (nonatomic, retain) PageSection *pageSection;
@end

@interface SectionGroup (CoreDataGeneratedAccessors)

- (void)addContentItemsObject:(ContentItem *)value;
- (void)removeContentItemsObject:(ContentItem *)value;
- (void)addContentItems:(NSSet *)values;
- (void)removeContentItems:(NSSet *)values;

@end
