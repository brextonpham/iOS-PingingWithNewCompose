//
//  AppDelegate.m
//  Pinging
//
//  Created by Brexton Pham on 7/27/15.
//  Copyright (c) 2015 Brexton Pham. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //initializing parse
    [Parse setApplicationId:@"OVKp5NmMjIXJd6XqOSIwxbZzktT2GfikVfoz7IuL"
                  clientKey:@"t0W3Llo02jwLVjSoH6nWX1mlpC2r9Ii9gKVZ66iJ"];
    
    [self customizeUserInterface];
    
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

- (void)customizeUserInterface {
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.373 green:0.855 blue:0.71 alpha:1]];
    //[[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, nil]]; //makes title buttons white
    //[[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
}


@end
