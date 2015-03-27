//
//  UIView+Animate.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 27/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "UIView+Animate.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Animate)
+ (id)rotatingViewWithDuration:(CGFloat)duration andRotations:(CGFloat)rotations andRepeatCount:(float)repeat {
    UIView *view = [self new];
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0 * rotations * duration];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    return view;
}
@end
