//
//  CriticalMaps

import Foundation
import UIKit

extension UserDefaults {
    public static func makeClearedInstance(
        for functionName: StaticString = #function,
        inFile fileName: StaticString = #file
    ) -> UserDefaults {
        let className = "\(fileName)".split(separator: ".")[0]
        let testName = "\(functionName)".split(separator: "(")[0]
        let suiteName = "de.pokuslabs.criticalmassberlin.test.\(className).\(testName)"

        let defaults = self.init(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        return defaults
    }
}

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
    }

    public var username: String {
        set { set(newValue, forKey: Keys.userNameKey) }
        get { string(forKey: Keys.userNameKey) ?? UIDevice.current.name }
    }

    public var observationMode: Bool {
        set { set(newValue, forKey: Keys.observationModeKey) }
        get { bool(forKey: Keys.observationModeKey) }
    }

    public var lastMessageReadTimeInterval: Double {
        set { set(newValue, forKey: Keys.lastMessageReadTimeIntervalKey) }
        get { double(forKey: Keys.lastMessageReadTimeIntervalKey) }
    }

    public var theme: Int {
        set { set(newValue, forKey: Keys.themeKey) }
        get { integer(forKey: Keys.themeKey) }
    }

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
