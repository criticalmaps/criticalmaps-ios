import ChatFeature
import ComposableArchitecture
import XCTest

final class ChatInputCoreTests: XCTestCase {
  @MainActor
  func test_isEditingChanged_action() async {
    let testStore = TestStore(
      initialState: ChatInput.State(
        isEditing: false,
        message: ""
      ),
      reducer: { ChatInput() },
      withDependencies: {
        $0.date = DateGenerator.constant(.distantFuture)
        $0.apiService.getChatMessages = { [] }
      }
    )
    
    await testStore.send(.set(\.$isEditing, true)) { state in
      state.isEditing = true
    }
    await testStore.send(.set(\.$isEditing, false)) { state in
      state.isEditing = false
    }
  }
  
  @MainActor
  func test_messageChanged_action() async {
    let state = ChatInput.State(
      isEditing: false,
      message: ""
    )
    
    XCTAssertTrue(state.isSendButtonDisabled)
    
    let testStore = TestStore(
      initialState: state,
      reducer: { ChatInput() }
    )
    
    await testStore.send(.messageChanged("Hello World!")) { state in
      state.message = "Hello World!"
      XCTAssertFalse(state.isSendButtonDisabled)
      XCTAssertEqual(state.internalAttributedMessage.string, state.message)
    }
    await testStore.send(.messageChanged("")) { state in
      state.message = ""
      XCTAssertTrue(state.isSendButtonDisabled)
    }
  }
}
