//
//  ProjectController.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 23/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "Environment.h"

#import "NSString+Encoded.h"

#import "Project.h"
#import "Caption.h"
#import "Slider.h"
#import "MessageCode.h"
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

@interface ProjectController : NSObject
@property (nonatomic, weak) id<ProjectControllerDelegate>delegate;
@property (nonatomic, strong) NSFetchRequest *fetchRequest;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
+ (ProjectController *)sharedInstance;
- (NSManagedObjectContext *)managedObjectContext;
- (void)startFetchingProjectData;
- (void)startFetchedResultsControllerWithDelegate:(id)clientDelegate;
- (void)cleanupFetchedResultsController;
@end
