//
//  InfoViewController.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 27/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "InfoViewController.h"
#import "ContentController.h"
#import "PageSection.h"
#import "SectionGroup.h"
#import "ContentItem.h"
#import "Date.h"
#import "NSString+MessageCode.h"
#import "ACTextView.h"
#import "TitleLabel.h"

@interface InfoViewController () <NSFetchedResultsControllerDelegate, ContentControllerDelegate>
@property (nonatomic, strong) ContentController *contentController;
@property (nonatomic, strong) Page *page;
@property (nonatomic, strong) UIScrollView *infoScrollView;
@property (nonatomic, strong) UIView *contentView;
@end

@implementation InfoViewController

@synthesize contentController;
@synthesize infoScrollView;
@synthesize contentView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentController = [ContentController sharedInstance];
    [self.contentController fetchPageContent];
    [self.contentController setDelegate:self];
    
    self.infoScrollView = [UIScrollView autoLayoutView];
    [self.infoScrollView setBackgroundColor:[UIColor clearColor]];
    
    self.contentView = [UIView autoLayoutView];
    [self.infoScrollView addSubview:self.contentView];
    [self.view addSubview:self.infoScrollView];
    
    [self setupConstraints];
}

- (void)setupConstraints {
    [super setupConstraints];
    
    NSDictionary *views = @{@"infoScrollView": self.infoScrollView};
    
    /**
     *  Adding constraints for the scrollview.
     */
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[infoScrollView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views
    ]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[infoScrollView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views
    ]];
    
    [self.infoScrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.infoScrollView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0]];
    [self.infoScrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.infoScrollView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0]];
    [self.infoScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:0 metrics:nil views:@{@"contentView": self.contentView}]];
}

#pragma mark - content delegate

- (void)pageContentFetchedAndStored {
    dispatch_async(dispatch_get_main_queue(), ^{
        /**
         *  When ready, we can now populate the content
         */
        self.page = [self.contentController fetchPageWithTitle:@"About"];
        [self setupContentViews];
    });
}

- (void)layoutViewSubviews:(UIView *)view withMetrics:(NSDictionary *)metrics {
    
    UIView *prevView = nil;
    
    for(UIView *subView in view.subviews) {
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subView]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:@{@"subView": subView}
        ]];
        
        if(prevView == nil) {
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(top)-[subView]"
                                                                         options:0
                                                                         metrics:metrics
                                                                           views:@{@"subView": subView}
            ]];
        }
        else {
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[prevView]-(between)-[subView]"
                                                                         options:0
                                                                         metrics:metrics
                                                                           views:@{@"prevView": prevView, @"subView": subView}
            ]];
        }
        
        prevView = subView;
    }
    
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[prevView]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:@{@"prevView": prevView}
    ]];
    
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[prevView]-(bottom)-|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:@{@"prevView": prevView}
    ]];
}

- (void)setupContentViews {
    NSArray *pageSections = [self.page.pageSections array];
    /**
     *  Adding the page sections to the view
     */
    for(PageSection *pageSection in pageSections) {
        [self.contentView addSubview:[self pageSectionViewWithPageSection:pageSection]];
    }
    
    /**
     *  Then setting up the constraints
     */
    [self layoutViewSubviews:self.contentView withMetrics:@{@"top": @(0.0f), @"between": @(20.0f), @"bottom": @(0.0f)}];
}

- (UIView *)pageSectionViewWithPageSection:(PageSection *)pageSection {
    UIView *pageSectionView = [UIView autoLayoutView];
    [pageSectionView setBackgroundColor:[UIColor getColor:colorWhite withAlpha:0.6f]];
    
    NSArray *sectionGroups = [pageSection.sectionGroups array];
    
    /**
     *  Adding text views and labels from the content
     */
    for(SectionGroup *sectionGroup in sectionGroups) {
        NSArray *contentItems = [sectionGroup.contentItems array];
        for(ContentItem *contentItem in contentItems) {
            
            switch([contentItem.type integerValue]) {
                case contentItemTypeHeadingOne: {
                    
                    TitleLabel *label = [TitleLabel autoLayoutView];
                    [label setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:16.0f]];
                    label.messageCodes = contentItem.messageCodes;
                    label.key = @"content";
                    [label updateTextFromMessageCodes];
                    [label setNumberOfLines:0];
                    [pageSectionView addSubview:label];
                    
                    break;
                }
                case contentItemTypeHeadingTwo: {
                    
                    TitleLabel *label = [TitleLabel autoLayoutView];
                    [label setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:22.0f]];
                    label.messageCodes = contentItem.messageCodes;
                    label.key = @"content";
                    [label updateTextFromMessageCodes];
                    [label setNumberOfLines:0];
                    [pageSectionView addSubview:label];
                    
                    break;
                }
                case contentItemTypeHeadingThree: {
                    
                    TitleLabel *label = [TitleLabel autoLayoutView];
                    [label setFont:[UIFont fontWithName:@"OpenSans-Light" size:14.0f]];
                    label.messageCodes = contentItem.messageCodes;
                    label.key = @"content";
                    [label updateTextFromMessageCodes];
                    [label setNumberOfLines:0];
                    [pageSectionView addSubview:label];
                    
                    break;
                }
                case contentItemTypeParagraph: {
                    
                    ACTextView *textView = [[ACTextView alloc] init];
                    [textView setBackgroundColor:[UIColor clearColor]];
                    [textView setKey:@"content"];
                    [textView setMessageCodes:contentItem.messageCodes];
                    [textView updateTextFromMessageCodes];
                    [pageSectionView addSubview:textView];
                    break;
                }
                case contentItemTypeDate: {
                    NSDateFormatter *dateFormatter = [NSDateFormatter new];
                    [dateFormatter setDateFormat:@"MMMM YYYY"];
                    NSString *dateString = @"";
                    NSString *dateFromString = @"";
                    NSString *dateToString = @"";
                    
                    if(contentItem.date.from != nil) {
                        dateFromString = [dateFormatter stringFromDate:contentItem.date.from];
                        dateString = [NSString stringWithFormat:@"%@", dateFromString];
                    }
                    if(contentItem.date.to != nil) {
                        dateToString = [dateFormatter stringFromDate:contentItem.date.to];
                        dateString = [NSString stringWithFormat:@"%@ - %@", dateFromString, dateToString];
                    }
                    
                    TitleLabel *dateLabel = [TitleLabel autoLayoutView];
                    [dateLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:14.0f]];
                    [dateLabel setBackgroundColor:[UIColor clearColor]];
                    [dateLabel setText:dateString];
                    [pageSectionView addSubview:dateLabel];
                    
                    break;
                }
            }
        }
    }
    
    /**
     *  Then setting up the constraints
     */
    [self layoutViewSubviews:pageSectionView withMetrics:@{@"top": @(20.0f), @"between": @(12.0f), @"bottom": @(12.0f)}];
    
    return pageSectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [self.contentController setDelegate:nil];
}

@end
