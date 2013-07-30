//
//  TabbedCountdownAppDelegate.m
//  TabbedCountdown
//
//  Created by Murphy, Stephen - William S on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TabbedCountdownAppDelegate.h"
#import "CountdownTableViewController.h"
#import "Countdown.h"

@implementation TabbedCountdownAppDelegate {
    NSMutableArray *countdownsArray;
}

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //Read initial countdowns from plist
    NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [arrayPaths objectAtIndex:0];
    NSString *finalPath = [docDir stringByAppendingPathComponent:@"Countdowns.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //If list does not exist in documents dir, load default from bundle dir
    if(![fileManager fileExistsAtPath:finalPath]) {
        NSString *path = [[NSBundle mainBundle] bundlePath];
        finalPath = [path stringByAppendingPathComponent:@"Countdowns.plist"];
    }
        
    NSDictionary *plistData = [NSDictionary dictionaryWithContentsOfFile:finalPath];
    countdownsArray = [NSMutableArray arrayWithCapacity:[plistData count]];
    for(id key in plistData) {
        Countdown *countdown = [[Countdown alloc] init];
        NSDate *value = [plistData objectForKey:key];
        NSLog(@"DEBUG: %@  %@", key, value);
        countdown.name = key;
        countdown.targetDate = value;
        [countdownsArray addObject:countdown];
    }
    
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
	CountdownTableViewController *countdownTableViewController = [[navigationController viewControllers] objectAtIndex:0];
	countdownTableViewController.countdownsArray = countdownsArray;
    
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
