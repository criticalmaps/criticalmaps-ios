//
//  SettingsSection.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 19.04.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

enum Section: CaseIterable {
    typealias AllCases = [Section]

    static var allCases: Section.AllCases {
        [.preferences, .projectLinks([.github, .criticalMassDotIn]), .info]
    }

    case preferences
    case projectLinks([SettingsProjectLinkTableViewCell.CellConfiguration])
    case info

    struct Model {
        let title: String?
        let subtitle: String?
        let action: Action
        let accessibilityIdentifier: String

        init(title: String? = nil, subtitle: String? = nil, action: Action, accessibilityIdentifier: String) {
            self.title = title
            self.subtitle = subtitle
            self.action = action
            self.accessibilityIdentifier = accessibilityIdentifier
        }
    }

    var numberOfRows: Int {
        models.count
    }

    var title: String? {
        switch self {
        case .preferences,
             .projectLinks:
            return nil
        case .info:
            return L10n.settingsSectionInfo
        }
    }

    static var allCellClasses: [IBConstructable.Type] {
        [SettingsSwitchTableViewCell.self, SettingsProjectLinkTableViewCell.self, SettingsInfoTableViewCell.self]
    }

    func cellClass(action: Action) -> IBConstructable.Type {
        switch (self, action) {
        case (_, .switch(_)):
            return SettingsSwitchTableViewCell.self
        case (.projectLinks, _):
            return SettingsProjectLinkTableViewCell.self
        default:
            return SettingsInfoTableViewCell.self
        }
    }

    var models: [Model] {
        switch self {
        case .preferences:
            var models = [
                Model(title: L10n.themeLocalizedString, action: .switch(ThemeController.self), accessibilityIdentifier: "Theme"),
                Model(title: L10n.obversationModeTitle, subtitle: L10n.obversationModeDetail, action: .switch(ObservationModePreferenceStore.self), accessibilityIdentifier: "Observation_Mode")
            ]
            if Feature.friends.isActive {
                let friendsModel = Model(title: .settingsFriends, subtitle: nil, action: .navigate(toViewController: ManageFriendsViewController.self), accessibilityIdentifier: "Friends")
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

    enum Action {
        case navigate(toViewController: UIViewController.Type)
        case open(url: URL)
        case `switch`(_ switchtable: Switchable.Type)
    }
}
