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
            return L10n.Settings.Section.info
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
            return [
                Model(title: L10n.Settings.theme, action: .switch(ThemeController.self)),
                Model(title: L10n.Settings.Observationmode.title, subtitle: L10n.Settings.Observationmode.detail, action: .switch(ObservationModePreferenceStore.self)),
            ]
        case .github:
            return [Model(action: .open(url: Constants.criticalMapsiOSGitHubEndpoint))]
        case .info:
            return [Model(title: L10n.Settings.website, action: .open(url: Constants.criticalMapsWebsite)),
                    Model(title: L10n.Twitter.title, action: .open(url: Constants.criticalMapsTwitterPage)),
                    Model(title: L10n.Settings.facebook, action: .open(url: Constants.criticalMapsFacebookPage))]
        }
    }

    enum Action {
        case navigate(toViewController: UIViewController.Type)
        case open(url: URL)
        case `switch`(_ switchtable: Switchable.Type)
    }
}
