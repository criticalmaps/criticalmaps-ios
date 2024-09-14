import MapFeature
import SnapshotTesting
import TestHelper
import XCTest

final class UserTrackingButtonSnapshotTests: XCTestCase {
  @MainActor
  func test_userTracking_none() {
    let sut = UserTrackingButton(
      store: .init(
        initialState: .init(userTrackingMode: .none),
        reducer: { UserTrackingFeature() }
      )
    )
    
    assertSnapshot(of: sut, as: .image)
  }
  
  @MainActor
  func test_userTracking_follow() {
    let sut = UserTrackingButton(
      store: .init(
        initialState: .init(userTrackingMode: .follow),
        reducer: { UserTrackingFeature() }
      )
    )
    
    assertSnapshot(of: sut, as: .image)
  }
  
  @MainActor
  func test_userTracking_followWithHeading() {
    let sut = UserTrackingButton(
      store: .init(
        initialState: .init(userTrackingMode: .followWithHeading),
        reducer: { UserTrackingFeature() }
      )
    )
    assertSnapshot(of: sut, as: .image)
  }
}
