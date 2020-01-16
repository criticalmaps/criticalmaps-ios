//
//  CriticalMaps

import Foundation

public extension Date {
    static var yesterday: Date { Date(timeInterval: -86400, since: .now) }
    static var now: Date { Date() }
}
