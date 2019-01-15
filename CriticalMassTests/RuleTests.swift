//
//  RuleTests.swift
//  CriticalMapsTests
//
//  Created by Leonard Thomas on 1/15/19.
//

import XCTest
@testable import CriticalMaps

class RuleTests: XCTestCase {

    func testLocalizedTitle() {
        Rule.allCases.forEach { rule in
            XCTAssertNotEqual(rule.title, "rules.title.\(rule.rawValue)")
        }
    }
    
    func testLocalizedText() {
        Rule.allCases.forEach { rule in
            XCTAssertNotEqual(rule.text, "rules.text.\(rule.rawValue)")
        }
    }
    
    func testExistingArtwork() {
        Rule.allCases.forEach { rule in
            XCTAssertNotNil(rule.artwork)
        }
    }

}
