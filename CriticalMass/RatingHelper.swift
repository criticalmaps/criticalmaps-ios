//
//  RatingHelper.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 5/24/19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation
import StoreKit

@available(iOS 10.3, *)
extension SKStoreReviewController: RatingRequest {}

public protocol RatingRequest {
    static func requestReview()
}

public class RatingHelper {
    private let daysUntilPrompt = 1
    private let usesUntilPrompt = 5

    private let userDefaults: UserDefaults
    private let ratingRequest: RatingRequest.Type
    private let currentVersion: String

    @available(iOS 10.3, *)
    public init(
        defaults: UserDefaults = .standard,
        ratingRequest: RatingRequest.Type = SKStoreReviewController.self,
        currentVersion: String = Bundle.main.versionNumber + Bundle.main.buildNumber
    ) {
        userDefaults = defaults
        self.ratingRequest = ratingRequest
        self.currentVersion = currentVersion
    }

    public func onLaunch() {
        onEvent()
    }

    public func onEnterForeground() {
        onEvent()
    }

    private func onEvent() {
        resetCounterIfneeded()
        increaseDaysCounterIfNeeded()
        userDefaults.usesCounter += 1
        rateIfNeeded()
    }

    private var shouldPromptRatingRequest: Bool {
        userDefaults.daysCounter >= daysUntilPrompt &&
            userDefaults.usesCounter >= usesUntilPrompt &&
            currentVersion != userDefaults.lastRatedVersion
    }

    private func increaseDaysCounterIfNeeded() {
        let now = Date()
        if let date = userDefaults.lastDayUsed,
            let day = Calendar.current.dateComponents([.day], from: date, to: now).day {
            userDefaults.daysCounter += day
        }
        userDefaults.lastDayUsed = now
    }

    private func rateIfNeeded() {
        if shouldPromptRatingRequest {
            ratingRequest.requestReview()
            userDefaults.lastRatedVersion = currentVersion
        }
    }

    private func resetCounterIfneeded() {
        // we set the counter to 0 if we installed a new version
        if userDefaults.usesCounter != 0, userDefaults.lastRatedVersion == currentVersion {
            userDefaults.usesCounter = 0
            userDefaults.daysCounter = 0
        }
    }
}
