//
//  ProjectLoader.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 17/12/2014.
//  Copyright (c) 2014 Anna Christoffer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectLoader : NSObject

+ (NSArray *)projectsFromJSON:(NSData *)data error:(NSError **)error;

@end
