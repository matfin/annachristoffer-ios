//
//  CategoryController.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 02/04/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//
#import "AbstractController.h"
#import "Project.h"
#import "ProjectCategory.h"
#import "NSString+MessageCode.h"

@protocol CategoryControllerDelegate <NSObject>
- (void)categoryDataFetchedAndStored;
@end

@interface CategoryController : AbstractController

@property (nonatomic, weak) id<CategoryControllerDelegate>delegate;
+ (CategoryController *)sharedInstance;
- (void)fetchCategoryContent;
- (NSArray *)fetchCategories;
- (ProjectCategory *)fetchCategoryWithPersistentID:(NSNumber *)persistentID;
@end
