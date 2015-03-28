//
//  DateItem.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 28/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DateItem : NSManagedObject

@property (nonatomic, retain) NSDate * from;
@property (nonatomic, retain) NSDate * to;

@end
