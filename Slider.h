//
//  Slider.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 23/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Slider : NSManagedObject

@property (nonatomic, retain) NSSet *images;
@property (nonatomic, retain) NSSet *messageCodes;
@end

@interface Slider (CoreDataGeneratedAccessors)

- (void)addImagesObject:(NSManagedObject *)value;
- (void)removeImagesObject:(NSManagedObject *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

- (void)addMessageCodesObject:(NSManagedObject *)value;
- (void)removeMessageCodesObject:(NSManagedObject *)value;
- (void)addMessageCodes:(NSSet *)values;
- (void)removeMessageCodes:(NSSet *)values;

@end
