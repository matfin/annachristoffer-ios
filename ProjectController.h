//
//  ProjectController.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 23/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//
#import "AbstractController.h"
#import "Project.h"
#import "Caption.h"
#import "Slider.h"
#import "Image.h"
#import "Video.h"

typedef NS_ENUM(NSInteger, captionType) {
    captionTypeImage,
    captionTypeSlider,
    captionTypeVideo
};

@protocol ProjectControllerDelegate <NSObject>
- (void)projectDataFetchedAndStored;
@end

@interface ProjectController : AbstractController
@property (nonatomic, weak) id<ProjectControllerDelegate>delegate;
+ (ProjectController *)sharedInstance;
- (void)startFetchingProjectData;
- (void)cleanupFetchedResultsController;
- (void)filterProjectsWithCategory:(ProjectCategory *)category;
@end
