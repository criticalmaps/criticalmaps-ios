import Combine
import ComposableArchitecture
import MapFeature
import SharedModels
import Testing

@MainActor
struct UserTrackingModeCoreTests {
  @Test
  func `next tracking mode`() async {
    let store = TestStore(
      initialState: UserTrackingFeature.State(userTrackingMode: .none),
      reducer: { UserTrackingFeature() }
    )

    await store.send(.nextTrackingMode) {
      $0.mode = .follow
    }
    await store.send(.nextTrackingMode) {
      $0.mode = .followWithHeading
    }
    await store.send(.nextTrackingMode) {
      $0.mode = .none
    }
  }
}
