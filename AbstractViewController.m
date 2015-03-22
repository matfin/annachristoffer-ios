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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
