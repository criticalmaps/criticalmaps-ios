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
    var userdefaults: UserDefaults!

    override func setUp() {
        super.setUp()
        userdefaults = .makeClearedInstance()
        ratingHelper = RatingHelper(defaults: userdefaults, ratingRequest: MockRatingRequest.self)
    }

    override func tearDown() {
        ratingHelper = nil
        MockRatingRequest.requestCounter = 0
        super.tearDown()
    }

    func testNoRequestOnFirstLaunch() {
        ratingHelper.onLaunch()

        XCTAssertEqual(MockRatingRequest.requestCounter, 0)
    }

    func testNoRequestAfterFiveLaunchesOnSameDay() {
        execute(times: 5, ratingHelper.onLaunch())

        XCTAssertEqual(MockRatingRequest.requestCounter, 0)
    }

    func testRequestAfterFiveLaunchesOnNextDay() {
        // mock app used yesterday
        userdefaults.lastDayUsed = .yesterday

        execute(times: 5, ratingHelper.onLaunch())
        XCTAssertEqual(MockRatingRequest.requestCounter, 1)
    }

    func testNoRequestIfVersionAlreadyRated() {
        // mock app used yesterday
        userdefaults.lastDayUsed = .yesterday

        // mock version already rated
        userdefaults.lastRatedVersion = Bundle.main.versionNumber + Bundle.main.buildNumber

        execute(times: 5, ratingHelper.onLaunch())
        XCTAssertEqual(MockRatingRequest.requestCounter, 0)
    }

    func testRatingRequestAfterInstallingNewVersion() {
        // mock app used yesterday
        userdefaults.lastDayUsed = .yesterday

        // mock version already rated
        userdefaults.lastRatedVersion = Bundle.main.versionNumber + Bundle.main.buildNumber

        execute(times: 5, ratingHelper.onLaunch())
        XCTAssertEqual(MockRatingRequest.requestCounter, 0)

        // mock app used yesterday
        userdefaults.lastDayUsed = .yesterday

        // mock new version  installed
        ratingHelper = RatingHelper(
            defaults: userdefaults,
            ratingRequest: MockRatingRequest.self,
            currentVersion: "MockVersion"
        )
        execute(times: 5, ratingHelper.onLaunch())
        XCTAssertEqual(MockRatingRequest.requestCounter, 1)
    }
}
