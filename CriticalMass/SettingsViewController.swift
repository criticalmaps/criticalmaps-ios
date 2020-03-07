//
//  SettingsViewController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/31/19.
//

import UIKit

class SettingsViewController: UITableViewController {
    private let themeController: ThemeController
    private let dataStore: DataStore
    private let idProvider: IDProvider

    init(themeController: ThemeController, dataStore: DataStore, idProvider: IDProvider) {
        self.themeController = themeController
        self.dataStore = dataStore
        self.idProvider = idProvider
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        Section.allCellClasses.forEach {
            tableView.register($0.nib, forCellReuseIdentifier: $0.nibName)
        }
        tableView.rowHeight = UITableView.automaticDimension

        configureNotifications()
        configureSettingsFooter()
        configureNavigationBar()

        tableView.register(viewType: SettingsTableSectionHeader.self)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sizeFooterToFit()
    }

    func configureNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(themeDidChange),
            name: .themeDidChange,
            object: nil
        )
    }

    @objc private func themeDidChange() {
        if #available(iOS 13.0, *) {
            if themeController.currentTheme == .dark {
                overrideUserInterfaceStyle = .dark
            } else {
                overrideUserInterfaceStyle = .light
            }
        }
    }

    private func configureSettingsFooter() {
        let settingsFooter = SettingsFooterView.fromNib()
        settingsFooter.buildNumberLabel.text = "Build \(Bundle.main.buildNumber)"
        settingsFooter.versionNumberLabel.text = "Critical Maps \(Bundle.main.versionNumber)"
        tableView.tableFooterView = settingsFooter
    }

    private func configureNavigationBar() {
        title = String.settingsTitle
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }

    override func numberOfSections(in _: UITableView) -> Int {
        Section.allCases.count
    }

    override func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(ofType: SettingsTableSectionHeader.self)
        header.titleLabel.text = Section.allCases[section].title
        return header
    }

    override func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard Section.allCases[section].title != nil else {
            return 0.0
        }
        return 42.0
    }

    override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        Section.allCases[section].numberOfRows
    }

    override func tableView(_: UITableView, estimatedHeightForRowAt _: IndexPath) -> CGFloat {
        60
    }

    override func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = Section.allCases[indexPath.section]
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: section.cellClass(action: section.models[indexPath.row].action)),
            for: indexPath
        )
        configure(cell, for: section, indexPath: indexPath)
        return cell
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let section = Section.allCases[indexPath.section]
        let action = section.models[indexPath.row].action

        switch action {
        case let .open(url: url):
            let application = UIApplication.shared
            guard application.canOpenURL(url) else {
                return
            }
            application.open(url, options: [:], completionHandler: nil)
        case .switch:
            break
        case let .navigate(toViewController):
            let viewController = createViewController(type: toViewController)
            navigationController?.pushViewController(viewController, animated: true)
        }
    }

    private func createViewController(type: UIViewController.Type) -> UIViewController {
        // Perform dependency injection if needed
        switch type {
        case _ as ManageFriendsViewController.Type:
            return ManageFriendsViewController(dataStore: dataStore, idProvider: idProvider)
        default:
            return type.init()
        }
    }
}

extension SettingsViewController {
    fileprivate func configure(_ cell: UITableViewCell, for section: Section, indexPath: IndexPath) {
        switch section {
        case let .projectLinks(configurations):
            if let projectLinkCell = cell as? SettingsProjectLinkTableViewCell {
                let model = configurations[indexPath.row]
                projectLinkCell.titleLabel?.text = model.title
                projectLinkCell.detailLabel?.text = model.detail
                projectLinkCell.actionLabel.text = model.actionTitle
                projectLinkCell.backgroundImageView.image = model.image
            }
        default:
            let model = section.models[indexPath.row]
            if let switchCell = cell as? SettingsSwitchTableViewCell,
                case let .switch(switchableType) = model.action {
                if switchableType == ObservationModePreferenceStore.self {
                    switchCell.configure(switchable: ObservationModePreferenceStore())
                } else if switchableType == ThemeController.self {
                    switchCell.configure(switchable: themeController)
                } else {
                    assertionFailure("Switchable not found")
                }
            }
            cell.textLabel?.text = model.title
            cell.detailTextLabel?.text = model.subtitle
        }
    }
}
