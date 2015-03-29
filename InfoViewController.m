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
#import "UITextView+ACTextView.h"

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
    NSDictionary *metrics = @{@"margin": @(44.0f)};
    
    /**
     *  Adding constraints for the scrollview.
     */
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[infoScrollView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views
    ]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(margin)-[infoScrollView]|"
                                                                      options:0
                                                                      metrics:metrics
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

- (void)layoutViewSubviews:(UIView *)view {
    
    UIView *prevView = nil;
    
    for(UIView *subView in view.subviews) {
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subView]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:@{@"subView": subView}
        ]];
        
        if(prevView == nil) {
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[subView]"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:@{@"subView": subView}
            ]];
        }
        else {
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[prevView][subView]"
                                                                         options:0
                                                                         metrics:nil
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
    
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[prevView]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:@{@"prevView": prevView}
    ]];
}

- (void)setupContentViews {
    NSArray *pageSections = [self.page.pageSections allObjects];
    /**
     *  Adding the page sections to the view
     */
    for(PageSection *pageSection in pageSections) {
        [self.contentView addSubview:[self pageSectionViewWithPageSection:pageSection]];
    }
    
    /**
     *  Then setting up the constraints
     */
    [self layoutViewSubviews:self.contentView];
}

- (UIView *)pageSectionViewWithPageSection:(PageSection *)pageSection {
    UIView *pageSectionView = [UIView autoLayoutView];
    [pageSectionView setBackgroundColor:[UIColor getColor:colorWhite withAlpha:0.6f]];
    
    NSArray *sectionGroups = [pageSection.sectionGroups allObjects];
    
    /**
     *  Adding text views and labels from the content
     */
    for(SectionGroup *sectionGroup in sectionGroups) {
        NSArray *contentItems = [sectionGroup.contentItems allObjects];
        for(ContentItem *contentItem in contentItems) {
            
            switch([contentItem.type integerValue]) {
                case contentItemTypeHeadingOne: {
                    UILabel *label = [UILabel initWithFont:[UIFont fontWithName:@"OpenSans-Bold" size:16.0f] withColor:[UIColor blackColor]];
                    [label setText:[NSString messageFromSet:contentItem.messageCodes withKey:@"content" withLanguageCode:@"en"]];
                    [pageSectionView addSubview:label];
                    break;
                }
                case contentItemTypeHeadingTwo: {
                    UILabel *label = [UILabel initWithFont:[UIFont fontWithName:@"OpenSans-Semibold" size:16.0f] withColor:[UIColor blackColor]];
                    [label setText:[NSString messageFromSet:contentItem.messageCodes withKey:@"content" withLanguageCode:@"en"]];
                    [pageSectionView addSubview:label];
                    break;
                }
                case contentItemTypeHeadingThree: {
                    UILabel *label = [UILabel initWithFont:[UIFont fontWithName:@"OpenSans-Light" size:16.0f] withColor:[UIColor blackColor]];
                    [label setText:[NSString messageFromSet:contentItem.messageCodes withKey:@"content" withLanguageCode:@"en"]];
                    [pageSectionView addSubview:label];
                    break;
                }
                case contentItemTypeParagraph: {
                    UITextView *textview = [UITextView initAsCaptionTextView];
                    [textview setText:[NSString messageFromSet:contentItem.messageCodes withKey:@"content" withLanguageCode:@"en"]];
                    [pageSectionView addSubview:textview];
                    break;
                }
                case contentItemTypeDate: {
                    break;
                }
            }
        }
    }
    
    /**
     *  Then setting up the constraints
     */
    [self layoutViewSubviews:pageSectionView];
    
    return pageSectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [self.contentController setDelegate:nil];
}

@end
