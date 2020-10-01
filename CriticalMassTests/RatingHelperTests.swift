//
//  RatingHelperTests.swift
//  CriticalMapsTests
//
//  Created by Leonard Thomas on 5/24/19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import CriticalMaps
import XCTest

class MockRatingRequest: RatingRequest {
    static var requestCounter = 0

    static func requestReview() {
        requestCounter += 1
    }
}

class RatingHelperTests: XCTestCase {
    var ratingHelper: RatingHelper!
    var ratingsStorage: RatingStorage!

    override func tearDown() {
        ratingHelper = nil
        ratingsStorage = nil
        MockRatingRequest.requestCounter = 0
        super.tearDown()
    }

    func testNoRequestOnFirstLaunch() {
        ratingsStorage = RatingStorageMock()
        ratingHelper = RatingHelper(
            ratingStorage: ratingsStorage,
            ratingRequest: MockRatingRequest.self
        )
        ratingHelper.onLaunch()

        XCTAssertEqual(MockRatingRequest.requestCounter, 0)
    }

    func testNoRequestAfterFiveLaunchesOnSameDay() {
        ratingsStorage = RatingStorageMock()
        ratingHelper = RatingHelper(
            ratingStorage: ratingsStorage,
            ratingRequest: MockRatingRequest.self
        )
        execute(times: 5, ratingHelper.onLaunch())

        XCTAssertEqual(MockRatingRequest.requestCounter, 0)
    }

    func testRequestAfterFiveLaunchesOnNextDay() {
        // mock app used yesterday
        ratingsStorage = RatingStorageMock()
        ratingsStorage.lastDayUsed = .yesterday()
        ratingHelper = RatingHelper(
            ratingStorage: ratingsStorage,
            ratingRequest: MockRatingRequest.self
        )

        execute(times: 5, ratingHelper.onLaunch())
        XCTAssertEqual(MockRatingRequest.requestCounter, 1)
    }

    func testNoRequestIfVersionAlreadyRated() {
        // mock app used yesterday
        ratingsStorage = RatingStorageMock()
        ratingsStorage.lastDayUsed = .yesterday()
        ratingsStorage.lastRatedVersion = Bundle.main.versionNumber + Bundle.main.buildNumber
        ratingHelper = RatingHelper(
            ratingStorage: ratingsStorage,
            ratingRequest: MockRatingRequest.self
        )

        execute(times: 5, ratingHelper.onLaunch())
        XCTAssertEqual(MockRatingRequest.requestCounter, 0)
    }

    func testRatingRequestAfterInstallingNewVersion() {
        ratingsStorage = RatingStorageMock()
        // mock app used yesterday
        ratingsStorage.lastDayUsed = .yesterday()
        // mock version already rated
        ratingsStorage.lastRatedVersion = Bundle.main.versionNumber + Bundle.main.buildNumber

        ratingHelper = RatingHelper(
            ratingStorage: ratingsStorage,
            ratingRequest: MockRatingRequest.self
        )

        execute(times: 5, ratingHelper.onLaunch())
        XCTAssertEqual(MockRatingRequest.requestCounter, 0)

        // mock app used yesterday
        ratingsStorage.lastDayUsed = .yesterday()

        // mock new version  installed
        ratingHelper = RatingHelper(
            ratingStorage: ratingsStorage,
            ratingRequest: MockRatingRequest.self,
            currentVersion: "MockVersion"
        )
        execute(times: 5, ratingHelper.onLaunch())
        XCTAssertEqual(MockRatingRequest.requestCounter, 1)
    }
}

private struct RatingStorageMock: RatingStorage {
    var lastDayUsed: Date?
    var daysCounter: Int = 0
    var usesCounter: Int = 0
    var lastRatedVersion: String?
}
