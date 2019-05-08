//
//  FormatDisplay.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 07.04.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation

private extension DateComponents {
    var dateomponentFromBiggestComponent: DateComponents {
        if let month = month,
            month != 0 {
            return DateComponents(calendar: calendar, timeZone: nil, era: nil, year: nil, month: month, day: nil, hour: nil, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        } else if let day = day,
            day != 0 {
            return DateComponents(calendar: calendar, timeZone: nil, era: nil, year: nil, month: nil, day: day, hour: nil, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        } else if let hour = hour,
            hour != 0 {
            return DateComponents(calendar: calendar, timeZone: nil, era: nil, year: nil, month: nil, day: nil, hour: hour, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        } else if let minute = minute,
            minute != 0 {
            return DateComponents(calendar: calendar, timeZone: nil, era: nil, year: nil, month: nil, day: nil, hour: nil, minute: minute, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        } else {
            return DateComponents(calendar: calendar, timeZone: nil, era: nil, year: nil, month: nil, day: nil, hour: nil, minute: nil, second: second, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        }
    }
}

enum FormatDisplay {
    static func dateString(for tweet: Tweet) -> String? {
        let components = Calendar.current.dateComponents([.minute, .hour, .day, .month], from: tweet.created_at, to: Date()).dateomponentFromBiggestComponent
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .month, .second]
        formatter.unitsStyle = .short
        formatter.maximumUnitCount = 1
        return formatter.string(from: components)
    }

    static func hoursAndMinutesDateString(from message: ChatMessage) -> String {
        let date = Date(timeIntervalSince1970: message.timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
