//
//  DetailViewController.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 16/12/2014.
//  Copyright (c) 2014 Anna Christoffer. All rights reserved.
//

#import "DetailViewController.h"
#import "FigCaptionView.h"
#import "UIView+Autolayout.h"

@interface DetailViewController(){}
@end

@implementation DetailViewController

@synthesize projectData;

-(id)initWithProject:(Project *)project {
    if(self = [super init]) {
        self.projectData = project;
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [super setTitle:projectData.title];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIScrollView *sv = [UIScrollView autoLayoutView];
    [self.view addSubview:sv];
    
    [self.view addConstraints:[NSLayoutConstraint   constraintsWithVisualFormat:@"H:|[sv]|"
                                                                        options:0
                                                                        metrics:nil
                                                                        views:@{@"sv":sv}
    ]];
    
    [self.view addConstraints:[NSLayoutConstraint   constraintsWithVisualFormat:@"V:|[sv]|"
                                                                        options:0
                                                                        metrics:nil
                                                                        views:@{@"sv":sv}
    ]];
    
    id prevView = nil;
    
    for(NSDictionary *content in self.projectData.contents) {
        
        if([content[@"type"] isEqualToString:@"figcaption"]) {
            
            FigCaptionView *figcaptionView = [[FigCaptionView alloc] initWithData:content];
            [figcaptionView addContentViews];
            [sv addSubview:figcaptionView];
            
            [sv addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[fcv]|" options:0 metrics:nil views:@{@"fcv": figcaptionView}]];
            
            if(!prevView) {
                [sv addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[fcv]" options:0 metrics:nil views:@{@"fcv": figcaptionView}]];
            }
            else {
                [sv addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[prev][fcv]" options:0 metrics:nil views:@{@"prev": prevView, @"fcv": figcaptionView}]];
            }
            
            prevView = figcaptionView;
        }
    
    }
    
    /**
     *  Scrollview constraints
     */
    [sv addConstraints:[NSLayoutConstraint  constraintsWithVisualFormat:@"H:|[prev]|"
                                            options:0
                                            metrics:nil
                                            views:@{@"prev": prevView}]
    ];
    [sv addConstraints:[NSLayoutConstraint  constraintsWithVisualFormat:@"V:[prev]|"
                                            options:0
                                            metrics:nil
                                            views:@{@"prev": prevView}]
    ];
    
    
    for(UIView *view in self.view.subviews) {
        if([view hasAmbiguousLayout]) {
            NSLog(@"Ambiguity: <%@:0x%0x>", view.description, (int)self);
        }
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

@end
