//
//  SettingsViewController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/31/19.
//

import UIKit

class SettingsViewController: UITableViewController {
    enum Section: CaseIterable {
        case gps
        case darkMode
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
            case .gps,
                 .darkMode,
                 .github:
                return nil
            case .info:
                return NSLocalizedString("settings.section.info", comment: "")
            }
        }

        var cellClass: UITableViewCell.Type {
            switch self {
            case .gps:
                return SettingsSwitchTableViewCell.self
            case .darkMode:
                return SettingsSwitchTableViewCell.self
            case .github:
                return SettingsGithubTableViewCellTableViewCell.self
            case .info:
                return SettingsInfoTableViewCell.self
            }
        }

        var models: [Model] {
            switch self {
            case .gps:
                return [Model(title: NSLocalizedString("GPS", comment: ""), action: .none)]
            case .darkMode:
                return [Model(title: "Dark Mode", action: .none)]
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

    override func viewDidLoad() {
        super.viewDidLoad()

        for cell in Section.allCases.map({ $0.cellClass }) {
            let name = String(describing: cell)
            tableView.register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
        }
        tableView.rowHeight = UITableView.automaticDimension

        configureSettingsFooter()
        configureNavigationBar()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sizeFooterToFit()
    }

    private func configureSettingsFooter() {
        var footer: SettingsFooterView? {
            let settingsFooter = SettingsFooterView.fromNib()
            settingsFooter?.versionNumberLabel.text = "Critical Maps \(Bundle.main.versionNumber)"
            settingsFooter?.buildNumberLabel.text = "Build \(Bundle.main.buildNumber)"
            return settingsFooter
        }
        tableView.tableFooterView = footer
    }

    private func configureNavigationBar() {
        title = NSLocalizedString("settings.title", comment: "")
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }

    override func numberOfSections(in _: UITableView) -> Int {
        return Section.allCases.count
    }

    override func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section.allCases[section].secionTitle
    }

    override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Section.allCases[section].numberOfRows
    }

    override func tableView(_: UITableView, estimatedHeightForRowAt _: IndexPath) -> CGFloat {
        return 60
    }

    override func tableView(_: UITableView, willDisplayHeaderView view: UIView, forSection _: Int) {
        for subView in view.subviews {
            subView.backgroundColor = .white
            for case let label as UILabel in subView.subviews {
                label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = Section.allCases[indexPath.section]
        let identifier = String(describing: section.cellClass)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = section.models[indexPath.row].title
        return cell
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let section = Section.allCases[indexPath.section]
        let acttion = section.models[indexPath.row].action

        switch acttion {
        case .none:
            return
        case let .open(url: url):
            let application = UIApplication.shared
            guard application.canOpenURL(url) else {
                return
            }
            application.open(url, options: [:], completionHandler: nil)
        }
    }
}

extension UITableViewController {
    func sizeFooterToFit() {
        guard let footerView = tableView.tableFooterView else {
            return
        }
        let height = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        let footerFrame = footerView.frame
        if height != footerFrame.size.height {
            footerView.frame.size.height = height
        }
    }
}
