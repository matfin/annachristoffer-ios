//
//  ConentItem.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 28/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MessageCode;

@interface ConentItem : NSManagedObject

@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSManagedObject *sectionGroup;
@property (nonatomic, retain) NSSet *messageCodes;
@end

@interface ConentItem (CoreDataGeneratedAccessors)

- (void)addMessageCodesObject:(MessageCode *)value;
- (void)removeMessageCodesObject:(MessageCode *)value;
- (void)addMessageCodes:(NSSet *)values;
- (void)removeMessageCodes:(NSSet *)values;

@end
