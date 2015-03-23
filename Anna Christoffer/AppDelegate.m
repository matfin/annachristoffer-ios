//
//  AppDelegate.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 16/12/2014.
//  Copyright (c) 2014 Anna Christoffer. All rights reserved.
//

#import "AppDelegate.h"
#import "ListViewController.h"
#import "ACNavigationController.h"

@interface AppDelegate ()
@property (nonatomic, strong) ACNavigationController *navigationController;
@end

@implementation AppDelegate

@synthesize navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /**
     *  Setting up the initial window, navigation view controller and the first view
     */
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    ListViewController *listTableViewController = [[ListViewController alloc] init];
    
    /**
     *  Setting the list view as the first on the navigation view controller stack
     */
    self.navigationController = [[ACNavigationController alloc] initWithRootViewController:listTableViewController];
    
    /**
     *  Push the navigation view controller onto the window root view controller and make it visible
     */
    [self.window setRootViewController:self.navigationController];
    [self.window makeKeyAndVisible];
    
    NSLog (@"Courier New family fonts: %@", [UIFont fontNamesForFamilyName:@"Open Sans"]);
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
