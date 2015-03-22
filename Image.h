//
//  Image.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 16/12/2014.
//  Copyright (c) 2014 Anna Christoffer. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageFetcherDelegate
- (void)imageDataFetched:(NSData *)imageData;
- (void)imageDataFetchFailedWithError:(NSError *)error;
@end

@interface Image : NSObject
@property (nonatomic, weak) id<ImageFetcherDelegate> delegate;
@property (nonatomic, strong) NSString *imageURLString;
-(Image *)initWithURLString:(NSString *)urlString;
-(void)fetchImageData;
@end
