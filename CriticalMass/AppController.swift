//
//  AppController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 2/3/19.
//

import Foundation

class AppController {
    init() {
        loadInitialData()
    }

    private var requestManager: RequestManager = {
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        return RequestManager(dataStore: MemoryDataStore(), locationProvider: LocationManager(), networkLayer: NetworkOperator(), deviceId: deviceId.md5, url: Constants.apiEndpoint)
    }()

    private let themeController = ThemeController()

    private lazy var chatManager: ChatManager = {
        ChatManager(requestManager: requestManager)
    }()

    private lazy var chatNavigationButtonController: ChatNavigationButtonController = {
        ChatNavigationButtonController(chatManager: chatManager)
    }()

    private lazy var twitterManager: TwitterManager = {
        TwitterManager(networkLayer: NetworkOperator(), url: Constants.twitterEndpoint)
    }()

    private func getRulesViewController() -> RulesViewController {
        return RulesViewController()
    }

    private func getChatViewController() -> ChatViewController {
        return ChatViewController(chatManager: chatManager)
    }

    private func getTwitterViewController() -> TwitterViewController {
        return TwitterViewController(twitterManager: twitterManager)
    }

    private func getSocialViewController() -> SocialViewController {
        return SocialViewController(chatViewController: getChatViewController, twitterViewController: getTwitterViewController)
    }

    private func getSettingsViewController() -> SettingsViewController {
        return SettingsViewController(themeController: themeController)
    }

    lazy var rootViewController: UIViewController = {
        let rootViewController = MapViewController()

        let kniggeButton: UIButton = {
            let button = UIButton(type: .system)
            button.setImage(UIImage(named: "Knigge"), for: .normal)
            return button
        }()
        let settingsButton: UIButton = {
            let button = UIButton(type: .system)
            button.setImage(UIImage(named: "Settings"), for: .normal)
            return button
        }()

        let navigationOverlay = NavigationOverlayViewController(navigationItems: [
            .init(representation: NavigationOverlayItem.Representation(button: rootViewController.followMeButton),
                  action: .none),
            .init(representation: NavigationOverlayItem.Representation(button: chatNavigationButtonController.button),
                  action: .navigation(viewController: getSocialViewController)),
            .init(representation: NavigationOverlayItem.Representation(button: kniggeButton),
                  action: .navigation(viewController: getRulesViewController)),
            .init(representation: NavigationOverlayItem.Representation(button: settingsButton),
                  action: .navigation(viewController: getSettingsViewController)),
        ])
        rootViewController.addChild(navigationOverlay)
        rootViewController.view.addSubview(navigationOverlay.view)
        navigationOverlay.didMove(toParent: rootViewController)

        return rootViewController
    }()

    private func loadInitialData() {
        requestManager.getData()
    }
}
