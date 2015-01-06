//
//  FigCaptionView.h
//  Anna Christoffer
//
//  Created by Matthew Finucane on 18/12/2014.
//  Copyright (c) 2014 Anna Christoffer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Image.h"

@interface FigCaptionView : UIView <ImageFetcherDelegate>
-(id)initWithData:(NSDictionary *)viewData;
-(void)addContentViews;
@end
