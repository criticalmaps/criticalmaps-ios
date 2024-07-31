import ComposableArchitecture
import Foundation
import IDProvider
import XCTest

final class IDProviderTests: XCTestCase {
  let deviceID = "00000000-0000-0000-0000-000000000001"
  
  func testIDDoesChange() {
    let date = Date(timeIntervalSince1970: 1557057968)
    let currentID = withDependencies { values in
      values.date = DateGenerator({ date })
      values.userDefaultsClient.stringForKey = { _ in self.deviceID }
    } operation: {
      IDProvider.liveValue
    }
    
    let newDate = date.addingTimeInterval(7200)
    let newID = withDependencies { values in
      values.date = DateGenerator({ newDate })
      values.userDefaultsClient.stringForKey = { _ in self.deviceID }
    } operation: {
      IDProvider.liveValue
    }
    
    XCTAssertEqual(currentID.id(), newID.id())
  }
  
  func testIDDoesNotChange() {
    let date = Date(timeIntervalSince1970: 1557057968)
    let currentID = withDependencies { values in
      values.date = DateGenerator({ date })
      values.userDefaultsClient.stringForKey = { _ in self.deviceID }
    } operation: {
      IDProvider.liveValue
    }
    
    let newDate = date.addingTimeInterval(86400)
    let newID = withDependencies { values in
      values.date = DateGenerator({ newDate })
      values.userDefaultsClient.stringForKey = { _ in self.deviceID }
    } operation: {
      IDProvider.liveValue
    }
    
    XCTAssertNotEqual(currentID.id(), newID.id())
  }
}
