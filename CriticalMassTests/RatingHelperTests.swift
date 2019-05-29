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
    var userdefaults = UserDefaults(suiteName: "CriticalMaps-Tests")!

    override func setUp() {
        super.setUp()
        ratingHelper = RatingHelper(defaults: userdefaults, ratingRequest: MockRatingRequest.self)
    }

    override func tearDown() {
        ratingHelper = nil
        MockRatingRequest.requestCounter = 0
        userdefaults.removePersistentDomain(forName: "CriticalMaps-Tests")
    }

    func testNoRequestOnFirstLaunch() {
        ratingHelper.daysUntilPrompt = 1
        ratingHelper.usesUntilPrompt = 5

        ratingHelper.onLaunch()

        XCTAssertEqual(MockRatingRequest.requestCounter, 0)
    }

    func testNoRequestAfterFiveLaunchesOnSameDay() {
        ratingHelper.daysUntilPrompt = 1
        ratingHelper.usesUntilPrompt = 5

        execute(times: 5, ratingHelper.onLaunch())

        XCTAssertEqual(MockRatingRequest.requestCounter, 0)
    }

    func testRequestAfterFiveLaunchesOnNextDay() {
        ratingHelper.daysUntilPrompt = 1
        ratingHelper.usesUntilPrompt = 5

        // mock app used yesterday
        let yesterday = Date(timeInterval: -86400, since: Date()).timeIntervalSince1970
        userdefaults.set(yesterday, forKey: "lastDayUsed")

        execute(times: 5, ratingHelper.onLaunch())
        XCTAssertEqual(MockRatingRequest.requestCounter, 1)
    }

    func testNoRequestIfVersionAlreadyRated() {
        ratingHelper.daysUntilPrompt = 1
        ratingHelper.usesUntilPrompt = 5

        // mock app used yesterday
        let yesterday = Date(timeInterval: -86400, since: Date()).timeIntervalSince1970
        userdefaults.set(yesterday, forKey: "lastDayUsed")

        // mock version already rated
        userdefaults.set(Bundle.main.versionNumber + Bundle.main.buildNumber, forKey: "lastRatedVersion")

        execute(times: 5, ratingHelper.onLaunch())
        XCTAssertEqual(MockRatingRequest.requestCounter, 0)
    }

    func testRatingRequestAfterInstallingNewVersion() {
        ratingHelper.daysUntilPrompt = 1
        ratingHelper.usesUntilPrompt = 5

        // mock app used yesterday
        let yesterday = Date(timeInterval: -86400, since: Date()).timeIntervalSince1970
        userdefaults.set(yesterday, forKey: "lastDayUsed")

        // mock version already rated
        userdefaults.set(Bundle.main.versionNumber + Bundle.main.buildNumber, forKey: "lastRatedVersion")

        execute(times: 5, ratingHelper.onLaunch())
        XCTAssertEqual(MockRatingRequest.requestCounter, 0)

        // mock app used yesterday
        userdefaults.set(yesterday, forKey: "lastDayUsed")

        // mock new version  installed
        ratingHelper = RatingHelper(defaults: userdefaults, ratingRequest: MockRatingRequest.self, currentVersion: "MockVersion")
        execute(times: 5, ratingHelper.onLaunch())
        XCTAssertEqual(MockRatingRequest.requestCounter, 1)
    }
}
