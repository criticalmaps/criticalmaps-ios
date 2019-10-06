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
    lazy var appController = AppController()

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Test Configuration
        if let shouldEarlyExitForTests = configureAppForTests() {
            return shouldEarlyExitForTests
        }

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = appController.rootViewController
        window?.makeKeyAndVisible()

        appController.onAppLaunch()
        return true
    }

    func applicationWillEnterForeground(_: UIApplication) {
        appController.onWillEnterForeground()
    }

    func configureAppForTests() -> Bool? {
        #if DEBUG
            guard ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil else {
                // We are in a XCTest and setting up the AppController would add Noise to the tests
                return true
            }

            if ProcessInfo.processInfo.arguments.contains("SKIP_ANIMATIONS") {
                UIView.setAnimationsEnabled(false)
            }
            return nil
        #endif
    }
}
