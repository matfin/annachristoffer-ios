//
//  ProjectLoader.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 17/12/2014.
//  Copyright (c) 2014 Anna Christoffer. All rights reserved.
//

#import "ProjectFetcher.h"

#define ENDPOINT_URL @"http://media.annachristoffer.com/content/projects.json";

@implementation ProjectFetcher

-(void)fetchProjects {
    
    NSString *urlAsString = ENDPOINT_URL;
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    
    [NSURLConnection
    sendAsynchronousRequest:request
    queue:[[NSOperationQueue alloc] init]
    completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(connectionError) {
            [self.delegate receivedProjectsJSONFailedWithError:connectionError];
        }
        else {
            [self.delegate receivedProjectsJSON:data];
        }
    }];
}

@end
