//
//  ViewController.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 16/12/2014.
//  Copyright (c) 2014 Anna Christoffer. All rights reserved.
//

#import "ListViewController.h"
#import "ProjectTableViewCell.h"
#import "Project.h"

@implementation ListViewController

@synthesize projectTableView;
@synthesize projects;
@synthesize manager;
@synthesize detailViewController;

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProjectTableViewCell *cell = (ProjectTableViewCell *)[tableView dequeueReusableCellWithIdentifier:nil];
    
    Project *project = [self.projects objectAtIndex:indexPath.row];
    
    if(cell == nil) {        
        cell = [[ProjectTableViewCell alloc] initWithProject:project andReuseIdentifier:nil];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    Project *project = [self.projects objectAtIndex:indexPath.row];
    self.detailViewController = [[DetailViewController alloc] initWithProject:project];
    
    [self.navigationController pushViewController:self.detailViewController animated:YES];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return [self.projects count];
    return 10;
}

-(void)loadView {
    [super loadView];
    
    CGRect tableBounds = [self.view bounds];
    
    self.projectTableView = [[UITableView alloc] initWithFrame:CGRectMake(tableBounds.origin.x, tableBounds.origin.y, tableBounds.size.width, tableBounds.size.height) style:UITableViewStylePlain];
    self.projectTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.projectTableView.separatorColor = [UIColor clearColor];
    
    self.projectTableView.delegate = self;
    self.projectTableView.dataSource = self;
    [self.view addSubview:self.projectTableView];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [[ProjectsManager alloc] init];
    self.manager.projectFetcher = [[ProjectFetcher alloc] init];
    self.manager.projectFetcher.delegate = manager;
    self.manager.delegate = self;
    [self.manager fetchProjects];
}

-(void)didReceiveProjects:(NSArray *)theProjects {
    self.projects = theProjects;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.projectTableView reloadData];
    });
}

-(void)projectReceiveFailedWithError:(NSError *)error {
    NSLog(@"Error fetching projects: %@, %@", error, [error localizedDescription]);
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
