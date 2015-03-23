//
//  Caption.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 23/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MessageCode, Project;

@interface Caption : NSManagedObject

@property (nonatomic, retain) NSManagedObject *image;
@property (nonatomic, retain) NSSet *messageCodes;
@property (nonatomic, retain) NSManagedObject *video;
@property (nonatomic, retain) Project *project;
@end

@interface Caption (CoreDataGeneratedAccessors)

- (void)addMessageCodesObject:(MessageCode *)value;
- (void)removeMessageCodesObject:(MessageCode *)value;
- (void)addMessageCodes:(NSSet *)values;
- (void)removeMessageCodes:(NSSet *)values;

@end
