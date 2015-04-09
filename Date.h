//
//  Date.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 03/04/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ContentItem;

@interface Date : NSManagedObject

@property (nonatomic, retain) NSDate * from;
@property (nonatomic, retain) NSDate * to;
@property (nonatomic, retain) ContentItem *contentItem;

@end
