//
//  Environment.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 23/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Environment : NSObject
@property (nonatomic, strong) NSDictionary *environmentDictionary;
+ (Environment *)sharedInstance;
@end
