import ApiClient
import ChatFeature
import ComposableArchitecture
import Foundation
import Helpers
import L10n
import SharedModels
import Testing
import UserDefaultsClient

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
      $0.userDefaultsClient.setDouble = { _, _ in }
    }
    
    return testStore
  }
  
  @Test("chat input action should trigger network call with success response")
  func chatInputOnCommit() async throws {
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
  
  @Test("Store with items should trigger networkCall with success and have Elements")
  func onCommitWithElements() async {
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
  
  @Test("OnCommit should trigger networkCall with failure response when service throws error")
  func onCommitWithErrorResponse() async {
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
  
  @Test("OnAppear should set appearanceTimeinterval")
  func didAppear_ShouldSet_appearanceTimeinterval() async {
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
    testStore.dependencies.uuid = .constant(uuid)
    testStore.dependencies.date = .constant(date)
  
    _ = await testStore.send(.onAppear)
    await testStore.receive(\.fetchChatMessages)
    await testStore.receive(\.fetchChatMessagesResponse.success, mockResponse) {
      $0.chatMessages = .results(mockResponse)
    }
    chatAppearanceTimeinterval.withValue { interval in
      #expect(interval == date.timeIntervalSince1970)
    }
    didWriteChatAppearanceTimeinterval.withValue { val in
      #expect(val)
    }
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
