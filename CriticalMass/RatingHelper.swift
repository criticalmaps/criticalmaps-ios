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
    public var daysUntilPrompt = 1
    public var usesUntilPrompt = 5

    private let userDefaults: UserDefaults
    private let ratingRequest: RatingRequest.Type
    private let currentVersion: String

    @available(iOS 10.3, *)
    public init(defaults: UserDefaults = UserDefaults.standard,
                ratingRequest: RatingRequest.Type = SKStoreReviewController.self,
                currentVersion: String = Bundle.main.versionNumber + Bundle.main.buildNumber) {
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
        usesCounter += 1
        rateIfNeeded()
    }

    private var lastDayUsed: Date? {
        set {
            userDefaults.set(newValue?.timeIntervalSince1970, forKey: #function)
        }
        get {
            guard userDefaults.value(forKey: #function) != nil else {
                return nil
            }
            let timeInterval = userDefaults.double(forKey: #function)
            return Date(timeIntervalSince1970: timeInterval)
        }
    }

    private var daysCounter: Int {
        set {
            userDefaults.set(newValue, forKey: #function)
        }
        get {
            userDefaults.integer(forKey: #function)
        }
    }

    private var usesCounter: Int {
        set {
            userDefaults.set(newValue, forKey: #function)
        }
        get {
            userDefaults.integer(forKey: #function)
        }
    }

    private var lastRatedVersion: String? {
        set {
            userDefaults.set(newValue, forKey: #function)
        }
        get {
            userDefaults.string(forKey: #function)
        }
    }

    private var shouldPromptRatingRequest: Bool {
        daysCounter >= daysUntilPrompt &&
            usesCounter >= usesUntilPrompt &&
            currentVersion != lastRatedVersion
    }

    private func increaseDaysCounterIfNeeded() {
        let now = Date()
        if let date = lastDayUsed {
            let components = Calendar.current.dateComponents([.day], from: date, to: now)
            daysCounter += components.day ?? 0
        }
        lastDayUsed = now
    }

    private func rateIfNeeded() {
        if shouldPromptRatingRequest {
            ratingRequest.requestReview()
            lastRatedVersion = currentVersion
        }
    }

    private func resetCounterIfneeded() {
        // we set the counter to 0 if we installed a new version
        if usesCounter != 0, lastRatedVersion == currentVersion {
            usesCounter = 0
            daysCounter = 0
        }
    }
}
