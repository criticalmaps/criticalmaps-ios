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

public enum ChatFeature {
  // MARK: State
  
  public struct State: Equatable {
    public var chatMessages: ContentState<[String: ChatMessage]>
    public var chatInputState: ChatInput.State
    public var hasConnectivity: Bool
    
    public init(
      chatMessages: ContentState<[String: ChatMessage]> = .loading([:]),
      chatInputState: ChatInput.State = .init(),
      hasConnectivity: Bool = true
    ) {
      self.chatMessages = chatMessages
      self.chatInputState = chatInputState
      self.hasConnectivity = hasConnectivity
    }
  }
  
  // MARK: Actions
  
  public enum Action: Equatable {
    case onAppear
    case chatInputResponse(TaskResult<LocationAndChatMessages>)
    
    case chatInput(ChatInput.Action)
  }
  
  // MARK: Environment
  
  public struct Environment {
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
  public static let reducer = Reducer<ChatFeature.State, ChatFeature.Action, ChatFeature.Environment>.combine(
    ChatInput.reducer.pullback(
      state: \.chatInputState,
      action: /ChatFeature.Action.chatInput,
      environment: { _ in
        ChatInput.Environment()
      }
    ),
    Reducer<State, Action, Environment> { state, action, environment in
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
          
          return .task {
            await .chatInputResponse(
              TaskResult {
                try await environment.locationsAndChatDataService.getLocationsAndSendMessages(body)
              }
            )
          }
          
        default:
          return .none
        }
      }
    }
  )
}
