//
//  SettingsSection.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 19.04.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

enum SettingsSection {
    typealias AllCases = [SettingsSection]

    case preferences(
        models: [Model],
        sectionTitle: String?
    )
    case projectLinks(
        models: [Model],
        [SettingsProjectLinkTableViewCell.CellConfiguration],
        sectionTitle: String?
    )
    case info(
        models: [Model],
        sectionTitle: String?
    )

    var numberOfRows: Int {
        switch self {
        case let .preferences(models: models, _), let .projectLinks(models: models, _, _), let .info(models: models, _):
            return models.count
        }
    }

    var models: [Model] {
        switch self {
        case let .preferences(models: models, _), let .projectLinks(models: models, _, _), let .info(models: models, _):
            return models
        }
    }

    var title: String? {
        switch self {
        case let .preferences(_, title), let .projectLinks(_, _, title), let .info(_, title):
            return title
        }
    }

    func cellClass(action: Action) -> IBConstructable.Type {
        switch (self, action) {
        case (_, .switch(_)):
            return SettingsSwitchTableViewCell.self
        case (_, .check(_)):
            return SettingsCheckTableViewCell.self
        case (.projectLinks, _):
            return SettingsProjectLinkTableViewCell.self
        default:
            return SettingsInfoTableViewCell.self
        }
    }
}

extension SettingsSection {
    struct Model {
        let title: String?
        let subtitle: String?
        let action: Action
        let accessibilityIdentifier: String

        init(
            title: String? = nil,
            subtitle: String? = nil,
            action: Action,
            accessibilityIdentifier: String
        ) {
            self.title = title
            self.subtitle = subtitle
            self.action = action
            self.accessibilityIdentifier = accessibilityIdentifier
        }
    }

    var models: [Model] {
        switch self {
        case .preferences:
            var models = [
                Model(
                    title: getThemeTitle(),

                    action: getThemeAction(),
                    accessibilityIdentifier: "Theme"
                ),
                Model(
                    title: L10n.obversationModeTitle,
                    subtitle: L10n.obversationModeDetail,
                    userInputLabels: [L10n.obversationModeTitle],
                    action: .switch(ObservationModePreferenceStore.self),
                    accessibilityIdentifier: L10n.obversationModeTitle
                ),
                Model(
                    title: "App Icon",
                    action: .navigate(toViewController: AppIconSelectViewController.self),
                    accessibilityIdentifier: "App icon"
                )
            ]
            if Feature.friends.isActive {
                let friendsModel = Model(
                    title: L10n.settingsFriends,
                    subtitle: nil,
                    action: .navigate(toViewController: ManageFriendsViewController.self),
                    accessibilityIdentifier: L10n.settingsFriends
                )
                models.insert(friendsModel, at: 0)
            }
            return models
        case .projectLinks:
            return [
                Model(action: .open(url: Constants.criticalMapsiOSGitHubEndpoint), accessibilityIdentifier: "GitHub"),
                Model(action: .open(url: Constants.criticalMassDotInURL), accessibilityIdentifier: "CriticalMass.in")
            ]
        case .info:
            return [Model(title: L10n.settingsWebsite, action: .open(url: Constants.criticalMapsWebsite), accessibilityIdentifier: "Website"),
                    Model(title: L10n.settingsTwitter, action: .open(url: Constants.criticalMapsTwitterPage), accessibilityIdentifier: "Twitter"),
                    Model(title: L10n.settingsFacebook, action: .open(url: Constants.criticalMapsFacebookPage), accessibilityIdentifier: "Facebook")]
        }
    }

    fileprivate func getThemeTitle() -> String {
        if #available(iOS 13.0, *) {
            return L10n.themeAppearanceLocalizedString
        } else {
            return L10n.themeLocalizedString
        }
    }

    fileprivate func getThemeAction() -> Action {
        if #available(iOS 13.0, *) {
            return .navigate(toViewController: ThemeSelectionViewController.self)
        } else {
            return .switch(ThemeController.self)
        }
    }

    enum Action {
        case navigate(toViewController: UIViewController.Type)
        case open(url: URL)
        case `switch`(_ switchtable: Toggleable.Type)
        case check(_ checkable: Toggleable.Type)
    }
}

extension SettingsSection {
    static let cellClasses: [IBConstructable.Type] = {
        [
            SettingsInfoTableViewCell.self,
            SettingsSwitchTableViewCell.self,
            SettingsCheckTableViewCell.self,
            SettingsProjectLinkTableViewCell.self,
        ]
    }()
}

class Test: Toggleable {
    var isEnabled: Bool = false
}

extension SettingsSection {
    static let eventSettings: [SettingsSection] = [
        .preferences(
            models: [
                Model(
                    title: "Enable event notifications",
                    subtitle: nil,
                    action: .switch(Test.self),
                    accessibilityIdentifier: "Enable"
                )
            ],
            sectionTitle: nil
        ),
        .info(
            models: RideType.allCases.map {
                Model(
                    title: $0.title,
                    action: .check(RideEventTypeSetting.self),
                    accessibilityIdentifier: $0.title
                )
            },
            sectionTitle: "Event Types"
        )
    ]

    static let appSettings: [SettingsSection] = {
        var preferencesModels = [
            Model(
                title: "Event settings",
                action: .navigate(toViewController: EventSettingsViewController.self),
                accessibilityIdentifier: "App icon"
            ),
            Model(
                title: L10n.themeLocalizedString,
                action: .switch(ThemeController.self),
                accessibilityIdentifier: "Theme"
            ),
            Model(
                title: L10n.obversationModeTitle,
                subtitle: L10n.obversationModeDetail,
                action: .switch(ObservationModePreferenceStore.self),
                accessibilityIdentifier: L10n.obversationModeTitle
            ),
            Model(
                title: "App Icon",
                action: .navigate(toViewController: AppIconSelectViewController.self),
                accessibilityIdentifier: "App icon"
            )
        ]
        if Feature.friends.isActive {
            let friendsModel = Model(
                title: L10n.settingsFriends,
                subtitle: nil,
                action: .navigate(toViewController: ManageFriendsViewController.self),
                accessibilityIdentifier: L10n.settingsFriends
            )
            preferencesModels.insert(friendsModel, at: 0)
        }
        return [
            .preferences(models: preferencesModels, sectionTitle: nil),
            .projectLinks(
                models: [
                    Model(action: .open(url: Constants.criticalMapsiOSGitHubEndpoint), accessibilityIdentifier: "GitHub"),
                    Model(action: .open(url: Constants.criticalMassDotInURL), accessibilityIdentifier: "CriticalMass.in")
                ],
                [.github, .criticalMassDotIn],
                sectionTitle: nil
            ),
            .info(
                models: [
                    Model(title: L10n.settingsWebsite, action: .open(url: Constants.criticalMapsWebsite), accessibilityIdentifier: "Website"),
                    Model(title: L10n.settingsTwitter, action: .open(url: Constants.criticalMapsTwitterPage), accessibilityIdentifier: "Twitter"),
                    Model(title: L10n.settingsFacebook, action: .open(url: Constants.criticalMapsFacebookPage), accessibilityIdentifier: "Facebook")
                ],
                sectionTitle: L10n.settingsSectionInfo
            )
        ]
    }()
}
