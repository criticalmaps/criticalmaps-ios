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
#import "PLRulesViewController.h"
#import "PLConstants.h"
#import "PLData.h"

@implementation PLAppDelegate

@synthesize tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.tabBarController = [[PLTabBarController alloc] init];
    self.tabBarController.delegate = self;
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    if(kDebug){
        [(UITabBarController *) self.window.rootViewController setSelectedIndex: 2];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    DLog(@"applicationWillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    DLog(@"applicationDidEnterBackground");
    [[PLData sharedManager] setIsBackroundMode:YES];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    DLog(@"applicationWillEnterForeground");
    [[PLData sharedManager] setIsBackroundMode:NO];
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
