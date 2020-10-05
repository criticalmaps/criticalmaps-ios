//
//  CriticalMaps

import Foundation
import UIKit

extension UserDefaults {
    private enum Keys {
        static let observationModeKey = "observationMode"
        static let lastMessageReadTimeIntervalKey = "lastMessageReadTimeInterval"
        static let themeKey = "theme"
        static let lastDayUsedKey = "lastDayUsed"
        static let daysCounterKey = "daysCounter"
        static let usesCounterKey = "usesCounter"
        static let lastRatedVersionKey = "lastRatedVersion"
        static let userNameKey = "username"
        static let nextRideRadius = "nextRideRadius"
        static let rideEventSettings = "rideEventSettings"
    }

    // TODO: Move default value to PreferenceStore
    /// - Returns: Searchradius in Kilometer. Default value is 20
    public var nextRideRadius: Int {
        set { set(newValue, forKey: Keys.nextRideRadius) }
        get {
            let radius = integer(forKey: Keys.nextRideRadius)
            guard radius != 0 else { return 20 } // Returns a default radius of 20 Kilometer to search for events
            return radius
        }
    }
}

extension UserDefaults: RideEventSettingsStore {
    var rideEventSettings: RideEventSettings {
        set {
            let data = try? newValue.encoded()
            setValue(data, forKey: Keys.rideEventSettings)
        }
        get {
            let defaultSettings = RideEventSettings(
                isEnabled: true,
                typeSettings: .all,
                radiusSettings: RideEventSettings.RideEventRadius(radius: nextRideRadius, isEnabled: true)
            )
            guard let data = object(forKey: Keys.rideEventSettings) as? Data else {
                // Return defaultValue when no data in UserDefaults
                return defaultSettings
            }
            return (try? data.decoded()) ?? defaultSettings
        }
    }
}

extension UserDefaults: ThemeStore {
    public var theme: String? {
        set { set(newValue, forKey: Keys.themeKey) }
        get { string(forKey: Keys.themeKey) }
    }
}

extension UserDefaults: RatingStorage {
    public var lastDayUsed: Date? {
        set { set(newValue, forKey: Keys.lastDayUsedKey) }
        get { object(forKey: Keys.lastDayUsedKey) as? Date }
    }

    public var daysCounter: Int {
        set { set(newValue, forKey: Keys.daysCounterKey) }
        get { integer(forKey: Keys.daysCounterKey) }
    }

    public var usesCounter: Int {
        set { set(newValue, forKey: Keys.usesCounterKey) }
        get { integer(forKey: Keys.usesCounterKey) }
    }

    public var lastRatedVersion: String? {
        set { set(newValue, forKey: Keys.lastRatedVersionKey) }
        get { string(forKey: Keys.lastRatedVersionKey) }
    }
}

extension UserDefaults: ChatMessageStore {
    public var lastMessageReadTimeInterval: Double {
        set { set(newValue, forKey: Keys.lastMessageReadTimeIntervalKey) }
        get { double(forKey: Keys.lastMessageReadTimeIntervalKey) }
    }
}

extension UserDefaults: FriendsStorage {
    public var username: String? {
        set { set(newValue, forKey: Keys.userNameKey) }
        get { string(forKey: Keys.userNameKey) }
    }
}

extension UserDefaults: ObservationModePreference {
    public var observationMode: Bool {
        set { set(newValue, forKey: Keys.observationModeKey) }
        get { bool(forKey: Keys.observationModeKey) }
    }
}
