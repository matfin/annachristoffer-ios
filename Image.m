//
//  Image.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 16/12/2014.
//  Copyright (c) 2014 Anna Christoffer. All rights reserved.
//

#import "Image.h"

#define MEDIA_BASE_URL @"http://media.annachristoffer.com/";

@implementation Image

@synthesize imageURLString;

-(Image *)initWithURLString:(NSString *)urlString {
    if(self = [super init]) {
        self.imageURLString = urlString;
    }
    return self;
}

-(void)fetchImageData {
    
    NSURL *baseUrl = [NSURL URLWithString:@"http://media.annachristoffer.com/"];
    NSURL *imageURL = [NSURL URLWithString:self.imageURLString relativeToURL:baseUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
    
    [NSURLConnection
     sendAsynchronousRequest:request
     queue:[[NSOperationQueue alloc] init]
     completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         if(connectionError) {
             [self.delegate imageDataFetchFailedWithError:connectionError];
         }
         else {
             [self.delegate imageDataFetched:data];
         }
     }];
}

@end
