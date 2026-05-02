import ChatFeature
import ComposableArchitecture
import Foundation
import SharedModels
import Styleguide
import SwiftUI
import TestHelper
import Testing

@MainActor
@Suite("ChatFeatureView 📸 Tests", .tags(.snapshot))
struct ChatFeatureSnapshotTests {
  @Test
  func `chat feature view snapshot`() throws {
    try withDependencies { values in
      values.apiService.getChatMessages = { [] }
    } operation: {
      let view = ChatView(
        store: .init(
          initialState: .init(
            chatMessages: .results([
              ChatMessage(identifier: "ID0", device: "Device", message: "Hello World!", timestamp: 0),
              ChatMessage(identifier: "ID1", device: "Device", message: "Hello World!", timestamp: 0)
            ]),
            chatInputState: .init()
          ),
          reducer: { ChatFeature() }
        )
      )
      
      try SnapshotHelper.assertScreenSnapshot(view)
    }
  }
  
  @Test
  func `chat input view snapshot non empty`() throws {
    try withDependencies { values in
      values.apiService.getChatMessages = { [] }
    } operation: {
      let view = BasicInputView(
        store: .init(
          initialState: .init(
            isEditing: true,
            message: "Hello World"
          ),
          reducer: { ChatInput() }
        )
      )
      
      try SnapshotHelper.assertViewSnapshot(view, height: 100)
    }
  }
  
  @Test
  func `chat input view snapshot empty`() throws {
    try withDependencies { values in
      values.apiService.getChatMessages = { [] }
    } operation: {
      let view = BasicInputView(
        store: .init(
          initialState: .init(
            isEditing: false,
            message: ""
          ),
          reducer: { ChatInput() }
        )
      )
      
      try SnapshotHelper.assertViewSnapshot(view, height: 100)
    }
  }
}
