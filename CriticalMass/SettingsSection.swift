//
//  SettingsSection.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 19.04.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation

extension Hashable where Self: CaseIterable {
    var index: Self.AllCases.Index {
        return type(of: self).allCases.firstIndex(of: self)!
    }
}

enum Section: Int, CaseIterable {
    case preferences
    case github
    case info

    struct Model {
        var title: String?
        var action: Action
    }

    var numberOfRows: Int {
        return models.count
    }

    var secionTitle: String? {
        switch self {
        case .preferences,
             .github:
            return nil
        case .info:
            return String.settingsSectionInfo
        }
    }

    var cellClass: UITableViewCell.Type {
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
                Model(title: String.gpsLocalizedString, action: .none),
                Model(title: String.themeLocalizedString, action: .none),
            ]
        case .github:
            return [Model(title: nil, action: .open(url: Constants.criticalMapsiOSGitHubEndpoint))]
        case .info:
            return [Model(title: String.settingsWebsite, action: .open(url: Constants.criticalMapsWebsite)),
                    Model(title: String.settingsTwitter, action: .open(url: Constants.criticalMapsTwitterPage)),
                    Model(title: String.settingsFacebook, action: .open(url: Constants.criticalMapsFacebookPage))]
        }
    }

    enum Action {
        case open(url: URL)
        case none
    }
}
