import ApiClient
import ComposableArchitecture
import CryptoKit
import Foundation
import Helpers
import L10n
import Logger
import SharedDependencies
import SharedModels

public struct ChatFeature: ReducerProtocol {
  public init() {}
  
  @Dependency(\.date) public var date
  @Dependency(\.idProvider) public var idProvider
  @Dependency(\.locationAndChatService) public var locationAndChatService
  @Dependency(\.mainQueue) public var mainQueue
  @Dependency(\.uuid) public var uuid
  @Dependency(\.userDefaultsClient) public var userDefaultsClient
  @Dependency(\.isNetworkAvailable) public var isNetworkAvailable
  
  var md5Uuid: String {
    Insecure.MD5.hash(data: uuid().uuidString.data(using: .utf8)!)
      .map { String(format: "%02hhx", $0) }
      .joined()
  }

  // MARK: State
  
  public struct State: Equatable {
    public var chatMessages: ContentState<[String: ChatMessage]>
    public var chatInputState: ChatInput.State
    
    public init(
      chatMessages: ContentState<[String: ChatMessage]> = .loading([:]),
      chatInputState: ChatInput.State = .init()
    ) {
      self.chatMessages = chatMessages
      self.chatInputState = chatInputState
    }
  }
  
  // MARK: Actions
  
  public enum Action: Equatable {
    case onAppear
    case chatInputResponse(TaskResult<LocationAndChatMessages>)
    
    case chatInput(ChatInput.Action)
  }
  
  // MARK: Reducer
  
  public var body: some ReducerProtocol<State, Action> {
    Scope(state: \.chatInputState, action: /ChatFeature.Action.chatInput) {
      ChatInput()
    }
    
    // Reducer responsible for handling logic from the chat feature.
    Reduce { state, action in
      switch action {
      case .onAppear:
        return userDefaultsClient
          .setChatReadTimeInterval(date().timeIntervalSince1970)
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
            timestamp: date().timeIntervalSince1970,
            identifier: md5Uuid
          )
          let body = SendLocationAndChatMessagesPostBody(
            device: idProvider.id(),
            location: nil,
            messages: [message]
          )
          
          guard isNetworkAvailable else {
            logger.debug("Not sending chat input. No connectivity")
            return .none
          }
          
          state.chatInputState.isSending = true
          
          return .task {
            await .chatInputResponse(
              TaskResult {
                try await locationAndChatService.getLocationsAndSendMessages(body)
              }
            )
          }
          
        default:
          return .none
        }
      }
    }
  }
}
