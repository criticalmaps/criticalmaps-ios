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

extension String {
    static let gpsLocalizedString = NSLocalizedString("GPS", comment: "")
    static let themeLocalizedString = NSLocalizedString("settings.theme", comment: "")
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
            return NSLocalizedString("settings.section.info", comment: "")
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
            return [Model(title: nil, action: .open(url: URL(string: "https://github.com/criticalmaps/criticalmaps-ios")!))]
        case .info:
            return [Model(title: NSLocalizedString("settings.website", comment: ""), action: .open(url: URL(string: "https://www.criticalmaps.net")!)),
                    Model(title: NSLocalizedString("settings.twitter", comment: ""), action: .open(url: URL(string: "https://twitter.com/criticalmaps/")!)),
                    Model(title: NSLocalizedString("settings.facebook", comment: ""), action: .open(url: URL(string: "https://www.facebook.com/criticalmaps")!))]
        }
    }

    enum Action {
        case open(url: URL)
        case none
    }
}
