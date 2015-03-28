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
#import "ContentItem.h"
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
+ (ContentController *)sharedInstance;
- (NSManagedObjectContext *)managedObjectContext;
- (void)fetchPageContent;
- (NSArray *)fetchPages;
- (Page *)fetchPageWithTitle:(NSString *)title;
@end
