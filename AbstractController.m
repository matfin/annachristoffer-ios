//
//  AbstractController.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 07/04/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "AbstractController.h"

@implementation AbstractController

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

@end
