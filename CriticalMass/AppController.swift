//
//  AppController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 2/3/19.
//

import Foundation

@objc(PLAppController)
class AppController: NSObject {
    override init() {
        super.init()
    }

    private lazy var requestManager: RequestManager = {
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        return RequestManager(dataStore: MemoryDataStore(), locationProvider: LocationManager(), networkLayer: NetworkOperator(), deviceId: deviceId.md5, url: Constants.apiEndpoint)
    }()

    private lazy var chatManager: ChatManager = {
        ChatManager(requestManager: requestManager)
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
        return SettingsViewController()
    }

    @objc lazy var rootViewController: UIViewController = {
        let rootViewController = MapViewController()

        let navigationOverlay = NavigationOverlayViewController(navigationItems: [
            NavigationOverlayItem(accessibilityLabel: NSLocalizedString("map.locationButton.label", comment: ""), action: .action(rootViewController.didTapfollowMeButton), icon: UIImage(named: "Location")!),
            NavigationOverlayItem(accessibilityLabel: NSLocalizedString("chat.title", comment: ""), action: .navigation(viewController: getSocialViewController), icon: UIImage(named: "Chat")!),
            NavigationOverlayItem(accessibilityLabel: NSLocalizedString("rules.title", comment: ""), action: .navigation(viewController: getRulesViewController), icon: UIImage(named: "Knigge")!),
            NavigationOverlayItem(accessibilityLabel: NSLocalizedString("settings.title", comment: ""), action: .navigation(viewController: getSettingsViewController), icon: UIImage(named: "Settings")!),
        ])
        rootViewController.addChild(navigationOverlay)
        rootViewController.view.addSubview(navigationOverlay.view)
        navigationOverlay.didMove(toParent: rootViewController)

        return rootViewController
    }()
}
