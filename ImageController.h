//
//  ImageController.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 24/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Image.h"

@interface ImageController : NSObject

@property (nonatomic, strong) Image *imageObject;
@property (nonatomic, copy) void (^completionHandler)(void);

- (void)startImageDownload;
- (void)stopImageDownload;

@end
