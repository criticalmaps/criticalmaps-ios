import ApiClient
import ChatFeature
import ComposableArchitecture
import Foundation
import Helpers
import L10n
import SharedKeys
import SharedModels
import Testing

struct TestError: Equatable, Error {
  let message = "ERROR"
}

@Suite
@MainActor
struct ChatFeatureCore {
  let uuid = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
  let date = Date(timeIntervalSinceReferenceDate: 0)
  
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
    ) {
      $0.uuid = .constant(uuid)
      $0.date = .constant(date)
      $0.idProvider = .noop
    }
    
    return testStore
  }
  
  @Test
  func `chat input action should trigger network call with success response`() async throws {
    let testStore = defaultTestStore()
    testStore.dependencies.apiService.postChatMessage = { _ in ApiResponse(status: "ok") }
    testStore.dependencies.apiService.getChatMessages = { mockResponse }
    
    _ = await testStore.send(.chatInput(.onCommit)) { state in
      state.chatInputState.isSending = true
    }
    await testStore.receive(\.chatInputResponse.success, .init(status: "ok")) { state in
      state.chatInputState.isSending = false
      state.chatInputState.message = ""
    }
    await testStore.receive(\.fetchChatMessages) {
      $0.chatMessages = .loading([])
    }
    await testStore.receive(\.fetchChatMessagesResponse.success, mockResponse) {
      $0.chatMessages = .results(mockResponse)
    }
  }
  
  @Test
  func `Store with items should trigger networkCall with success and have Elements`() async {
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
    testStore.dependencies.apiService.postChatMessage = { _ in ApiResponse(status: "ok") }
    testStore.dependencies.apiService.getChatMessages = { mockResponse }
    
    _ = await testStore.send(.chatInput(.onCommit)) { state in
      state.chatInputState.isSending = true
    }
    await testStore.receive(\.chatInputResponse.success, .init(status: "ok")) { state in
      state.chatInputState.isSending = false
      state.chatInputState.message = ""
    }
    await testStore.receive(\.fetchChatMessages)
    #expect(testStore.state.chatMessages.elements!.isEmpty == false)
    await testStore.receive(\.fetchChatMessagesResponse.success, mockResponse) {
      $0.chatMessages = .results(mockResponse)
    }
  }
  
  @Test
  func `OnCommit should trigger networkCall with failure response when service throws error`() async {
    let error = TestError()
    let testStore = defaultTestStore()
    
    testStore.dependencies.apiService.getChatMessages = { throw error }
    testStore.dependencies.apiService.postChatMessage = { _ in throw error }
            
    _ = await testStore.send(.chatInput(.onCommit)) { state in
      state.chatInputState.isSending = true
    }
    await testStore.receive(\.chatInputResponse.failure) { state in
      state.chatInputState.isSending = false
      state.alert = .init(
        title: { .init(L10n.error) },
        message: { .init("Failed to send chat message") }
      )
    }
  }
  
  @Test
  func `OnAppear should set appearanceTimeInterval`() async {
    @Shared(.chatReadTimeInterval) var chatTimeInterval = 0
    let testStore = TestStore(
      initialState: ChatFeature.State(),
      reducer: { ChatFeature() }
    ) {
      $0.apiService.getChatMessages = { mockResponse }
      $0.uuid = .constant(uuid)
      $0.date = .constant(date)
    }
  
    _ = await testStore.send(.onAppear)
    await testStore.receive(\.fetchChatMessages)
    await testStore.receive(\.fetchChatMessagesResponse.success, mockResponse) {
      $0.chatMessages = .results(mockResponse)
    }

    #expect(chatTimeInterval == date.timeIntervalSince1970)
  }
  
  @Test
  func chatViewState() {
    let state = ChatFeature.State(
      chatMessages: .results(mockResponse),
      chatInputState: .init()
    )
    let testStore = TestStore(
      initialState: state,
      reducer: { ChatFeature() }
    )
  
    expectNoDifference(
      testStore.state.messages.map(\.identifier),
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
