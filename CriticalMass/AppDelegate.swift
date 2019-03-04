//
//  AppDelegate.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 3/4/19.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let appController = AppController()

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Set Appirater
        Appirater.setAppId("918669647")
        Appirater.setDaysUntilPrompt(1)
        Appirater.setUsesUntilPrompt(5)
        Appirater.setSignificantEventsUntilPrompt(-1)
        Appirater.setTimeBeforeReminding(2)

        #if DEBUG
            Appirater.setDebug(true)
        #endif

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = appController.rootViewController
        window?.makeKeyAndVisible()

        Appirater.appLaunched(true)
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        Appirater.appEnteredForeground(true)
    }
}
