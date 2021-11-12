import CryptoKit
import ComposableArchitecture
import Foundation
import IDProvider
import L10n
import SharedModels
import ApiClient

// MARK: State
public struct ChatFeatureState: Equatable {
  public var chatMessages: [String: ChatMessage]
  public var chatInputState: ChatInputState
  
  public init(
    chatMessages: [String : ChatMessage] = [:],
    chatInputState: ChatInputState = .init()
  ) {
    self.chatMessages = chatMessages
    self.chatInputState = chatInputState
  }
}

// MARK: Actions
public enum ChatFeatureAction: Equatable {
  case chatInput(ChatInputAction)
  case chatInputResponse(Result<LocationAndChatMessages, NSError>)
}

// MARK: Environment
public struct ChatEnvironment {
  public var locationsAndChatDataService: LocationsAndChatDataService
  public var mainQueue: AnySchedulerOf<DispatchQueue>
  public var idProvider: IDProvider
  public var uuid: () -> UUID
  public var date: () -> Date
  
  public init(
    locationsAndChatDataService: LocationsAndChatDataService,
    mainQueue: AnySchedulerOf<DispatchQueue>,
    idProvider: IDProvider,
    uuid: @escaping () -> UUID,
    date: @escaping () -> Date
  ) {
    self.locationsAndChatDataService = locationsAndChatDataService
    self.mainQueue = mainQueue
    self.idProvider = idProvider
    self.uuid = uuid
    self.date = date
  }
}

// MARK: Reducer
public let chatReducer = Reducer<ChatFeatureState, ChatFeatureAction, ChatEnvironment>.combine(
  chatInputReducer.pullback(
    state: \.chatInputState,
    action: /ChatFeatureAction.chatInput,
    environment: { _ in
      ChatInputEnvironment()
    }
  ),
  Reducer<ChatFeatureState, ChatFeatureAction, ChatEnvironment> {
    state, action, environment in
    switch action {
    case let .chatInput(chatInputAction):
      switch chatInputAction {
      case .onCommit:
        let message = SendChatMessage(
          text: state.chatInputState.message,
          timestamp: environment.date().timeIntervalSince1970,
          identifier: environment.uuid().uuidString.md5()
        )        
        let body = SendLocationAndChatMessagesPostBody(
          device: environment.idProvider.id(),
          location: nil,
          messages: [message]
        )
        
        state.chatInputState.isSending = true
        
        return environment.locationsAndChatDataService
          .getLocationsAndSendMessages(body)
          .receive(on: environment.mainQueue)
          .catchToEffect()
          .map(ChatFeatureAction.chatInputResponse)
        
      default:
        return .none
      }
      
    case let .chatInputResponse(.success(response)):
      state.chatInputState.isSending = false
      state.chatInputState.message.removeAll()
      return .none
      
    case let .chatInputResponse(.failure(error)):
      state.chatInputState.isSending = false
      // log error
      return .none
    }
  }
)

extension String {
  func md5() -> String {
    return Insecure.MD5.hash(data: self.data(using: .utf8)!).map { String(format: "%02hhx", $0) }.joined()
  }
}
