//
//  Project.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 16/12/2014.
//  Copyright (c) 2014 Anna Christoffer. All rights reserved.
//

#import "Project.h"

@implementation Project

@synthesize title;
@synthesize image;

-(Project*)initWithTitle:(NSString *)theTitle {
    self = [super init];
    if(self) {
        self.title = theTitle;
    }
    return self;
}

@end
