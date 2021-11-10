import ComposableArchitecture
import Foundation
import L10n
import SharedModels

// MARK: State
public struct ChatFeatureState: Equatable {
  public var chatMessages: [String: ChatMessage]
  
  public init(chatMessages: [String : ChatMessage] = [:]) {
    self.chatMessages = chatMessages
  }
}

// MARK: Actions
public enum ChatFeatureAction: Equatable {
  case placeholder
}

// MARK: Environment
public struct ChatEnvironment {
  public init() {}
}

// MARK: Reducer
public let chatReducer =
Reducer<ChatFeatureState, ChatFeatureAction, ChatEnvironment>.combine(
  Reducer<ChatFeatureState, ChatFeatureAction, ChatEnvironment> {
    state, action, environment in
    switch action {
    case .placeholder:
      return .none
    }
  }
)
