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
    [self styleNavigationBar];
}

- (void)styleNavigationBar {
    /**
     *  Bar tint colour (background colour)
     */
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:(254.0f/255.0f) green:(236.0f/255.0f) blue:(251.0f/255.0f) alpha:0.96f]];
    
    /**
     *  Content tint colour (the text)
     */
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:(221.0f/255.0f) green:(121.0f/255.0f) blue:(222.0f/255.0f) alpha:0.96f]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
