//
//  ContentItem.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 02/04/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Date, MessageCode, SectionGroup;

@interface ContentItem : NSManagedObject

@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) Date *date;
@property (nonatomic, retain) NSSet *messageCodes;
@property (nonatomic, retain) SectionGroup *sectionGroup;
@end

@interface ContentItem (CoreDataGeneratedAccessors)

- (void)addMessageCodesObject:(MessageCode *)value;
- (void)removeMessageCodesObject:(MessageCode *)value;
- (void)addMessageCodes:(NSSet *)values;
- (void)removeMessageCodes:(NSSet *)values;

@end
