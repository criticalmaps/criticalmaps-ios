import ChatFeature
import SharedModels
import Styleguide
import SwiftUI
import TestHelper
import XCTest

final class ChatFeatureSnapshotTests: XCTestCase {
  func test_chatFeatureViewSnapshot() {
    let view = ChatView(
      store: .init(
        initialState: .init(
          chatMessages: .results([
            ChatMessage(identifier: "ID0", device: "Device", message: "Hello World!", timestamp: 0),
            ChatMessage(identifier: "ID1", device: "Device", message: "Hello World!", timestamp: 0)
          ]),
          chatInputState: .init()
        ),
        reducer: ChatFeature()
      )
    )
    
    assertScreenSnapshot(view, sloppy: true)
  }
  
  func test_chatFeatureViewSnapshot_dark() {
    let view = ChatView(
      store: .init(
        initialState: .init(
          chatMessages: .results([
            ChatMessage(identifier: "1", device: "Device", message: "Hello World!", timestamp: 0),
            ChatMessage(identifier: "2", device: "Device", message: "Hello World!", timestamp: 4)
          ]),
          chatInputState: .init()
        ),
        reducer: ChatFeature()
      )
    )
    .environment(\.colorScheme, .dark)
    
    assertScreenSnapshot(view, sloppy: true)
  }
  
  func test_chatInputViewSnapshot_nonEmpty() {
    let view = BasicInputView(
      store: .init(
        initialState: .init(
          isEditing: true,
          message: "Hello W"
        ),
        reducer: ChatInput()
      )
    )
    
    assertViewSnapshot(view, height: 100, sloppy: true)
  }
  
  func test_chatInputViewSnapshot_empty() {
    let view = BasicInputView(
      store: .init(
        initialState: .init(
          isEditing: false,
          message: ""
        ),
        reducer: ChatInput()
      )
    )
    
    assertViewSnapshot(view, height: 100, sloppy: true)
  }
}
