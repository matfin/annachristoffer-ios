//
//  MessageCode.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 23/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project, Slider;

@interface MessageCode : NSManagedObject

@property (nonatomic, retain) NSString * languageCode;
@property (nonatomic, retain) NSString * messageContent;
@property (nonatomic, retain) NSString * messageKey;
@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) NSManagedObject *caption;
@property (nonatomic, retain) Slider *slider;

@end
