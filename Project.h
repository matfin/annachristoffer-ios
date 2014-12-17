//
//  Project.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 16/12/2014.
//  Copyright (c) 2014 Anna Christoffer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Image.h"

@interface Project : NSObject

@property (nonatomic, strong) NSNumber  *id;
@property (nonatomic, strong) NSString  *slug;
@property (nonatomic, strong) NSString  *title;
@property (nonatomic, strong) NSString  *shortDescription;
@property (nonatomic, strong) NSDate    *date;
@property (nonatomic, strong) NSArray   *contents;

@property (nonatomic, strong) Image *thumbnailImage;

-(Project *)initWithTitle:(NSString *)title;
-(Project *)initWithDictionary:(NSDictionary *)dictionary;

@end
