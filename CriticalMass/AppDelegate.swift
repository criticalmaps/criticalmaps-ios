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
        #if DEBUG
            guard ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil else {
                // We are in a XCTest and setting up the AppController would add Noise to the tests
                return true
            }
        #endif

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = appController.rootViewController
        window?.makeKeyAndVisible()

        appController.onAppLaunch()
        handleLaunchArguments()
        return true
    }

    func applicationWillEnterForeground(_: UIApplication) {
        appController.onWillEnterForeground()
    }

    private func handleLaunchArguments() {
        #if DEBUG
        let arguments = ProcessInfo().arguments

        if arguments.contains("SKIP_ANIMATIONS") {
            UIView.setAnimationsEnabled(false)
        }
        #endif
    }
}
