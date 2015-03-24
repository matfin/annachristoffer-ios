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

#import "Project.h"
#import "Caption.h"
#import "Slider.h"
#import "MessageCode.h"
#import "Image.h"
#import "Video.h"

@interface ProjectController : NSObject
+ (ProjectController *)sharedInstance;
- (NSManagedObjectContext *)managedObjectContext;
- (void)fetchProjectData;
@end
