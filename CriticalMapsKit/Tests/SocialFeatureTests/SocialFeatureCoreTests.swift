import ComposableArchitecture
import SocialFeature
import XCTest

@MainActor
final class SocialFeatureCoreTests: XCTestCase {
  func test_setSocialSegment() async {
    let testStore = TestStore(
      initialState: SocialFeature.State(),
      reducer: SocialFeature()
    )

    let toots: SocialFeature.SocialControl = .toots
    await testStore.send(.setSocialSegment(toots.rawValue)) { state in
      state.socialControl = .toots
    }

    let chat: SocialFeature.SocialControl = .chat
    await testStore.send(.setSocialSegment(chat.rawValue)) { state in
      state.socialControl = .chat
    }
  }
}
