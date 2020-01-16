//
//  Preferences.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/19/19.
//

import Foundation
import UIKit

class ObservationModePreferenceStore: Switchable {
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var isEnabled: Bool {
        get { defaults.observationMode }
        set {
            defaults.observationMode = newValue
            NotificationCenter.default.post(name: Notification.observationModeChanged, object: newValue)
        }
    }
}
