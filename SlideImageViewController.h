//
//  SlideImageViewController.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 26/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Image.h"

@interface SlideImageViewController : UIViewController
@property (nonatomic, assign) NSUInteger slideIndex;
- (id)initWithImage:(Image *)image withIndex:(NSUInteger)index;
@end
