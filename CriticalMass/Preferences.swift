//
//  Preferences.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/19/19.
//

import Foundation

class ObservationModePreferenceStore: Switchable {
    private let defaultsKey = "observationMode"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    private func save(_ isEnabled: Bool) {
        defaults.set(isEnabled, forKey: defaultsKey)
        NotificationCenter.default.post(name: Notification.observationModeChanged, object: isEnabled)
    }

    private func load() -> Bool? {
        return defaults.bool(forKey: defaultsKey)
    }

    var isEnabled: Bool {
        get {
            return load() ?? false
        } set {
            save(newValue)
        }
    }
}

class Preferences {
    static var lastMessageReadTimeInterval: Double {
        get {
            return UserDefaults.standard.double(forKey: #function)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: #function)
        }
    }
}
