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

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) Image *image;

-(Project*)initWithTitle:(NSString *)title;

@end
