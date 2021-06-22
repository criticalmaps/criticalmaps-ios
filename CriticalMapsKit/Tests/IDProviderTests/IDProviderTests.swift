//
//  File.swift
//  
//
//  Created by Malte on 20.06.21.
//

@testable import IDProvider
import Foundation
import XCTest

class IDProviderTests: XCTestCase {
  let deviceID = "0000-0000-0000-0000-0001"
  
  func testIDDoesChange() {
    let date = Date(timeIntervalSince1970: 1_557_057_968)
    let currentID: IDProvider = .live(
      deviceID: deviceID,
      currentDate: date
    )
    
    let newDate = date.addingTimeInterval(7200)
    let newID: IDProvider = .live(
      deviceID: deviceID,
      currentDate: newDate
    )
    
    XCTAssertEqual(currentID.id(), newID.id())
  }
  
  func testIDDoesNotChange() {
    let date = Date(timeIntervalSince1970: 1_557_057_968)
    let currentID: IDProvider = .live(
      deviceID: deviceID,
      currentDate: date
    )
    
    let newDate = date.addingTimeInterval(86400)
    let newID: IDProvider = .live(
      deviceID: deviceID,
      currentDate: newDate
    )
    
    XCTAssertNotEqual(currentID.id(), newID.id())
  }
}
