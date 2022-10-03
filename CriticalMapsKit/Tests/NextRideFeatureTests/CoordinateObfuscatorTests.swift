import CoreLocation
import NextRideFeature
import SharedModels
import XCTest

final class CoordinateObfuscatorTests: XCTestCase {
  var sut: CoordinateObfuscator!
  
  override func setUp() {
    super.setUp()
    sut = .live
  }
  
  func test_ObfuscatorShouldReturnAlteredCoordinate() {
    // given
    let alexanderPlatz = Coordinate.TestData.alexanderPlatz
    // when
    let alteredCoordinate = sut.obfuscate(alexanderPlatz, .thirdDecimal)
    // then
    XCTAssertNotEqual(alexanderPlatz, alteredCoordinate)
  }
  
  func test_ObfuscatorShouldReturnCoordinateWithAlteredFirstDecimal() {
    // given
    let alexanderPlatz = Coordinate.TestData.alexanderPlatz
    // when
    let alteredCoordinate = sut.obfuscate(alexanderPlatz, .firstDecimal)
    // then
    XCTAssertNotEqual(alexanderPlatz, alteredCoordinate)
  }
  
  func test_ObfuscatorShouldReturnCoordinateWithAlteredSecondDecimal() {
    // given
    let alexanderPlatz = Coordinate.TestData.alexanderPlatz
    // when
    let alteredCoordinate = sut.obfuscate(alexanderPlatz, .thirdDecimal)
    // then
    XCTAssertNotEqual(alexanderPlatz, alteredCoordinate)
  }
  
  func test_ObfuscatorShouldReturnCoordinateWithAlteredFourthDecimal() {
    // given
    let alexanderPlatz = Coordinate.TestData.alexanderPlatz
    // when
    let alteredCoordinate = sut.obfuscate(alexanderPlatz, .fourthDecimal)
    // then
    XCTAssertNotEqual(alexanderPlatz, alteredCoordinate)
  }
  
  func test_ObfuscatorShouldReturnCoordinateWithCustomRange() {
    // given
    let alexanderPlatz = Coordinate.TestData.alexanderPlatz
    // when
    let alteredCoordinate = sut.obfuscate(
      alexanderPlatz,
      .custom(0.0000004 ... 0.0004)
    )
    // then
    XCTAssertNotEqual(alexanderPlatz, alteredCoordinate)
  }
}
