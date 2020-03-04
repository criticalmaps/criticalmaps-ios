//
// Created for CriticalMaps in 2020

@testable import CriticalMaps
import XCTest

class StringAdditionsTests: XCTestCase {
    func test_removeDatePatternShouldRemovePattern1() {
        // given
        let title = "Critical Mass Berlin"
        let date = "28.02.2020"
        let titleWithDate = "\(title) \(date)"
        // when
        let strippedTitle = titleWithDate.removedDatePattern()
        // then
        XCTAssertEqual(strippedTitle, title)
    }

    func test_removeDatePatternShouldRemovePattern2() {
        // given
        let title = "Critical Mass Berlin"
        let date = "28/02/2020"
        let titleWithDate = "\(title) \(date)"
        // when
        let strippedTitle = titleWithDate.removedDatePattern()
        // then
        XCTAssertEqual(strippedTitle, title)
    }

    func test_removeDatePatternShouldNotRemovePattern1() {
        // given
        let title = "Critical Mass Berlin"
        let date = "02/28/20"
        let titleWithDate = "\(title) \(date)"
        // when
        let strippedTitle = titleWithDate.removedDatePattern()
        // then
        XCTAssertNotEqual(strippedTitle, title)
    }

    func test_removeDatePatternShouldNotRemovePattern2() {
        // given
        let title = "Critical Mass Berlin"
        let pattern = "Special Edition"
        let titleWithDate = "\(title) \(pattern)"
        // when
        let strippedTitle = titleWithDate.removedDatePattern()
        // then
        XCTAssertNotEqual(strippedTitle, title)
    }
}
