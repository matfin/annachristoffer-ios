//
//  Page.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 29/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MessageCode, PageSection;

@interface Page : NSManagedObject

@property (nonatomic, retain) NSNumber * persistentID;
@property (nonatomic, retain) NSSet *messageCodes;
@property (nonatomic, retain) NSSet *pageSections;
@end

@interface Page (CoreDataGeneratedAccessors)

- (void)addMessageCodesObject:(MessageCode *)value;
- (void)removeMessageCodesObject:(MessageCode *)value;
- (void)addMessageCodes:(NSSet *)values;
- (void)removeMessageCodes:(NSSet *)values;

- (void)addPageSectionsObject:(PageSection *)value;
- (void)removePageSectionsObject:(PageSection *)value;
- (void)addPageSections:(NSSet *)values;
- (void)removePageSections:(NSSet *)values;

@end
