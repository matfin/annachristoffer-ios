//
//  AbstractViewController.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 18/12/2014.
//  Copyright (c) 2014 Anna Christoffer. All rights reserved.
//

#import "AbstractViewController.h"

@interface AbstractViewController ()

@end

@implementation AbstractViewController

- (id)initWithFrame:(CGRect)bounds {
    self = [super init];
    if(self) {
        [self.view setBounds:bounds];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Anna Claire Christoffer"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    /**
     *  Navigation bar button
     */
    UIButton *menuBarButton = [UIButton initWithFontIcon:iconMenu withColor:[UIColor getColor:colorFuscia] andSize:20.0f];
    [menuBarButton setTranslatesAutoresizingMaskIntoConstraints:YES];
    [menuBarButton setFrame:CGRectMake(0, 0, 48.0f, 48.0f)];
    UIBarButtonItem *menuBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBarButton];
    [self.navigationItem setRightBarButtonItem:menuBarButtonItem];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
