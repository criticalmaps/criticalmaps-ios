//
//  SettingsSection.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 19.04.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation

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
        return models.count
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

    var cellClass: IBConstructable.Type {
        switch self {
        case .preferences:
            return SettingsSwitchTableViewCell.self
        case .github:
            return SettingsGithubTableViewCellTableViewCell.self
        case .info:
            return SettingsInfoTableViewCell.self
        }
    }

    var models: [Model] {
        switch self {
        case .preferences:
            return [
                Model(title: String.themeLocalizedString, action: .switch(ThemeController.self)),
                Model(title: String.obversationModeTitle, subtitle: String.obversationModeDetail, action: .switch(ObservationModePreferenceStore.self)),
                Model(title: "Disable auto sleep", action: .switch(DisableSleepTimerPreferenceStore.self)),
            ]
        case .github:
            return [Model(action: .open(url: Constants.criticalMapsiOSGitHubEndpoint))]
        case .info:
            return [Model(title: String.settingsWebsite, action: .open(url: Constants.criticalMapsWebsite)),
                    Model(title: String.settingsTwitter, action: .open(url: Constants.criticalMapsTwitterPage)),
                    Model(title: String.settingsFacebook, action: .open(url: Constants.criticalMapsFacebookPage))]
        }
    }

    enum Action {
        case open(url: URL)
        case `switch`(_ switchtable: Switchable.Type)
    }
}
