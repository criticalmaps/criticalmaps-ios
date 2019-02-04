//
//  PLAppDelegate.m
//  CriticalMass
//
//  Created by Norman Sander on 08.09.14.
//  Copyright (c) 2014 Pokus Labs. All rights reserved.
//

#import "PLAppDelegate.h"
#import "PLConstants.h"
#import "Appirater.h"
#import "CriticalMaps-Swift.h"

@implementation PLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    PLAppController *appController = [PLAppController new];
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
    self.window.rootViewController = appController.rootViewController;
    [self.window makeKeyAndVisible];
    self.appController = appController;
    
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    DLog(@"applicationWillEnterForeground");
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
