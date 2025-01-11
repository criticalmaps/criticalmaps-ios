import ChatFeature
import ComposableArchitecture
import Foundation
import Testing

@Suite
@MainActor
struct ChatInputCoreTests {
  @Test
  func isEditingChanged_action() async throws {
    let testStore = TestStore(
      initialState: ChatInput.State(
        isEditing: false,
        message: ""
      ),
      reducer: { ChatInput() },
      withDependencies: {
        $0.date = DateGenerator.constant(.distantFuture)
        $0.apiService.getChatMessages = { [] }
        $0.userDefaultsClient.setDouble = { _, _ in }
      }
    )
    
    await testStore.send(.binding(.set(\.isEditing, true))) { state in
      state.isEditing = true
    }
    await testStore.send(.binding(.set(\.isEditing, false))) { state in
      state.isEditing = false
    }
  }
  
  @Test
  func messageChanged_action() async {
    let state = ChatInput.State(
      isEditing: false,
      message: ""
    )
    
    #expect(state.isSendButtonDisabled)
    
    let testStore = TestStore(
      initialState: state,
      reducer: { ChatInput() }
    )
    
    await testStore.send(.messageChanged(NSAttributedString(string: "Hello World!"))) { state in
      state.message = "Hello World!"
      #expect(state.isSendButtonDisabled == false)
      #expect(state.internalAttributedMessage.string == state.message)
    }
    await testStore.send(.messageChanged(NSAttributedString(string: ""))) { state in
      state.message = ""
      #expect(state.isSendButtonDisabled ==  true)
    }
  }
}
