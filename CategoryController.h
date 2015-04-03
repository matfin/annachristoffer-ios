//
//  CategoryController.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 02/04/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Environment.h"
#import "NSString+Encoded.h"
#import "Project.h"
#import "ProjectCategory.h"

#import "MessageCode.h"
#import "NSString+MessageCode.h"

@protocol CategoryControllerDelegate <NSObject>
- (void)categoryDataFetchedAndStored;
@end

@interface CategoryController : NSObject

@property (nonatomic, weak) id<CategoryControllerDelegate>delegate;
+ (CategoryController *)sharedInstance;
- (NSManagedObjectContext *)managedObjectContext;
- (void)fetchCategoryContent;
- (NSArray *)fetchCategories;

@end
