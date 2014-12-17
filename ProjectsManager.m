//
//  ProjectsManager.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 17/12/2014.
//  Copyright (c) 2014 Anna Christoffer. All rights reserved.
//

#import "ProjectsManager.h"
#import "ProjectLoader.h"
#import "ProjectFetcher.h"

@implementation ProjectsManager

-(void)fetchProjects {
    [self.projectFetcher fetchProjects];
}

-(void)receivedProjectsJSON:(NSData *)data {
    
    NSError *error = nil;
    NSArray *projects = [ProjectLoader projectsFromJSON:data error:&error];
    
    if(error != nil) {
        [self.delegate projectReceiveFailedWithError:error];
    }
    else {
        [self.delegate didReceiveProjects:projects];
    }
    
}

-(void)receivedProjectsJSONFailedWithError:(NSError *)error {
    [self.delegate projectReceiveFailedWithError:error];
}

@end
