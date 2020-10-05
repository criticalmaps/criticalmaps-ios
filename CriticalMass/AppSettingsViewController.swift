//
// Created for CriticalMaps in 2020

import Foundation
import UIKit

final class AppSettingsViewController: SettingsViewController {
    private let dataStore: DataStore
    private let idProvider: IDProvider
    private let observationModePreferenceStore: ObservationModePreferenceStore
    private let rideEventSettings: RideEventSettingsStore

    init(
        controllerTitle: String,
        sections: [SettingsSection],
        themeController: ThemeController,
        dataStore: DataStore,
        idProvider: IDProvider,
        observationModePreferenceStore: ObservationModePreferenceStore,
        rideEventSettings: RideEventSettingsStore
    ) {
        self.dataStore = dataStore
        self.idProvider = idProvider
        self.observationModePreferenceStore = observationModePreferenceStore
        self.rideEventSettings = rideEventSettings
        super.init(
            controllerTitle: controllerTitle,
            sections: sections,
            themeController: themeController
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSettingsFooter()
    }

    private func configureSettingsFooter() {
        let settingsFooter = SettingsFooterView.fromNib()
        settingsFooter.buildNumberLabel.text = "Build \(Bundle.main.buildNumber)"
        settingsFooter.versionNumberLabel.text = "Critical Maps \(Bundle.main.versionNumber)"
        tableView.tableFooterView = settingsFooter
    }

    override func createViewController(type: UIViewController.Type) -> UIViewController {
        // Perform dependency injection if needed
        switch type {
        case _ as ManageFriendsViewController.Type:
            return ManageFriendsViewController(dataStore: dataStore, idProvider: idProvider)
        case _ as ThemeSelectionViewController.Type:
            return ThemeSelectionViewController(themeController: themeController)
        case _ as EventSettingsViewController.Type:
            return EventSettingsViewController(
                controllerTitle: "Event Settings",
                sections: SettingsSection.eventSettings,
                themeController: themeController,
                rideEventSettingsStore: rideEventSettings
            )
        default:
            return .init()
        }
    }

    override func configure(_ cell: UITableViewCell, for section: SettingsSection, indexPath: IndexPath) {
        switch section {
        case let .projectLinks(_, configurations, _):
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
                case let .switch(switchableType) = model.action
            {
                if switchableType == ObservationModePreferenceStore.self {
                    switchCell.configure(switchable: observationModePreferenceStore)
                } else if switchableType == ThemeController.self {
                    switchCell.configure(switchable: themeController)
                } else {
                    assertionFailure("Switchable not found")
                }
            }
            cell.accessibilityIdentifier = model.accessibilityIdentifier
            cell.textLabel?.text = model.title
            cell.detailTextLabel?.text = model.subtitle
            cell.accessoryType = .disclosureIndicator
        }
    }
}
