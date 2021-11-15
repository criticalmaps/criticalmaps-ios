import ComposableArchitecture
import SocialFeature
import XCTest

class SocialFeatureCoreTests: XCTestCase {
  func test_setSocialSegment() {
    let testStore = TestStore(
      initialState: SocialState(socialControl: .chat),
      reducer: socialReducer,
      environment: SocialEnvironment(
        mainQueue: .immediate,
        uiApplicationClient: .noop,
        locationsAndChatDataService: .noop,
        idProvider: .noop,
        uuid: { UUID(uuidString: "00000")! },
        date: { Date(timeIntervalSinceReferenceDate: 0) },
        userDefaultsClient: .noop
      )
    )
    
    
    testStore.assert(
      .send(.setSocialSegment(SocialState.SocialControl.twitter.rawValue)) { state in
        state.socialControl = .twitter
      },
      .send(.setSocialSegment(SocialState.SocialControl.chat.rawValue)) { state in
        state.socialControl = .chat
      }
    )
  }
}
