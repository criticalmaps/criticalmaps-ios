import ApiClient
import ComposableArchitecture
import CryptoKit
import Foundation
import Helpers
import IDProvider
import L10n
import Logger
import SharedModels
import UserDefaultsClient

// MARK: State
public struct ChatFeatureState: Equatable {
  public var chatMessages: ContentState<[String: ChatMessage]>
  public var chatInputState: ChatInputState
  public var hasConnectivity: Bool
    
  public init(
    chatMessages: ContentState<[String: ChatMessage]> = .loading([:]),
    chatInputState: ChatInputState = .init(),
    hasConnectivity: Bool = true
  ) {
    self.chatMessages = chatMessages
    self.chatInputState = chatInputState
    self.hasConnectivity = hasConnectivity
  }
}

// MARK: Actions
public enum ChatFeatureAction: Equatable {
  case onAppear
  case chatInputResponse(Result<LocationAndChatMessages, NSError>)

  case chatInput(ChatInputAction)
}

// MARK: Environment
public struct ChatEnvironment {
  public var locationsAndChatDataService: LocationsAndChatDataService
  public var mainQueue: AnySchedulerOf<DispatchQueue>
  public var idProvider: IDProvider
  public var uuid: () -> UUID
  public var date: () -> Date
  public var userDefaultsClient: UserDefaultsClient
  
  public init(
    locationsAndChatDataService: LocationsAndChatDataService,
    mainQueue: AnySchedulerOf<DispatchQueue>,
    idProvider: IDProvider,
    uuid: @escaping () -> UUID,
    date: @escaping () -> Date,
    userDefaultsClient: UserDefaultsClient
  ) {
    self.locationsAndChatDataService = locationsAndChatDataService
    self.mainQueue = mainQueue
    self.idProvider = idProvider
    self.uuid = uuid
    self.date = date
    self.userDefaultsClient = userDefaultsClient
  }
  
  var md5Uuid: String {
    Insecure.MD5.hash(data: uuid().uuidString.data(using: .utf8)!)
      .map { String(format: "%02hhx", $0) }
      .joined()
  }
}

// MARK: Reducer
/// Reducer responsible for handling logic from the chat feature.
public let chatReducer = Reducer<ChatFeatureState, ChatFeatureAction, ChatEnvironment>.combine(
  chatInputReducer.pullback(
    state: \.chatInputState,
    action: /ChatFeatureAction.chatInput,
    environment: { _ in
      ChatInputEnvironment()
    }
  ),
  Reducer<ChatFeatureState, ChatFeatureAction, ChatEnvironment> { state, action, environment in
    switch action {
    case .onAppear:
      return environment
        .userDefaultsClient
        .setChatReadTimeInterval(environment.date().timeIntervalSince1970)
        .fireAndForget()
      
    case let .chatInputResponse(.success(response)):
      state.chatInputState.isSending = false
      state.chatInputState.message.removeAll()
      
      state.chatMessages = .results(response.chatMessages)
      return .none
      
    case let .chatInputResponse(.failure(error)):
      state.chatInputState.isSending = false
      logger.debug("ChatInput Action failed with error: \(error.localizedDescription)")
      return .none
      
    case let .chatInput(chatInputAction):
      switch chatInputAction {
      case .onCommit:
        let message = ChatMessagePost(
          text: state.chatInputState.message,
          timestamp: environment.date().timeIntervalSince1970,
          identifier: environment.md5Uuid
        )        
        let body = SendLocationAndChatMessagesPostBody(
          device: environment.idProvider.id(),
          location: nil,
          messages: [message]
        )
        
        guard state.hasConnectivity else {
          logger.debug("Not sending chat input. No connectivity")
          return .none
        }
        
        state.chatInputState.isSending = true
        
        return environment.locationsAndChatDataService
          .getLocationsAndSendMessages(body)
          .receive(on: environment.mainQueue)
          .catchToEffect()
          .map(ChatFeatureAction.chatInputResponse)
        
      default:
        return .none
      }
    }
  }
)
