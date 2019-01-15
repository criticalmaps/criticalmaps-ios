//
//  PLAppDelegate.m
//  CriticalMass
//
//  Created by Norman Sander on 08.09.14.
//  Copyright (c) 2014 Pokus Labs. All rights reserved.
//

#import "PLAppDelegate.h"
#import "PLTabBarController.h"
#import "PLMapViewController.h"
#import "PLConstants.h"
#import "PLDataModel.h"
#import "Appirater.h"

@implementation PLAppDelegate

@synthesize tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Set Appirater
    [Appirater setAppId:@"918669647"];
    [Appirater setDaysUntilPrompt:1];
    [Appirater setUsesUntilPrompt:5];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    
#ifdef DEBUG
    if(kDebugShowAppirater) {
        [Appirater setDebug:YES];
    }
#endif
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.tabBarController = [[PLTabBarController alloc] init];
    self.tabBarController.delegate = self;
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
#ifdef DEBUG
    [(UITabBarController *) self.window.rootViewController setSelectedIndex: kDebugInitialTabIndex];
#endif
    
    [Appirater appLaunched:YES];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    DLog(@"applicationWillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    DLog(@"applicationDidEnterBackground");
    [[PLDataModel sharedManager] setIsBackroundMode:YES];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    DLog(@"applicationWillEnterForeground");
    [[PLDataModel sharedManager] setIsBackroundMode:NO];
    [Appirater appEnteredForeground:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    DLog(@"applicationDidBecomeActive");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    DLog(@"applicationWillTerminate");
}

@end
