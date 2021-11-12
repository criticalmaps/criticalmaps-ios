import ChatFeature
import Combine
import ComposableArchitecture
import SharedModels
import XCTest

class ChatFeatureCore: XCTestCase {
  let uuid = { UUID(uuidString: "00000000-0000-0000-0000-000000000000")! }
  let date = { Date.init(timeIntervalSinceReferenceDate: 0) }
  
  func test_chatInputAction_onCommit_shouldTriggerNetworkCall_withSuccessResponse() {
    let testStore = TestStore(
      initialState: ChatFeatureState(
        chatMessages: [:],
        chatInputState: .init(
          isEditing: true,
          message: "Hello World!"
        )
      ),
      reducer: chatReducer,
      environment: ChatEnvironment(
        locationsAndChatDataService: .noop,
        mainQueue: .immediate,
        idProvider: .noop,
        uuid: uuid,
        date: date
      )
    )
    
    testStore.assert(
      .environment { env in
        env.locationsAndChatDataService.getLocationsAndSendMessages = { _ in
          Just(mockResponse)
            .setFailureType(to: NSError.self)
            .eraseToAnyPublisher()
        }
      },
      .send(.chatInput(.onCommit)) { state in
        state.chatInputState.isSending = true
      },
      .receive(.chatInputResponse(.success(mockResponse))) { state in
        state.chatInputState.isSending = false
        state.chatInputState.message = ""
      }
    )
  }
  
  func test_chatInputAction_onCommit_shouldTriggerNetworkCallWithFailureResponse() {
    let testStore = TestStore(
      initialState: ChatFeatureState(
        chatMessages: [:],
        chatInputState: .init(
          isEditing: true,
          message: "Hello World!"
        )
      ),
      reducer: chatReducer,
      environment: ChatEnvironment(
        locationsAndChatDataService: .noop,
        mainQueue: .immediate,
        idProvider: .noop,
        uuid: uuid,
        date: date
      )
    )
    
    let error = NSError()
    
    testStore.assert(
      .environment { env in
        env.locationsAndChatDataService.getLocationsAndSendMessages = { _ in
          Fail(error: error)
            .eraseToAnyPublisher()
        }
      },
      .send(.chatInput(.onCommit)) { state in
        state.chatInputState.isSending = true
      },
      .receive(.chatInputResponse(.failure(error))) { state in
        state.chatInputState.isSending = false
      }
    )
  }
}


let mockResponse = LocationAndChatMessages(
  locations: [
    "1": Location.init(coordinate: Coordinate(latitude: 0.0, longitude: 1.1), timestamp: 1234.0)
  ],
  chatMessages: [
    "ID": ChatMessage(message: "Hello World!", timestamp: 1234.0)
  ]
)
