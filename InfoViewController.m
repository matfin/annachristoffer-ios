//
//  InfoViewController.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 27/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "InfoViewController.h"
#include "ContentController.h"

@interface InfoViewController ()
@property (nonatomic, strong) ContentController *contentController;
@end

@implementation InfoViewController

@synthesize contentController;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupConstraints];
    
    self.contentController = [ContentController sharedInstance];
    [self.contentController fetchPageContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
