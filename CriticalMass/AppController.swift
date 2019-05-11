//
//  AppController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 2/3/19.
//

import Foundation

class AppController {
    init() {
        onAppLaunch()
    }

    private func onAppLaunch() {
        loadInitialData()
        themeController.applyTheme()
    }

    private var idProvider: IDProvider = IDStore()
    private var dataStore = MemoryDataStore()

    private lazy var requestManager: RequestManager = {
        RequestManager(dataStore: dataStore, locationProvider: LocationManager(), networkLayer: networkOperator, idProvider: idProvider, url: Constants.apiEndpoint)
    }()

    private let networkOperator: NetworkOperator = {
        NetworkOperator(networkIndicatorHelper: NetworkActivityIndicatorHelper())
    }()

    private let themeController = ThemeController()

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
        return SettingsViewController(themeController: themeController)
    }

    lazy var rootViewController: UIViewController = {
        let rootViewController = MapViewController(themeController: self.themeController, mapController: MapController(dataStore: dataStore))
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

    public func handle(url: URL) -> Bool {
        do {
            let followURLObject = try FollowURLObject.decode(from: url.absoluteString)

            dataStore.add(friend: followURLObject.queryObject)
            let alertController = UIAlertController(title: "Added Friend", message: "Added \(followURLObject.queryObject.name)", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
            rootViewController.present(alertController, animated: true, completion: nil)
            return true
        } catch {
            // unknown or broken link
            return false
        }
    }
}
