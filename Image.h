//
//  Image.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 29/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Caption, Project, Slider;

@interface Image : NSManagedObject

@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) Caption *caption;
@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) Slider *slider;

@end
