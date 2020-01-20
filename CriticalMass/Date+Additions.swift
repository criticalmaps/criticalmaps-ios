//
//  CriticalMaps

import Foundation

public extension Date {
    static var yesterday: Date {
        let dateComponents = DateComponents(day: -1)
        return Calendar.current.date(byAdding: dateComponents, to: .now)!
    }

    static var now: Date { Date() }

    /// Get a component representation of todays Date as Int.
    /// - Parameter keyPath:
    /// - Returns: DateComponent representation as Int. Returns 0 when component is not available
    static func getCurrent(_ keyPath: KeyPath<DateComponents, Int?>) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: .now)
        let component = components[keyPath: keyPath] ?? 0
        return component
    }
}
