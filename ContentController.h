//
//  ContentController.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 28/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "Environment.h"
#import "NSString+Encoded.h"

#import "Page.h"
#import "PageSection.h"
#import "SectionGroup.h"
#import "ConentItem.h"
#import "DateItem.h"
#import "MessageCode.h"

typedef NS_ENUM(NSInteger, ContentItemType) {
    contentItemTypeHeadingOne,
    contentItemTypeHeadingTwo,
    contentItemTypeHeadingThree,
    contentItemTypeParagraph,
    contentItemTypeDate
};

@protocol ContentControllerDelegate <NSObject>
- (void)pageContentFetchedAndStored;
@end

@interface ContentController : NSObject
@property (nonatomic, weak) id<ContentControllerDelegate>delegate;
@property (nonatomic, strong) NSFetchRequest *fetchRequest;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
+ (ContentController *)sharedInstance;
- (NSManagedObjectContext *)managedObjectContext;
- (void)fetchPageContent;
- (void)startFetchedResultsControllerWithDelegate:(id)clientDelegate;
- (void)cleanupFetchedResultsController;
@end
