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

    private let networkOperator: NetworkOperator = {
        NetworkOperator(networkIndicatorHelper: NetworkActivityIndicatorHelper())
    }()

    private lazy var requestManager: RequestManager = {
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        return RequestManager(dataStore: MemoryDataStore(), locationProvider: LocationManager(), networkLayer: networkOperator, deviceId: deviceId.md5, url: Constants.apiEndpoint)
    }()

    private lazy var chatManager: ChatManager = {
        ChatManager(requestManager: requestManager)
    }()

    private lazy var chatNavigationButtonController: ChatNavigationButtonController = {
        ChatNavigationButtonController(chatManager: chatManager)
    }()

    private lazy var twitterManager: TwitterManager = {
        TwitterManager(networkLayer: networkOperator, url: Constants.twitterEndpoint)
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
        return SettingsViewController()
    }

    lazy var rootViewController: UIViewController = {
        let rootViewController = MapViewController()

        let navigationOverlay = NavigationOverlayViewController(navigationItems: [
            .init(representation: .view(rootViewController.followMeButton), action: .none),
            .init(representation: .button(chatNavigationButtonController.button), action: .navigation(viewController: getSocialViewController)),
            .init(representation: .icon(UIImage(named: "Knigge")!, accessibilityLabel: NSLocalizedString("rules.title", comment: "")), action: .navigation(viewController: getRulesViewController)),
            .init(representation: .icon(UIImage(named: "Settings")!, accessibilityLabel: NSLocalizedString("settings.title", comment: "")), action: .navigation(viewController: getSettingsViewController)),
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
