//
//  AbstractController.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 07/04/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "Environment.h"
#import "MessageCode.h"
#import "NSString+Encoded.h"

@interface AbstractController : NSObject
- (NSManagedObjectContext *)managedObjectContext;
@end
