//
//  AppController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 2/3/19.
//

import UIKit

class AppController {
    private var idProvider: IDProvider = IDStore()
    private let userDefaults: UserDefaults = .standard
    private lazy var dataStore = AppDataStore(friendsStorage: userDefaults)
    private var simulationModeEnabled = false

    private lazy var observationModePreferenceStore = ObservationModePreferenceStore(store: userDefaults)
    private lazy var requestManager: RequestManager = {
        RequestManager(
            dataStore: dataStore,
            locationProvider: LocationManager(observationModePreferenceStore: observationModePreferenceStore),
            networkLayer: networkOperator,
            idProvider: idProvider,
            networkObserver: networkObserver
        )
    }()

    private lazy var networkOperator: NetworkOperator = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.timeoutIntervalForRequest = 15.0
        let session = URLSession(configuration: configuration)

        let networkDataProvider: NetworkDataProvider
        if simulationModeEnabled {
            networkDataProvider = SimulationNetworkDataProvider(realNetworkDataProvider: session)
        } else {
            networkDataProvider = session
        }
        return NetworkOperator(networkIndicatorHelper: NetworkActivityIndicatorHelper(), dataProvider: networkDataProvider)
    }()

    private let networkObserver = PathObserver()

    private lazy var themeController = ThemeController(store: ThemeSelectionStore(store: userDefaults))

    private lazy var chatManager: ChatManager = {
        ChatManager(requestManager: requestManager, chatMessageStorage: userDefaults)
    }()

    private lazy var chatNavigationButtonController: ChatNavigationButtonController = {
        ChatNavigationButtonController(chatManager: chatManager)
    }()

    private lazy var twitterManager: TwitterManager = {
        TwitterManager(networkLayer: networkOperator, request: TwitterRequest())
    }()

    lazy var mapViewController: MapViewController = {
        MapViewController(
            themeController: self.themeController,
            friendsVerificationController: FriendsVerificationController(dataStore: dataStore),
            nextRideManager: NextRideManager(
                apiHandler: CMInApiHandler(networkLayer: networkOperator),
                filterDistance: Double(userDefaults.nextRideRadius)
            )
        )
    }()

    lazy var rootViewController: UIViewController = {
        let navigationOverlay = NavigationOverlayViewController(navigationItems: [
            .init(representation: .view(mapViewController.followMeButton),
                  action: .none,
                  accessibilityIdentifier: "Follow"),
            .init(representation: .button(chatNavigationButtonController.button),
                  action: .navigation(viewController: getSocialViewController),
                  accessibilityIdentifier: "Chat"),
            .init(representation: .icon(UIImage(named: "Knigge")!, accessibilityLabel: L10n.rulesTitle),
                  action: .navigation(viewController: getRulesViewController),
                  accessibilityIdentifier: "Rules"),
            .init(representation: .icon(UIImage(named: "Settings")!, accessibilityLabel: L10n.settingsTitle),
                  action: .navigation(viewController: getSettingsViewController),
                  accessibilityIdentifier: "Settings"),
        ])
        mapViewController.addChild(navigationOverlay)
        mapViewController.view.addSubview(navigationOverlay.view)
        navigationOverlay.didMove(toParent: mapViewController)

        return mapViewController
    }()

    private lazy var ratingHelper = RatingHelper(ratingStorage: userDefaults)

    public func onAppLaunch() {
        loadInitialData()
        themeController.applyTheme()
        ratingHelper.onLaunch()
    }

    public func onWillEnterForeground() {
        ratingHelper.onEnterForeground()
    }

    public func enableSimulationMode() {
        simulationModeEnabled = true
    }

    private func getRulesViewController() -> RulesViewController {
        RulesViewController(themeController: themeController)
    }

    private func getChatViewController() -> ChatViewController {
        ChatViewController(chatManager: chatManager, themeController: themeController)
    }

    private func getTwitterViewController() -> TwitterViewController {
        TwitterViewController(twitterManager: twitterManager)
    }

    private func getSocialViewController() -> SocialViewController {
        SocialViewController(chatViewController: getChatViewController(), twitterViewController: getTwitterViewController())
    }

    private func getSettingsViewController() -> SettingsViewController {
        AppSettingsViewController(
            controllerTitle: L10n.settingsTitle,
            sections: SettingsSection.appSettings,
            themeController: themeController,
            dataStore: dataStore,
            idProvider: idProvider,
            observationModePreferenceStore: observationModePreferenceStore
        )
    }

    private func loadInitialData() {
        requestManager.getData()
    }

    public func handle(url: URL) -> Bool {
        if Feature.friends.isActive {
            do {
                let followURLObject = try FollowURLObject.decode(from: url.absoluteString)

                dataStore.add(friend: followURLObject.queryObject)
                AlertPresenter.shared.presentAlert(
                    title: L10n.settingsAddFriendTitle,
                    message: followURLObject.queryObject.name + " " + L10n.settingsAddFriendDescription,
                    preferredStyle: .alert,
                    actionData: [UIAlertAction(title: L10n.ok, style: .default, handler: nil)]
                )
                return true
            } catch {
                // unknown or broken link
                return false
            }
        } else {
            return false
        }
    }
}
