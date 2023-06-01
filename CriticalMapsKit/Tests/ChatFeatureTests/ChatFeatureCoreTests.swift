import ApiClient
import ChatFeature
import ComposableArchitecture
import L10n
import SharedModels
import UserDefaultsClient
import XCTest

@MainActor
final class ChatFeatureCore: XCTestCase {
  let uuid = { UUID(uuidString: "00000000-0000-0000-0000-000000000000")! }
  let date = { Date(timeIntervalSinceReferenceDate: 0) }
  
  func defaultTestStore() -> TestStore<ChatFeature.State, ChatFeature.Action, ChatFeature.State, ChatFeature.Action, ()> {
    let testStore = TestStore(
      initialState: ChatFeature.State(
        chatMessages: .results([]),
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
    testStore.dependencies.apiService.postChatMessage = { _ in return ApiResponse(status: "ok") }
    
    _ = await testStore.send(.chatInput(.onCommit)) { state in
      state.chatInputState.isSending = true
    }
    await testStore.receive(.chatInputResponse(.success(.init(status: "ok")))) { state in
      state.chatInputState.isSending = false
      state.chatInputState.message = ""
    }
  }
  
  func test_chatInputAction_onCommit_shouldTriggerNetworkCallWithFailureResponse() async {
    let error = NSError(domain: "", code: 1)
    let testStore = defaultTestStore()
    
    testStore.dependencies.apiService.getChatMessages = { throw error }
            
    _ = await testStore.send(.chatInput(.onCommit)) { state in
      state.chatInputState.isSending = true
    }
    await testStore.receive(.chatInputResponse(.failure(error))) { state in
      state.chatInputState.isSending = false
      state.alert = .init(
        title: .init(L10n.error),
        message: .init("Failed to send chat message")
      )
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
      chatMessages: .results(mockResponse),
      chatInputState: .init()
    )
    let sut = ChatView.ViewState(state)
    
    XCTAssertEqual(
      sut.messages.map(\.identifier),
      ["ID0", "ID3", "ID2", "ID1"]
    )
  }
}

let mockResponse = [
  ChatMessage(
    identifier: "ID0",
    device: "Device",
    message: "Hello World!",
    timestamp: 1889.0
  ),
  ChatMessage(
    identifier: "ID1",
    device: "Device",
    message: "Hello World!",
    timestamp: 1234.0
  ),
  ChatMessage(
    identifier: "ID2",
    device: "Device",
    message: "Hello World!",
    timestamp: 1235.0
  ),
  ChatMessage(
    identifier: "ID3",
    device: "Device",
    message: "Hello World!",
    timestamp: 1236.0
  )
]
