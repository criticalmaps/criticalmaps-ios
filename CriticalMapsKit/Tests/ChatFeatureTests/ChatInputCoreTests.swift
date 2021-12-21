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
    
    testStore.assert(
      .send(.isEditingChanged(true)) { state in
        state.isEditing = true
      },
      .send(.isEditingChanged(false)) { state in
        state.isEditing = false
      }
    )
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
    
    testStore.assert(
      .send(.messageChanged("Hello World!")) { state in
        state.message = "Hello World!"
        XCTAssertFalse(state.isSendButtonDisabled)
        XCTAssertEqual(state.internalAttributedMessage.string, state.message)
      },
      .send(.messageChanged("")) { state in
        state.message = ""
        XCTAssertTrue(state.isSendButtonDisabled)
      }
    )
  }
}
