import MapFeature
import TestHelper
import XCTest

final class UserTrackingButtonSnapshotTests: XCTestCase {
  func test_userTracking_none() {
    let sut = UserTrackingButton(
      store: .init(
        initialState: .init(userTrackingMode: .none),
        reducer: UserTrackingFeature()
      )
    )
    
    assertViewSnapshot(sut, height: 60, sloppy: true)
  }
  
  func test_userTracking_follow() {
    let sut = UserTrackingButton(
      store: .init(
        initialState: .init(userTrackingMode: .follow),
        reducer: UserTrackingFeature()
      )
    )
    
    assertViewSnapshot(sut, height: 60, sloppy: true)
  }
  
  func test_userTracking_followWithHeading() {
    let sut = UserTrackingButton(
      store: .init(
        initialState: .init(userTrackingMode: .followWithHeading),
        reducer: UserTrackingFeature()
      )
    )
    
    assertViewSnapshot(sut, height: 60, sloppy: true)
  }
}
