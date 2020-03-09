//
// Created for CriticalMaps in 2020

@testable import CriticalMaps
import XCTest

class FormatDisplayTests: XCTestCase {
    // Sunday, September 13, 2020 2:26:40 PM GMT+02:00 DST
    let date = Date(timeIntervalSince1970: 1_600_000_000)

    let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Europe/Berlin")!
        return calendar
    }()

    lazy var tweet = {
        Tweet(text: "Hello World", created_at: self.date, user: TwitterUser(name: "Jan  Ullrich", screen_name: "", profile_image_url_https: ""), id_str: "1")
    }()

    func testFormatTweetSeconds() {
        let currentDate = generateDate(from: date, travelInterval: .seconds(49))

        let expectedDateString = "49 sec"
        let dateString = FormatDisplay.dateString(for: tweet, currentDate: currentDate, calendar: calendar)
        XCTAssertEqual(dateString, expectedDateString)
    }

    func testFormatTweetMinutes() {
        let currentDate = generateDate(from: date, travelInterval: .minutes(3))

        let expectedDateString = "3 min"
        let dateString = FormatDisplay.dateString(for: tweet, currentDate: currentDate, calendar: calendar)
        XCTAssertEqual(dateString, expectedDateString)
    }

    func testFormatTweetHours() {
        let currentDate = generateDate(from: date, travelInterval: .hours(9))

        let expectedDateString = "9 hr"
        let dateString = FormatDisplay.dateString(for: tweet, currentDate: currentDate, calendar: calendar)
        XCTAssertEqual(dateString, expectedDateString)
    }

    func testFormatTweetDays() {
        let currentDate = generateDate(from: date, travelInterval: .days(20))

        let expectedDateString = "20 days"
        let dateString = FormatDisplay.dateString(for: tweet, currentDate: currentDate, calendar: calendar)
        XCTAssertEqual(dateString, expectedDateString)
    }

    func testFormatTweetMonths() {
        let currentDate = generateDate(from: date, travelInterval: .months(2))

        let expectedDateString = "2 mths"
        let dateString = FormatDisplay.dateString(for: tweet, currentDate: currentDate, calendar: calendar)
        XCTAssertEqual(dateString, expectedDateString)
    }

    func testFormatChatMessage() {
        let message = ChatMessage(message: "Hello World", timestamp: date.timeIntervalSince1970)
        let expectedDateString = "14:26"
        let dateString = FormatDisplay.hoursAndMinutesDateString(from: message, calendar: calendar)
        XCTAssertEqual(dateString, expectedDateString)
    }

    private func generateDate(from date: Date, travelInterval: TimeTraveler.TravelInterval) -> Date {
        TimeTraveler(date)
            .travelTime(by: travelInterval)
            .generateDate()
    }
}
