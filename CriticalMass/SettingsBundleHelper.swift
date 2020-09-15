//
// Created for CriticalMaps in 2020

import Foundation

class SettingsBundleHelper {
    enum SettingsBundleKeys {
        static let SearchRadiusSetting = "searchRadiusSetting"
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults) {
        self.defaults = defaults
    }

    func checkAndExecuteSettings() {
        defaults.nextRideRadius = defaults.integer(forKey: SettingsBundleKeys.SearchRadiusSetting)
    }
}
