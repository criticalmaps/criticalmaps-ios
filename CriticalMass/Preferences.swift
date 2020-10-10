//
//  Preferences.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/19/19.
//

import Foundation

protocol ObservationModePreference {
    var observationMode: Bool { get set }
}

class ObservationModePreferenceStore: Toggleable {
    private var store: ObservationModePreference

    init(store: ObservationModePreference) {
        self.store = store
    }

    var isEnabled: Bool {
        get { store.observationMode }
        set {
            store.observationMode = newValue
            NotificationCenter.default.post(name: .observationModeChanged, object: newValue)
        }
    }
}
