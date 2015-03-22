//
//  ProjectLoader.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 17/12/2014.
//  Copyright (c) 2014 Anna Christoffer. All rights reserved.
//

#import "ProjectLoader.h"
#import "Project.h"

@implementation ProjectLoader

+(NSArray *)projectsFromJSON:(NSData *)data error:(NSError **)error {
    
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    
    if(localError != nil) {
        *error = localError;
    }
    
    NSMutableArray *projects = [[NSMutableArray alloc] init];
    NSArray *results = [parsedObject valueForKey:@"items"];
    
    for(NSDictionary *projectDictionary in results) {
        Project *project = [[Project alloc] initWithDictionary:projectDictionary];
        
        [projects addObject:project];
    }
    
    return projects;
}

@end
