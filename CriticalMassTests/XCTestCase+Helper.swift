//
//  XCTestCase+Helper.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 5/12/19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

@testable import CriticalMaps
import XCTest

extension XCTestCase {
    func wait(interval: TimeInterval, completion: @escaping () -> Void) {
        Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { _ in
            completion()
        }
    }

    func execute(times: UInt, _ function: @autoclosure () -> Void) {
        (0 ..< times).forEach { _ in
            function()
        }
    }

    /// https://www.vadimbulavin.com/swift-asynchronous-unit-testing-with-busy-assertion-pattern/
    func expectToEventually(
        _ test: @autoclosure () -> Bool,
        timeout: TimeInterval = 1.0,
        message: String = ""
    ) {
        let runLoop = RunLoop.current
        let timeoutDate = Date(timeIntervalSinceNow: timeout)
        repeat {
            if test() {
                return
            }
            runLoop.run(until: Date(timeIntervalSinceNow: 0.01))
        } while Date().compare(timeoutDate) == .orderedAscending
        XCTFail(message)
    }
}
