//
//  Environment.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 23/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "Environment.h"

@implementation Environment

static Environment *sharedInstance = nil;
@synthesize environmentDictionary;

- (id)init {
    self = [super init];
    return self;
}

+ (Environment *)sharedInstance {
    if(sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
        [sharedInstance setup];
    }
    return sharedInstance;
}

- (void)setup {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *infoPlistPath = [bundle pathForResource:@"Info" ofType:@"plist"];
    self.environmentDictionary = [[NSDictionary alloc] initWithContentsOfFile:infoPlistPath];
}


@end
