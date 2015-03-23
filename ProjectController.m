//
//  ProjectController.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 23/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "ProjectController.h"

static ProjectController *sharedInstance = nil;

@implementation ProjectController

- (id)init {
    self = [super init];
    return self;
}

+ (ProjectController *)sharedInstance {
    if(sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)fetchProjectData {
    
    NSDictionary *environmentDictionary = [Environment sharedInstance].environmentDictionary;
    NSString *baseUrl = [environmentDictionary objectForKey:@"baseURL"];
    NSString *projectsEndpoint = [(NSDictionary *)[environmentDictionary objectForKey:@"contentEndpoints"] objectForKey:@"projects"];
    NSString *contentUrlString = [NSString stringWithFormat:@"%@%@", baseUrl, projectsEndpoint];
    
    NSURL *contentURL = [NSURL URLWithString:contentUrlString];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:contentURL];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               if(error) {
                                   //TODO: Handle error here
                               }
                               else {
                                   [self persistFetchedData:data];
                               }
                           }
    ];
}

- (void)persistFetchedData:(NSData *)fetchedData {
    
}

@end
