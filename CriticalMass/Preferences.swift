//
//  Preferences.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/19/19.
//

import Foundation

@objc(PLPreferences)
class Preferences: NSObject {
    @objc static var gpsEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: #function)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: #function)
        }
    }
}
