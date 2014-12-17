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
@synthesize description;
@synthesize date;
@synthesize contents;
@synthesize thumbnailImage;

-(Project *)initWithDictionary:(NSDictionary *)dictionary {
    
    //TODO: Set and get the language from NSUserDefaults
    static NSString *language = @"en";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    
    if(self = [super init]) {
        self.id = @([dictionary[@"id"] intValue]);
        self.slug = dictionary[@"slug"][language];
        self.title = dictionary[@"title"][language];
        self.description = dictionary[@"description"][language];
        self.date = [dateFormatter dateFromString:dictionary[@"date_created"]];
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
