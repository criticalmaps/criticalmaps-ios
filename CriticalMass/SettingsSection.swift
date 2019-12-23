//
//  SettingsSection.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 19.04.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

enum Section: Int, CaseIterable {
    case preferences
    case github
    case info

    struct Model {
        var title: String?
        var subtitle: String?
        var action: Action

        init(title: String? = nil, subtitle: String? = nil, action: Action) {
            self.title = title
            self.subtitle = subtitle
            self.action = action
        }
    }

    var numberOfRows: Int {
        models.count
    }

    var title: String? {
        switch self {
        case .preferences,
             .github:
            return nil
        case .info:
            return String.settingsSectionInfo
        }
    }

    static var allCellClasses: [IBConstructable.Type] {
        [SettingsSwitchTableViewCell.self, SettingsGithubTableViewCellTableViewCell.self, SettingsInfoTableViewCell.self]
    }

    func cellClass(action: Action) -> IBConstructable.Type {
        switch (self, action) {
        case (_, .switch(_)):
            return SettingsSwitchTableViewCell.self
        case (.github, _):
            return SettingsGithubTableViewCellTableViewCell.self
        default:
            return SettingsInfoTableViewCell.self
        }
    }

    var models: [Model] {
        switch self {
        case .preferences:
            var models = [
                Model(title: String.themeLocalizedString, action: .switch(ThemeController.self)),
                Model(title: String.obversationModeTitle, subtitle: String.obversationModeDetail, action: .switch(ObservationModePreferenceStore.self))
            ]
            if Feature.friends.isActive {
                let friendsModel = Model(title: "Friends", subtitle: nil, action: .navigate(toViewController: ManageFriendsViewController.self))
                models.insert(friendsModel, at: 0)
            }
            return models
        case .github:
            return [Model(action: .open(url: Constants.criticalMapsiOSGitHubEndpoint))]
        case .info:
            return [Model(title: String.settingsWebsite, action: .open(url: Constants.criticalMapsWebsite)),
                    Model(title: String.settingsTwitter, action: .open(url: Constants.criticalMapsTwitterPage)),
                    Model(title: String.settingsFacebook, action: .open(url: Constants.criticalMapsFacebookPage))]
        }
    }

    enum Action {
        case navigate(toViewController: UIViewController.Type)
        case open(url: URL)
        case `switch`(_ switchtable: Switchable.Type)
    }
}
