import ApiClient
import ChatFeature
import ComposableArchitecture
import SharedModels
import UserDefaultsClient
import XCTest

@MainActor
final class ChatFeatureCore: XCTestCase {
  let uuid = { UUID(uuidString: "00000000-0000-0000-0000-000000000000")! }
  let date = { Date(timeIntervalSinceReferenceDate: 0) }
  
  func defaultTestStore() -> TestStore<ChatFeature, ChatFeature.State, ChatFeature.Action, Void> {
    let testStore = TestStore(
      initialState: ChatFeature.State(
        chatMessages: .results([:]),
        chatInputState: .init(
          isEditing: true,
          message: "Hello World!"
        )
      ),
      reducer: ChatFeature()
    )
    testStore.dependencies.uuid = .constant(uuid())
    testStore.dependencies.date = .constant(date())
    testStore.dependencies.isNetworkAvailable = true
    
    return testStore
  }
  
  func test_chatInputAction_onCommit_shouldTriggerNetworkCall_withSuccessResponse() async {
    let testStore = defaultTestStore()
    testStore.dependencies.locationAndChatService.getLocationsAndSendMessages = { _ in mockResponse }
    
    _ = await testStore.send(.chatInput(.onCommit)) { state in
      state.chatInputState.isSending = true
    }
    await testStore.receive(.chatInputResponse(.success(mockResponse))) { state in
      state.chatInputState.isSending = false
      state.chatInputState.message = ""
      state.chatMessages = .results(mockResponse.chatMessages)
    }
  }
  
  func test_chatInputAction_onCommit_shouldTriggerNetworkCallWithFailureResponse() async {
    let error = NSError()
    let testStore = defaultTestStore()
    
    testStore.dependencies.locationAndChatService.getLocationsAndSendMessages = { _ in
      throw error
    }
            
    _ = await testStore.send(.chatInput(.onCommit)) { state in
      state.chatInputState.isSending = true
    }
    await testStore.receive(.chatInputResponse(.failure(error))) { state in
      state.chatInputState.isSending = false
    }
  }
  
  func test_didAppear_ShouldSet_appearanceTimeinterval() async {
    let didWriteChatAppearanceTimeinterval = ActorIsolated(false)
    let chatAppearanceTimeinterval: ActorIsolated<TimeInterval> = ActorIsolated(0)
    
    let testStore = TestStore(
      initialState: ChatFeature.State(),
      reducer: ChatFeature()
    )
    testStore.dependencies.userDefaultsClient.setDouble = { interval, _ in
      await didWriteChatAppearanceTimeinterval.setValue(true)
      await chatAppearanceTimeinterval.setValue(interval)
      return ()
    }
    testStore.dependencies.uuid = .constant(uuid())
    testStore.dependencies.date = .constant(date())
  
    _ = await testStore.send(.onAppear)
    await chatAppearanceTimeinterval.withValue { interval in
      XCTAssertEqual(interval, date().timeIntervalSince1970)
    }
    await didWriteChatAppearanceTimeinterval.withValue { val in
      XCTAssertTrue(val)
    }
  }
  
  func test_chatViewState() {
    let state = ChatFeature.State(
      chatMessages: .results(mockResponse.chatMessages),
      chatInputState: .init()
    )
    let sut = ChatView.ViewState(state)
    
    let sortedMessages = sut.identifiedChatMessages
    
    XCTAssertEqual(
      sortedMessages.map(\.id),
      ["ID0", "ID3", "ID2", "ID1"]
    )
  }
}

let mockResponse = LocationAndChatMessages(
  locations: [
    "1": .init(coordinate: Coordinate(latitude: 0.0, longitude: 1.1), timestamp: 1234.0)
  ],
  chatMessages: [
    "ID0": .init(message: "Hello World!", timestamp: 1889.0),
    "ID1": .init(message: "Hello World!", timestamp: 1234.0),
    "ID2": .init(message: "Hello World!", timestamp: 1235.0),
    "ID3": .init(message: "Hello World!", timestamp: 1236.0)
  ]
)
