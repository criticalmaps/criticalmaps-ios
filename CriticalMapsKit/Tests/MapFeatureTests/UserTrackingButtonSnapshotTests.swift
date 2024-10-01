import MapFeature
import SnapshotTesting
import TestHelper
import Testing

struct UserTrackingButtonSnapshotTests {
  @Test(.disabled("Due to CI issue with selecting iPhone"))
  func test_userTracking_none() {
    let sut = UserTrackingButton(
      store: .init(
        initialState: .init(userTrackingMode: .none),
        reducer: { UserTrackingFeature() }
      )
    )
    
    assertSnapshot(of: sut, as: .image)
  }
  
  @Test(.disabled("Due to CI issue with selecting iPhone"))
  func test_userTracking_follow() {
    let sut = UserTrackingButton(
      store: .init(
        initialState: .init(userTrackingMode: .follow),
        reducer: { UserTrackingFeature() }
      )
    )
    
    assertSnapshot(of: sut, as: .image)
  }
  
  @Test(.disabled("Due to CI issue with selecting iPhone"))
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
