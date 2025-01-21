import ComposableArchitecture
import SocialFeature
import Testing

@Suite
@MainActor
struct SocialFeatureCoreTests {
  @Test("Set social segment should update state")
  func setSocialSegment() async throws {
    let testStore = TestStore(
      initialState: SocialFeature.State(),
      reducer: { SocialFeature() }
    )

    await testStore.send(.binding(.set(\.socialControl, .toots))) { state in
      state.socialControl = .toots
    }

    await testStore.send(.binding(.set(\.socialControl, .chat))) { state in
      state.socialControl = .chat
    }
  }
}
