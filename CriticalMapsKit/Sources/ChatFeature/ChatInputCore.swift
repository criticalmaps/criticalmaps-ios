import ComposableArchitecture
import Foundation
import UIKit

// MARK: State

public struct ChatInputState: Equatable {
  @BindableState
  public var isEditing = false
  public var message = ""
  public var isSending = false

  public init(isEditing: Bool = false, message: String = "") {
    self.isEditing = isEditing
    self.message = message
  }

  /// Indicates if the message only contains whitespaces and newlines in which case the chat send
  /// button should be disabled
  public var isSendButtonDisabled: Bool {
    message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }

  /// Attributedstring representation of the chat input message
  public var internalAttributedMessage: NSAttributedString {
    NSAttributedString(
      string: message,
      attributes: [
        NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body),
        NSAttributedString.Key.foregroundColor: UIColor.textPrimary
      ]
    )
  }
}

// MARK: Actions

public enum ChatInputAction: Equatable, BindableAction {
  case binding(BindingAction<ChatInputState>)
  case messageChanged(String)
  case onCommit
}

// MARK: Environment

public struct ChatInputEnvironment {
  public init() {}
}

// MARK: Reducer

public let chatInputReducer = Reducer<ChatInputState, ChatInputAction, ChatInputEnvironment> { state, action, _ in
  switch action {
  case .binding:
    return .none

  case let .messageChanged(message):
    state.message = message
    return .none

  case .onCommit:
    return .none
  }
}
.binding()
