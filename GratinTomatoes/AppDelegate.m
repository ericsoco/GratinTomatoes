//
//  AppDelegate.m
//  GratinTomatoes
//
//  Created by Eric Socolofsky on 3/12/14.
//  Copyright (c) 2014 Eric Socolofsky. All rights reserved.
//

#import "AppDelegate.h"
#import "MovieListViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
    // Override point for customization after application launch.
	
	// In Theaters tab
	MovieListViewController *inTheatersViewController = [[MovieListViewController alloc] init];
	inTheatersViewController.title = @"In Theaters";
	inTheatersViewController.baseUrl = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json";
	UINavigationController *inTheatersNavController = [[UINavigationController alloc] initWithRootViewController:inTheatersViewController];
	inTheatersNavController.tabBarItem.image = [UIImage imageNamed:@"ticket.png"];
	
	// Current DVDs tab
	MovieListViewController *currentDVDsViewController = [[MovieListViewController alloc] init];
	currentDVDsViewController.title = @"DVDs";
	currentDVDsViewController.baseUrl = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/current_releases.json";
	UINavigationController *currentDVDsNavController = [[UINavigationController alloc] initWithRootViewController:currentDVDsViewController];
	currentDVDsNavController.tabBarItem.image = [UIImage imageNamed:@"dvd.png"];
	
	// Set up tab controller
	UITabBarController *tabBarController = [[UITabBarController alloc] init];
	self.window.rootViewController = tabBarController;
	tabBarController.viewControllers = @[inTheatersNavController, currentDVDsNavController];
	
	// Set font for all UINavigationBar titles
	NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
	[titleBarAttributes setValue:[UIFont fontWithName:@"Aller-Bold" size:16] forKey:NSFontAttributeName];
	[[UINavigationBar appearance] setTitleTextAttributes:titleBarAttributes];
	
	// Set font for all UINavigationBar buttons
	NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary: [[UIBarButtonItem appearance] titleTextAttributesForState:UIControlStateNormal]];
	[attributes setValue:[UIFont fontWithName:@"Aller" size:14] forKey:NSFontAttributeName];
	[[UIBarButtonItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
	
	/*
	// Dump font families/names
	for (NSString* family in [UIFont familyNames]) {
		NSLog(@"%@", family);
		for (NSString* name in [UIFont fontNamesForFamilyName: family]) {
			NSLog(@"  %@", name);
		}
	}
	*/
	
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
