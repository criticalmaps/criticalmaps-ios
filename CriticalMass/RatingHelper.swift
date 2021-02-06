//
//  RatingHelper.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 5/24/19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation
import StoreKit

extension SKStoreReviewController: RatingRequest {}

public protocol RatingRequest {
    static func requestReview()
}

public protocol RatingStorage {
    var lastDayUsed: Date? { get set }
    var daysCounter: Int { get set }
    var usesCounter: Int { get set }
    var lastRatedVersion: String? { get set }
}

public class RatingHelper {
    private let daysUntilPrompt = 1
    private let usesUntilPrompt = 5

    private var ratingStorage: RatingStorage
    private let ratingRequest: RatingRequest.Type
    private let currentVersion: String

    public init(
        ratingStorage: RatingStorage,
        ratingRequest: RatingRequest.Type = SKStoreReviewController.self,
        currentVersion: String = Bundle.main.versionNumber + Bundle.main.buildNumber
    ) {
        self.ratingStorage = ratingStorage
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
        ratingStorage.usesCounter += 1
        rateIfNeeded()
    }

    private var shouldPromptRatingRequest: Bool {
        ratingStorage.daysCounter >= daysUntilPrompt &&
            ratingStorage.usesCounter >= usesUntilPrompt &&
            currentVersion != ratingStorage.lastRatedVersion
    }

    private func increaseDaysCounterIfNeeded() {
        let now = Date()
        if let date = ratingStorage.lastDayUsed,
           let day = Calendar.current.dateComponents([.day], from: date, to: now).day
        {
            ratingStorage.daysCounter += day
        }
        ratingStorage.lastDayUsed = now
    }

    private func rateIfNeeded() {
        if shouldPromptRatingRequest {
            ratingRequest.requestReview()
            ratingStorage.lastRatedVersion = currentVersion
        }
    }

    private func resetCounterIfneeded() {
        // we set the counter to 0 if we installed a new version
        if ratingStorage.usesCounter != 0, ratingStorage.lastRatedVersion == currentVersion {
            ratingStorage.usesCounter = 0
            ratingStorage.daysCounter = 0
        }
    }
}
