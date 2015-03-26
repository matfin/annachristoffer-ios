//
//  Caption.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 25/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Image, MessageCode, Project, Slider, Video;

@interface Caption : NSManagedObject

@property (nonatomic, retain) NSNumber * captionType;
@property (nonatomic, retain) Image *image;
@property (nonatomic, retain) NSOrderedSet *messageCodes;
@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) Slider *slider;
@property (nonatomic, retain) Video *video;
@end

@interface Caption (CoreDataGeneratedAccessors)

- (void)insertObject:(MessageCode *)value inMessageCodesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromMessageCodesAtIndex:(NSUInteger)idx;
- (void)insertMessageCodes:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeMessageCodesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInMessageCodesAtIndex:(NSUInteger)idx withObject:(MessageCode *)value;
- (void)replaceMessageCodesAtIndexes:(NSIndexSet *)indexes withMessageCodes:(NSArray *)values;
- (void)addMessageCodesObject:(MessageCode *)value;
- (void)removeMessageCodesObject:(MessageCode *)value;
- (void)addMessageCodes:(NSOrderedSet *)values;
- (void)removeMessageCodes:(NSOrderedSet *)values;
@end
