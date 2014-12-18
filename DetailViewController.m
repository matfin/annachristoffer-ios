//
//  DetailViewController.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 16/12/2014.
//  Copyright (c) 2014 Anna Christoffer. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController(){}
@end

@implementation DetailViewController

@synthesize projectData;

-(id)initWithFrame:(CGRect)bounds andProject:(Project *)project {
    if(self = [super init]) {
        self.projectData = project;
        [self.view setBounds:bounds];
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [super setTitle:projectData.title];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

@end
