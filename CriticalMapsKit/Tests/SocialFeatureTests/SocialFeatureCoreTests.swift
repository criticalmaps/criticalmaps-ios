import ComposableArchitecture
import SocialFeature
import XCTest

@MainActor
final class SocialFeatureCoreTests: XCTestCase {
  
  func test_setSocialSegment() {
    let testStore = TestStore(
      initialState: SocialFeature.State(socialControl: .chat),
      reducer: SocialFeature()
    )

    testStore.send(.setSocialSegment(SocialFeature.SocialControl.twitter.rawValue)) { state in
      state.socialControl = .twitter
    }
    testStore.send(.setSocialSegment(SocialFeature.SocialControl.chat.rawValue)) { state in
      state.socialControl = .chat
    }
  }
}
