//
//  File.swift
//  
//
//  Created by Malte on 07.06.21.
//

import CoreLocation
import XCTest
@testable import NextRideFeature

class CoordinateObfuscatorTests: XCTestCase {
  var sut: CoordinateObfuscator!
  
  override func setUp() {
    super.setUp()
    sut = CoordinateObfuscator()
  }
  
  func test_ObfuscatorShouldReturnAlteredCoordinate() {
    // given
    let alexanderPlatz = CLLocationCoordinate2D.TestData.alexanderPlatz
    // when
    let alteredCoordinate = sut.obfuscate(alexanderPlatz)
    // then
    XCTAssertNotEqual(alexanderPlatz, alteredCoordinate)
  }
  
  func test_ObfuscatorShouldReturnCoordinateWithAlteredFirstDecimal() {
    // given
    let alexanderPlatz = CLLocationCoordinate2D.TestData.alexanderPlatz
    // when
    let alteredCoordinate = sut.obfuscate(alexanderPlatz, precisionType: .firstDecimal)
    // then
    XCTAssertNotEqual(alexanderPlatz, alteredCoordinate)
  }
  
  func test_ObfuscatorShouldReturnCoordinateWithAlteredSecondDecimal() {
    // given
    let alexanderPlatz = CLLocationCoordinate2D.TestData.alexanderPlatz
    // when
    let alteredCoordinate = sut.obfuscate(alexanderPlatz, precisionType: .thirdDecimal)
    // then
    XCTAssertNotEqual(alexanderPlatz, alteredCoordinate)
  }
  
  func test_ObfuscatorShouldReturnCoordinateWithAlteredFourthDecimal() {
    // given
    let alexanderPlatz = CLLocationCoordinate2D.TestData.alexanderPlatz
    // when
    let alteredCoordinate = sut.obfuscate(alexanderPlatz, precisionType: .fourthDecimal)
    // then
    XCTAssertNotEqual(alexanderPlatz, alteredCoordinate)
  }
  
  func test_ObfuscatorShouldReturnCoordinateWithCustomRange() {
    // given
    let alexanderPlatz = CLLocationCoordinate2D.TestData.alexanderPlatz
    // when
    let alteredCoordinate = sut.obfuscate(
      alexanderPlatz,
      precisionType: .custom(0.0000004 ... 0.0004)
    )
    // then
    XCTAssertNotEqual(alexanderPlatz, alteredCoordinate)
  }
}
