//
//  Video.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 28/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Caption;

@interface Video : NSManagedObject

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) Caption *caption;

@end
