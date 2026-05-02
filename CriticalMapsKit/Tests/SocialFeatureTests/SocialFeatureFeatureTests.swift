import ComposableArchitecture
import SocialFeature
import Testing

@MainActor
struct SocialFeatureCoreTests {
  @Test
  func `Set social segment should update state`() async {
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
