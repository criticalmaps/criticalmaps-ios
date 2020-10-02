//
//  SettingsViewController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/31/19.
//

import UIKit

class SettingsViewController: UITableViewController {
    let themeController: ThemeController
    let sections: [SettingsSection]
    let controllerTitle: String

    init(
        controllerTitle: String,
        sections: [SettingsSection],
        themeController: ThemeController
    ) {
        self.controllerTitle = controllerTitle
        self.sections = sections
        self.themeController = themeController
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        SettingsSection.cellClasses.forEach {
            tableView.register($0.nib, forCellReuseIdentifier: $0.nibName)
        }
        tableView.rowHeight = UITableView.automaticDimension

        configureNotifications()
        configureNavigationBar()

        tableView.register(viewType: SettingsTableSectionHeader.self)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sizeFooterToFit()
    }

    private func configureNotifications() {
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
            } else if themeController.currentTheme == .light {
                overrideUserInterfaceStyle = .light
            }
        }
    }

    private func configureNavigationBar() {
        title = controllerTitle
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func numberOfSections(in _: UITableView) -> Int {
        sections.count
    }

    override func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(ofType: SettingsTableSectionHeader.self)
        header.titleLabel.text = sections[section].title
        return header
    }

    override func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard sections[section].title != nil else {
            return 0.0
        }
        return 42.0
    }

    override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].numberOfRows
    }

    override func tableView(_: UITableView, estimatedHeightForRowAt _: IndexPath) -> CGFloat {
        60
    }

    override func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: section.cellClass(action: section.models[indexPath.row].action)),
            for: indexPath
        )
        configure(cell, for: section, indexPath: indexPath)
        return cell
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let section = sections[indexPath.section]
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
        default:
            break
        }
    }

    private func createViewController(type: UIViewController.Type) -> UIViewController {
        // Perform dependency injection if needed
        switch type {
        case _ as ManageFriendsViewController.Type:
            return ManageFriendsViewController(dataStore: dataStore, idProvider: idProvider)
        case _ as ThemeSelectionViewController.Type:
            return ThemeSelectionViewController(themeController: themeController)
        default:
            return type.init()
        }
    }

    func configure(_: UITableViewCell, for _: SettingsSection, indexPath _: IndexPath) {}
}
