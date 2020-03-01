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
            return DateComponents(calendar: calendar, month: month)
        } else if let day = day,
            day != 0 {
            return DateComponents(calendar: calendar, day: day)
        } else if let hour = hour,
            hour != 0 {
            return DateComponents(calendar: calendar, hour: hour)
        } else if let minute = minute,
            minute != 0 {
            return DateComponents(calendar: calendar, minute: minute)
        } else {
            return DateComponents(calendar: calendar, second: second)
        }
    }
}

enum FormatDisplay {
    // inject current date to be able to keep the same time difference between tweet date and current date
    static var currentDate = Date()

    static func dateString(for tweet: Tweet) -> String? {
        let components = Calendar.current.dateComponents([.minute, .hour, .day, .month], from: tweet.created_at, to: currentDate).dateomponentFromBiggestComponent
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
