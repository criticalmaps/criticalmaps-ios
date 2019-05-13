//
//  SettingsViewController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/31/19.
//

import UIKit

class SettingsViewController: UITableViewController {
    private let themeController: ThemeController!

    init(themeController: ThemeController) {
        self.themeController = themeController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        for cell in Section.allCases.map({ $0.cellClass }) {
            tableView.register(cell.nib, forCellReuseIdentifier: cell.nibName)
        }
        tableView.rowHeight = UITableView.automaticDimension

        configureSettingsFooter()
        configureNavigationBar()

        tableView.register(viewType: SettingsTableSectionHeader.self)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sizeFooterToFit()
    }

    private func configureSettingsFooter() {
        var footer: SettingsFooterView? {
            let settingsFooter = SettingsFooterView.fromNib()
            settingsFooter.versionNumberLabel.text = "Critical Maps \(Bundle.main.versionNumber)"
            settingsFooter.buildNumberLabel.text = "Build \(Bundle.main.buildNumber)"
            return settingsFooter
        }
        tableView.tableFooterView = footer
    }

    private func configureNavigationBar() {
        title = String.settingsTitle
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }

    // MARK: Actions

    @IBAction func gpsCellAction(_ sender: UISwitch) {
        Preferences.gpsEnabled = sender.isOn
    }

    @IBAction func darkModeCellAction(_ sender: UISwitch) {
        let theme: Theme = sender.isOn ? .dark : .light
        themeController.changeTheme(to: theme)
        themeController.applyTheme()
    }

    override func numberOfSections(in _: UITableView) -> Int {
        return Section.allCases.count
    }

    override func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(ofType: SettingsTableSectionHeader.self)
        header.titleLabel.text = Section.allCases[section].secionTitle
        return header
    }

    override func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section == Section.info.index else {
            return 0.0
        }
        return 42.0
    }

    override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Section.allCases[section].numberOfRows
    }

    override func tableView(_: UITableView, estimatedHeightForRowAt _: IndexPath) -> CGFloat {
        return 60
    }

    override func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = Section.allCases[indexPath.section]
        let cell = settingsCell(for: section, at: indexPath)
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

extension SettingsViewController {
    fileprivate func settingsCell(for section: Section, at indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        switch section {
        case .preferences:
            guard let switchCell = tableView.dequeueReusableCell(withIdentifier: String(describing: section.cellClass), for: indexPath) as? SettingsSwitchTableViewCell else {
                fatalError("Should be a SettingsSwitchCell")
            }
            let model = section.models[indexPath.row]
            if model.title == String.gpsLocalizedString {
                let isGPSEnabled = Preferences.gpsEnabled
                let gpsHandler: SettingsSwitchHandler = { [unowned self] settingsSwitch in
                    self.gpsCellAction(settingsSwitch)
                }
                switchCell.configure(isOn: isGPSEnabled, handler: gpsHandler)
                cell = switchCell
            } else if model.title == String.themeLocalizedString {
                let isNightModeEnabled = themeController.currentTheme == .dark ? true : false
                let nightModeHandler: (UISwitch) -> Void = { [unowned self] settingsSwitch in
                    self.darkModeCellAction(settingsSwitch)
                }
                switchCell.configure(isOn: isNightModeEnabled, handler: nightModeHandler)
                cell = switchCell
            } else {
                print("Title not found")
            }
            cell = switchCell
        case .info, .github:
            cell = tableView.dequeueReusableCell(withIdentifier: String(describing: section.cellClass), for: indexPath)
        }
        return cell
    }
}
