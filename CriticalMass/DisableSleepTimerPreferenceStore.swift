//
//  DisableSleepTimerPreferenceStore.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 6/23/19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation

class DisableSleepTimerPreferenceStore: Switchable {
    private let defaultsKey = "disableSleepTimer"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    public func updateTimerPreference() {
        UIApplication.shared.isIdleTimerDisabled = isEnabled
    }

    private func save(_ isEnabled: Bool) {
        defaults.set(isEnabled, forKey: defaultsKey)
        updateTimerPreference()
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
