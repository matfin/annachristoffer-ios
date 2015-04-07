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
#import "ProjectCategory.h"
#import "Project.h"
#import "ContentItem.h"
#import "Page.h"
#import "NSString+Encoded.h"

@interface AbstractController : NSObject

@property (nonatomic, strong) NSDictionary *environmentDictionary;

- (NSManagedObjectContext *)managedObjectContext;
- (void)fetchEndpointDataWithKey:(NSString *)key;
- (void)attachMessageCodesToManagedObject:(NSManagedObject *)managedObject withContentDictionary:(NSDictionary *)contentDictionary andContentKeys:(NSArray *)contentKeys;

@end
