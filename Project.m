//
//  Project.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 16/12/2014.
//  Copyright (c) 2014 Anna Christoffer. All rights reserved.
//

#import "Project.h"

@implementation Project

@synthesize id;
@synthesize slug;
@synthesize title;
@synthesize shortDescription;
@synthesize date;
@synthesize contents;
@synthesize thumbnailImage;

-(Project *)initWithDictionary:(NSDictionary *)dictionary {
    
    if(self = [super init]) {
        //TODO: Set up the project from the json response here.
    }
    
    return self;
    
}

-(Project *)initWithTitle:(NSString *)theTitle {
    self = [super init];
    if(self) {
        self.title = theTitle;
    }
    return self;
}

@end
