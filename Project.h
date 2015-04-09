//
//  Project.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 03/04/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Caption, Image, MessageCode, ProjectCategory;

@interface Project : NSManagedObject

@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSNumber * persistentID;
@property (nonatomic, retain) NSOrderedSet *captions;
@property (nonatomic, retain) NSSet *categories;
@property (nonatomic, retain) NSSet *messageCodes;
@property (nonatomic, retain) Image *thumbnail;
@end

@interface Project (CoreDataGeneratedAccessors)

- (void)insertObject:(Caption *)value inCaptionsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCaptionsAtIndex:(NSUInteger)idx;
- (void)insertCaptions:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCaptionsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCaptionsAtIndex:(NSUInteger)idx withObject:(Caption *)value;
- (void)replaceCaptionsAtIndexes:(NSIndexSet *)indexes withCaptions:(NSArray *)values;
- (void)addCaptionsObject:(Caption *)value;
- (void)removeCaptionsObject:(Caption *)value;
- (void)addCaptions:(NSOrderedSet *)values;
- (void)removeCaptions:(NSOrderedSet *)values;
- (void)addCategoriesObject:(ProjectCategory *)value;
- (void)removeCategoriesObject:(ProjectCategory *)value;
- (void)addCategories:(NSSet *)values;
- (void)removeCategories:(NSSet *)values;

- (void)addMessageCodesObject:(MessageCode *)value;
- (void)removeMessageCodesObject:(MessageCode *)value;
- (void)addMessageCodes:(NSSet *)values;
- (void)removeMessageCodes:(NSSet *)values;

@end
