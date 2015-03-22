//
//  ProjectLoader.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 17/12/2014.
//  Copyright (c) 2014 Anna Christoffer. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ProjectsFetcherDelegate
-(void)receivedProjectsJSON:(NSData *)data;
-(void)receivedProjectsJSONFailedWithError:(NSError *)error;
@end

@interface ProjectFetcher : NSObject
@property (nonatomic, weak) id<ProjectsFetcherDelegate> delegate;
-(void)fetchProjects;
@end
