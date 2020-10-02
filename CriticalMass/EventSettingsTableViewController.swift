//
// Created for CriticalMaps in 2020

import UIKit

struct RideEventSettings {
    var typeSettings: [RideEventTypeSetting]
}

final class EventSettingsViewController: SettingsViewController {
    private var rideEventSettings: RideEventSettings

    init(
        controllerTitle: String,
        sections: [SettingsSection],
        themeController: ThemeController,
        rideEventSettings: RideEventSettings
    ) {
        self.rideEventSettings = rideEventSettings
        super.init(
            controllerTitle: controllerTitle,
            sections: sections,
            themeController: themeController
        )
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1 else {
            super.tableView(tableView, didSelectRowAt: indexPath)
            return
        }
        rideEventSettings.typeSettings[indexPath.row].isEnabled.toggle()
        tableView.reloadData()
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
                if switchableType == Test.self {
                    switchCell.configure(switchable: Test())
                } else {
                    assertionFailure("Switchable not found")
                }
            } else if let checkCell = cell as? SettingsCheckTableViewCell, case let .check(checkableType) = model.action {
                if checkableType == RideEventTypeSetting.self {
                    let toggleable = rideEventSettings.typeSettings[indexPath.row]
                    checkCell.configure(switchable: toggleable)
                    checkCell.textLabel?.text = model.title
                } else {
                    assertionFailure("Switchable not found")
                }
            } else {
                cell.textLabel?.text = model.title
            }
        }
    }
}
