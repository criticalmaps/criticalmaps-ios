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

    let twitter: SocialFeature.SocialControl = .twitter
    await testStore.send(.setSocialSegment(twitter.rawValue)) { state in
      state.socialControl = .twitter
    }

    let chat: SocialFeature.SocialControl = .chat
    await testStore.send(.setSocialSegment(chat.rawValue)) { state in
      state.socialControl = .chat
    }
  }
}
