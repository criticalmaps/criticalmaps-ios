import ChatFeature
import ComposableArchitecture
import XCTest

class ChatInputCoreTests: XCTestCase {
  func test_isEditingChanged_action() {
    let testStore = TestStore(
      initialState: ChatInputState(
        isEditing: false,
        message: ""
      ),
      reducer: chatInputReducer,
      environment: ChatInputEnvironment()
    )
    
    testStore.send(.set(\.$isEditing, true)) { state in
      state.isEditing = true
    }
    testStore.send(.set(\.$isEditing, false)) { state in
      state.isEditing = false
    }
  }
  
  func test_messageChanged_action() {
    let state = ChatInputState(
      isEditing: false,
      message: ""
    )
    
    XCTAssertTrue(state.isSendButtonDisabled)
    
    let testStore = TestStore(
      initialState: state,
      reducer: chatInputReducer,
      environment: ChatInputEnvironment()
    )
    
    testStore.send(.messageChanged("Hello World!")) { state in
      state.message = "Hello World!"
      XCTAssertFalse(state.isSendButtonDisabled)
      XCTAssertEqual(state.internalAttributedMessage.string, state.message)
    }
    testStore.send(.messageChanged("")) { state in
      state.message = ""
      XCTAssertTrue(state.isSendButtonDisabled)
    }
  }
}
