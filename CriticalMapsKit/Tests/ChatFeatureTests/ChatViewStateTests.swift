import ChatFeature
import Foundation
import SharedModels
import XCTest

final class ChatViewStateTests: XCTestCase {
  func test_createChatViewState_shouldSortMessagesByDate() {
    // arrange
    let chatFeatureState = ChatFeature.State(
      chatMessages: .results([
        ChatMessage(identifier: "1", device: "", message: "Hello", timestamp: 1),
        ChatMessage(identifier: "2", device: "", message: "Hello", timestamp: 2),
        ChatMessage(identifier: "3", device: "", message: "Hello", timestamp: 3)
      ]),
      chatInputState: .init()
    )

    // act
    let chatViewState = ChatView.ViewState(chatFeatureState)
    let messages = chatViewState.messages

    // assert
    let expectedMessages = [
      ChatMessage(identifier: "3", device: "", message: "Hello", timestamp: 3),
      ChatMessage(identifier: "2", device: "", message: "Hello", timestamp: 2),
      ChatMessage(identifier: "1", device: "", message: "Hello", timestamp: 1)
    ]
    XCTAssertEqual(messages, expectedMessages)
  }
}
