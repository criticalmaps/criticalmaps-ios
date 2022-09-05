import ComposableArchitecture
import SocialFeature
import XCTest

class SocialFeatureCoreTests: XCTestCase {
  func test_setSocialSegment() {
    let testStore = TestStore(
      initialState: SocialFeature.State(socialControl: .chat),
      reducer: SocialFeature.reducer,
      environment: SocialFeature.Environment(
        mainQueue: .immediate,
        uiApplicationClient: .noop,
        locationsAndChatDataService: .noop,
        idProvider: .noop,
        uuid: { UUID(uuidString: "00000")! },
        date: { Date(timeIntervalSinceReferenceDate: 0) },
        userDefaultsClient: .noop
      )
    )

    testStore.send(.setSocialSegment(SocialFeature.SocialControl.twitter.rawValue)) { state in
      state.socialControl = .twitter
    }
    testStore.send(.setSocialSegment(SocialFeature.SocialControl.chat.rawValue)) { state in
      state.socialControl = .chat
    }
  }
}
