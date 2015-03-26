//
//  SliderViewController.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 26/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SliderViewController : UIPageViewController
@property (nonatomic, strong) NSArray *childViewControllers;
- (id)initWithChildViewControllers:(NSArray *)viewControllers;
@end
