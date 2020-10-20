//
//  FormatDisplay.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 07.04.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation

private extension DateComponents {
    var dateComponentFromBiggestComponent: DateComponents {
        if let month = month,
            month != 0
        {
            return DateComponents(calendar: calendar, month: month)
        } else if let day = day,
            day != 0
        {
            return DateComponents(calendar: calendar, day: day)
        } else if let hour = hour,
            hour != 0
        {
            return DateComponents(calendar: calendar, hour: hour)
        } else if let minute = minute,
            minute != 0
        {
            return DateComponents(calendar: calendar, minute: minute)
        } else {
            return DateComponents(calendar: calendar, second: second)
        }
    }
}

enum FormatDisplay {
    static func dateString(
        for tweet: Tweet,
        currentDate: Date = Date(),
        calendar: Calendar = .current
    ) -> String? {
        let components = calendar.dateComponents(
            [.second, .minute, .hour, .day, .month],
            from: tweet.createdAt,
            to: currentDate
        ).dateComponentFromBiggestComponent

        let formatter = DateComponentsFormatter.tweetDateFormatter(calendar)
        return formatter.string(from: components)?.uppercased()
    }

    static func hoursAndMinutesDateString(from message: ChatMessage, calendar: Calendar = .current) -> String {
        let date = Date(timeIntervalSince1970: message.timestamp)
        let formatter = DateFormatter.localeShortTimeFormatter
        formatter.calendar = calendar
        formatter.timeZone = calendar.timeZone
        return formatter.string(from: date)
    }
}
