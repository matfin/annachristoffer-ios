//
//  ContentController.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 28/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//
#import "AbstractController.h"
#import "Page.h"
#import "PageSection.h"
#import "SectionGroup.h"
#import "ContentItem.h"
#import "Date.h"

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

@interface ContentController : AbstractController
@property (nonatomic, weak) id<ContentControllerDelegate>delegate;
+ (ContentController *)sharedInstance;
- (NSArray *)fetchPages;
- (Page *)fetchPageWithTitle:(NSString *)title;
@end
