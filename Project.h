//
//  Project.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 23/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Project : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSSet *messageCodes;
@property (nonatomic, retain) NSManagedObject *thumbnail;
@property (nonatomic, retain) NSSet *captions;
@end

@interface Project (CoreDataGeneratedAccessors)

- (void)addMessageCodesObject:(NSManagedObject *)value;
- (void)removeMessageCodesObject:(NSManagedObject *)value;
- (void)addMessageCodes:(NSSet *)values;
- (void)removeMessageCodes:(NSSet *)values;

- (void)addCaptionsObject:(NSManagedObject *)value;
- (void)removeCaptionsObject:(NSManagedObject *)value;
- (void)addCaptions:(NSSet *)values;
- (void)removeCaptions:(NSSet *)values;

@end
