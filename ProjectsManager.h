//
//  ProjectsManager.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 17/12/2014.
//  Copyright (c) 2014 Anna Christoffer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProjectFetcher.h"

@protocol ProjectsManagerDelegate
-(void)didReceiveProjects:(NSArray *)projects;
-(void)projectReceiveFailedWithError:(NSError *)error;
@end

@class ProjectFetcher;

@interface ProjectsManager : NSObject <ProjectsFetcherDelegate>

@property (nonatomic, strong) ProjectFetcher *projectFetcher;
@property (nonatomic, weak) id<ProjectsManagerDelegate> delegate;

-(void)fetchProjects;

@end
