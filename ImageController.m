//
//  ImageController.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 24/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "ImageController.h"

@interface ImageController () <NSURLConnectionDataDelegate>
@property (nonatomic, strong) NSMutableData *activeDownloadData;
@property (nonatomic, strong) NSURLConnection *downloadConnection;
@end

@implementation ImageController

#pragma mark - Starting and stopping the download

- (void)startImageDownload {
    /**
     *  Without an Image managed object we should quit
     */
    if(!self.imageObject) return;
    
    /**
     *  Or else we start the download.
     */
    self.activeDownloadData = [NSMutableData data];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.imageObject.url]];
    self.downloadConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)stopImageDownload {
    /**
     *  Cancel current connection and clear out all data
     */
    [self.downloadConnection cancel];
    self.downloadConnection = nil;
    self.activeDownloadData = nil;
}

#pragma mark - NSURLConnection delegates

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.activeDownloadData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.activeDownloadData = nil;
    self.downloadConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    /**
     *  Assign the data to the Image object data attribute
     */
    self.imageObject.data = self.activeDownloadData;
    
    NSError *imageDataSaveError = nil;
    if(![self.imageObject.managedObjectContext save:&imageDataSaveError]) {
        //TODO: Handle this error
    }
    else {
        /**
         *  Call the completion handler
         */
        if(self.completionHandler) {
            self.completionHandler();
        }
    }
    
    /**
     *  Cleanup
     */
    self.activeDownloadData = nil;
    self.downloadConnection = nil;
}

- (void)dealloc {
    [self stopImageDownload];
}

@end
