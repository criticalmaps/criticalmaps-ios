import ComposableArchitecture
import Foundation
import UIKit

public struct ChatInputState: Equatable {
  public var isEditing = false
  public var message = ""
  public var isSending = false

  public init(isEditing: Bool = false, message: String = "") {
    self.isEditing = isEditing
    self.message = message
  }
  
  public var isSendButtonDisabled: Bool {
    message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }
  
  public var internalAttributedMessage: NSAttributedString {
    NSAttributedString(
      string: message,
      attributes: [
        NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body),
        NSAttributedString.Key.foregroundColor: UIColor.textPrimary,
      ]
    )
  }
}

public enum ChatInputAction: Equatable {
  case isEditingChanged(Bool)
  case messageChanged(String)
  case onCommit
}

public struct ChatInputEnvironment {
  public init() {}
}

public let chatInputReducer = Reducer<ChatInputState, ChatInputAction, ChatInputEnvironment> { state, action, _ in
  switch action {
  case let .messageChanged(message):
    struct ChatMessageId: Hashable {}
    state.message = message
    return .none
    
  case let .isEditingChanged(value):
    state.isEditing = value
    return .none
    
  case .onCommit:
    return .none
  }
}
