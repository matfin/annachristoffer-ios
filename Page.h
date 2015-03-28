//
//  Page.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 28/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MessageCode;

@interface Page : NSManagedObject

@property (nonatomic, retain) NSNumber * persistentID;
@property (nonatomic, retain) MessageCode *title;
@property (nonatomic, retain) NSSet *pageSections;
@end

@interface Page (CoreDataGeneratedAccessors)

- (void)addPageSectionsObject:(NSManagedObject *)value;
- (void)removePageSectionsObject:(NSManagedObject *)value;
- (void)addPageSections:(NSSet *)values;
- (void)removePageSections:(NSSet *)values;

@end
