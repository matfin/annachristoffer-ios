//
//  FigCaptionView.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 18/12/2014.
//  Copyright (c) 2014 Anna Christoffer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FigCaptionView : UIView
@property (nonatomic, strong) NSDictionary *figCaptionData;
-(id)initWithData:(NSDictionary *)viewData;
-(void)addContentViews;
@end
