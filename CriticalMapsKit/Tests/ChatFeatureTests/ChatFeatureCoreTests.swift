import ApiClient
import ChatFeature
import ComposableArchitecture
import Helpers
import L10n
import SharedModels
import UserDefaultsClient
import XCTest

final class ChatFeatureCore: XCTestCase {
  let uuid = { UUID(uuidString: "00000000-0000-0000-0000-000000000000")! }
  let date = { Date(timeIntervalSinceReferenceDate: 0) }
  
  @MainActor
  func defaultTestStore(
    with state: ContentState<[ChatMessage]> = .results([])
  ) -> TestStoreOf<ChatFeature> {
    let testStore = TestStore(
      initialState: ChatFeature.State(
        chatMessages: state,
        chatInputState: .init(
          isEditing: true,
          message: "Hello World!"
        )
      ),
      reducer: { ChatFeature() }
    )
    testStore.dependencies.uuid = .constant(uuid())
    testStore.dependencies.date = .constant(date())
    
    return testStore
  }
  
  @MainActor
  func test_chatInputAction_onCommit_shouldTriggerNetworkCall_withSuccessResponse() async {
    let testStore = defaultTestStore()
    testStore.dependencies.apiService.postChatMessage = { _ in return ApiResponse(status: "ok") }
    testStore.dependencies.apiService.getChatMessages = { mockResponse }
    
    _ = await testStore.send(.chatInput(.onCommit)) { state in
      state.chatInputState.isSending = true
    }
    await testStore.receive(.chatInputResponse(.success(.init(status: "ok")))) { state in
      state.chatInputState.isSending = false
      state.chatInputState.message = ""
    }
    await testStore.receive(.fetchChatMessages) {
      $0.chatMessages = .loading([])
    }
    await testStore.receive(.fetchChatMessagesResponse(.success(mockResponse))) {
      $0.chatMessages = .results(mockResponse)
    }
  }
  
  @MainActor
  func test_storeWithItems_shouldTriggerNetworkCall_withSuccessResponse_andHaveElements() async {
    let testStore = defaultTestStore(
      with: .loading([
        ChatMessage(
            identifier: "ID88878",
            device: "Device",
            message: "Hello World!",
            timestamp: 1889.1
          )
      ])
    )
    testStore.dependencies.apiService.postChatMessage = { _ in return ApiResponse(status: "ok") }
    testStore.dependencies.apiService.getChatMessages = { mockResponse }
    
    _ = await testStore.send(.chatInput(.onCommit)) { state in
      state.chatInputState.isSending = true
    }
    await testStore.receive(.chatInputResponse(.success(.init(status: "ok")))) { state in
      state.chatInputState.isSending = false
      state.chatInputState.message = ""
    }
    await testStore.receive(.fetchChatMessages)
    XCTAssertFalse(testStore.state.chatMessages.elements!.isEmpty)
    await testStore.receive(.fetchChatMessagesResponse(.success(mockResponse))) {
      $0.chatMessages = .results(mockResponse)
    }
  }
  
  @MainActor
  func test_chatInputAction_onCommit_shouldTriggerNetworkCallWithFailureResponse() async {
    let error = NSError(domain: "", code: 1)
    let testStore = defaultTestStore()
    
    testStore.dependencies.apiService.getChatMessages = { throw error }
    testStore.dependencies.apiService.postChatMessage = { _ in throw error }
            
    _ = await testStore.send(.chatInput(.onCommit)) { state in
      state.chatInputState.isSending = true
    }
    await testStore.receive(.chatInputResponse(.failure(error))) { state in
      state.chatInputState.isSending = false
      state.alert = .init(
        title: { .init(L10n.error) },
        message: { .init("Failed to send chat message") }
      )
    }
  }
  
  @MainActor
  func test_didAppear_ShouldSet_appearanceTimeinterval() async {
    let didWriteChatAppearanceTimeinterval = LockIsolated(false)
    let chatAppearanceTimeinterval: LockIsolated<TimeInterval> = LockIsolated(0)
    
    let testStore = TestStore(
      initialState: ChatFeature.State(),
      reducer: { ChatFeature() }
    )
    testStore.dependencies.apiService.getChatMessages = { mockResponse }
    testStore.dependencies.userDefaultsClient.setDouble = { interval, _ in
      didWriteChatAppearanceTimeinterval.setValue(true)
      chatAppearanceTimeinterval.setValue(interval)
      return ()
    }
    testStore.dependencies.uuid = .constant(uuid())
    testStore.dependencies.date = .constant(date())
  
    _ = await testStore.send(.onAppear)
    await testStore.receive(.fetchChatMessages)
    await testStore.receive(.fetchChatMessagesResponse(.success(mockResponse))) {
      $0.chatMessages = .results(mockResponse)
    }
    chatAppearanceTimeinterval.withValue { interval in
      XCTAssertEqual(interval, date().timeIntervalSince1970)
    }
    didWriteChatAppearanceTimeinterval.withValue { val in
      XCTAssertTrue(val)
    }
  }
  
  @MainActor
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
