//
// Created for CriticalMaps in 2020

import UIKit

final class EventSettingsViewController: SettingsViewController {
    private var rideEventSettingsStore: RideEventSettingsStore

    init(
        controllerTitle: String,
        sections: [SettingsSection],
        themeController: ThemeController,
        rideEventSettingsStore: RideEventSettingsStore
    ) {
        self.rideEventSettingsStore = rideEventSettingsStore
        super.init(
            controllerTitle: controllerTitle,
            sections: sections,
            themeController: themeController
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

    override func numberOfSections(in _: UITableView) -> Int {
        rideEventSettingsStore.rideEventSettings.isEnabled ? sections.count : 1
    }

    override func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let settingsSection = sections[section]
        return rideEventSettingsStore.rideEventSettings.isEnabled
            ? settingsSection.title != nil ? 35.0 : CGFloat.leastNonzeroMagnitude
            : CGFloat.leastNonzeroMagnitude
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.reloadData() }
        if indexPath.section == 0 {
            rideEventSettingsStore.rideEventSettings.isEnabled.toggle()
        } else if indexPath.section == 1 {
            rideEventSettingsStore.rideEventSettings.typeSettings[indexPath.row].isEnabled.toggle()
        } else if indexPath.section == 2 {
            let selectedRadius = Ride.eventRadii[indexPath.row]
            rideEventSettingsStore.rideEventSettings.radiusSettings.radius = selectedRadius
        } else {}
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

    override func configure(_ cell: UITableViewCell, for section: SettingsSection, indexPath: IndexPath) {
        switch section {
        default:
            let model = section.models[indexPath.row]
            if let switchCell = cell as? SettingsSwitchTableViewCell, case let .switch(switchableType) = model.action {
                if switchableType == RideEventSettings.self {
                    switchCell.switchControl.isOn = rideEventSettingsStore.rideEventSettings.isEnabled
                    switchCell.actionCallBack = { [weak self] isOn in
                        guard let self = self else { return }
                        self.rideEventSettingsStore.rideEventSettings.isEnabled = isOn
                        self.tableView.reloadData()
                    }
                } else {
                    assertionFailure("Switchable not found")
                }
            } else if let checkCell = cell as? SettingsCheckTableViewCell, case let .check(checkableType) = model.action {
                if checkableType == RideEventSettings.RideEventTypeSetting.self {
                    let toggleable = rideEventSettingsStore.rideEventSettings.typeSettings[indexPath.row]
                    checkCell.configure(switchable: toggleable)
                } else if checkableType == RideEventSettings.RideEventRadius.self {
                    checkCell.accessoryType = model.title!.prefix(2) == String(describing: rideEventSettingsStore.rideEventSettings.radiusSettings.radius) ? .checkmark : .none
                } else {
                    assertionFailure("Checkable not found")
                }
            } else {}
            cell.textLabel?.text = model.title
        }
    }
}
