//
//  MessageCode.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 25/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Caption, Project;

@interface MessageCode : NSManagedObject

@property (nonatomic, retain) NSString * languageCode;
@property (nonatomic, retain) NSString * messageContent;
@property (nonatomic, retain) NSString * messageKey;
@property (nonatomic, retain) Caption *caption;
@property (nonatomic, retain) Project *project;

@end
