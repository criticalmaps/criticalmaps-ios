import Foundation
@testable import NextRideFeature
import Testing

/// Tests for the queryMonth helper function that determines which month to query for rides.
/// Critical Mass rides happen on the last Friday of each month.
/// The function should return the current month if today is on or before the last Friday,
/// or the next month if the last Friday has already passed.
@Suite(.serialized)
struct QueryMonthTests {
  @Test
  func `Returns current month when before last Friday of month`() throws {
    // Given: Friday, October 24, 2025 (last Friday is Oct 31)
    let friday = try #require(Calendar.current.date(from: DateComponents(
      year: 2025,
      month: 10,
      day: 24,
      hour: 12
    )))

    // When
    let result = queryMonth(for: { friday }, calendar: .current)

    // Then
    #expect(result == 10, "Should return October (10) when before last Friday of month")
  }

  /// Test the bug scenario: October 31, 2025 (the last Friday of October)
  /// Expected: Should return current month (October) because last Friday hasn't passed
  @Test
  func `Returns current month when today IS the last Friday`() throws {
    // Given: Friday, October 31, 2025 (IS the last Friday of October)
    // This is the exact scenario that triggered the bug report
    let lastFriday = try #require(Calendar.current.date(from: DateComponents(
      year: 2025,
      month: 10,
      day: 31,
      hour: 12
    )))

    // When
    let result = queryMonth(for: { lastFriday }, calendar: .current)

    // Then
    #expect(result == 10, "Should return October (10) when today IS the last Friday")
  }

  @Test
  func `Returns current month on last Friday regardless of time`() throws {
    // Given: Friday, October 31, 2025 (last Friday) at various times
    let morning = try #require(Calendar.current.date(from: DateComponents(
      year: 2025,
      month: 10,
      day: 31,
      hour: 9
    )))

    let afternoon = try #require(Calendar.current.date(from: DateComponents(
      year: 2025,
      month: 10,
      day: 31,
      hour: 15
    )))

    let evening = try #require(Calendar.current.date(from: DateComponents(
      year: 2025,
      month: 10,
      day: 31,
      hour: 21
    )))

    // When
    let morningResult = queryMonth(for: { morning }, calendar: .current)
    let afternoonResult = queryMonth(for: { afternoon }, calendar: .current)
    let eveningResult = queryMonth(for: { evening }, calendar: .current)

    // Then - All should return October (10) regardless of time of day
    #expect(morningResult == 10, "Morning of last Friday should query current month")
    #expect(afternoonResult == 10, "Afternoon of last Friday should query current month")
    #expect(eveningResult == 10, "Evening of last Friday should query current month")
  }

  @Test
  func `Returns next month when after last Friday`() throws {
    // Given: Saturday, November 1, 2025 (day after last Friday of October)
    let saturday = try #require(Calendar.current.date(from: DateComponents(
      year: 2025,
      month: 11,
      day: 1,
      hour: 12
    )))

    // When
    let result = queryMonth(for: { saturday }, calendar: .current)

    // Then - November's last Friday is Nov 28, so should query November
    #expect(result == 11, "Should return November when in November before its last Friday")
  }

  @Test
  func `Year boundary: December after last Friday returns January`() throws {
    // Given: Saturday, December 27, 2025 (after last Friday Dec 26)
    let afterLastFriday = try #require(Calendar.current.date(from: DateComponents(
      year: 2025,
      month: 12,
      day: 27,
      hour: 12
    )))

    // When
    let result = queryMonth(for: { afterLastFriday }, calendar: .current)

    // Then
    #expect(result == 1, "Should return January (1) when after last Friday of December")
  }

  @Test
  func `First day of month returns current month`() throws {
    // Given: Tuesday, October 1, 2025 (first day of month, before last Friday)
    let firstDay = try #require(Calendar.current.date(from: DateComponents(
      year: 2025,
      month: 10,
      day: 1,
      hour: 12
    )))

    // When
    let result = queryMonth(for: { firstDay }, calendar: .current)

    // Then
    #expect(result == 10, "Should return October when on first day before last Friday")
  }

  @Test
  func `Year boundary: December last Friday returns December`() throws {
    // Given: Friday, December 26, 2025 (IS the last Friday of December)
    let lastFridayDec = try #require(Calendar.current.date(from: DateComponents(
      year: 2025,
      month: 12,
      day: 26,
      hour: 12
    )))

    // When
    let result = queryMonth(for: { lastFridayDec }, calendar: .current)

    // Then
    #expect(result == 12, "Should return December when on last Friday of December")
  }

  @Test
  func `Month with 5 Fridays: handles last Friday correctly`() throws {
    // Given: October 2025 has 5 Fridays (3, 10, 17, 24, 31)
    // Test the 4th Friday
    let fourthFriday = try #require(Calendar.current.date(from: DateComponents(
      year: 2025,
      month: 10,
      day: 24,
      hour: 12
    )))

    // When
    let result = queryMonth(for: { fourthFriday }, calendar: .current)

    // Then - Should still return October because last Friday (31st) hasn't passed
    #expect(result == 10, "Should return current month when on 4th Friday of 5-Friday month")
  }
}
