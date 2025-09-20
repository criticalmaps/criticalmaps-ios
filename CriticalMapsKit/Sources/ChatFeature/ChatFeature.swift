import ApiClient
import ComposableArchitecture
import CryptoKit
import Foundation
import Helpers
import IDProvider
import L10n
import os
import SharedModels
import UserDefaultsClient

@Reducer
public struct ChatFeature {
  public init() {}
  
  var md5Uuid: String {
    Insecure.MD5.hash(data: idProvider.id().data(using: .utf8)!)
      .map { String(format: "%02hhx", $0) }
      .joined()
  }

  // MARK: State
  
  @ObservableState
  public struct State: Equatable {
    public var chatMessages: ContentState<[ChatMessage]>
    public var chatInputState: ChatInput.State
    @Presents public var alert: AlertState<Action.Alert>?
    
    public var messages: [ChatMessage] {
      chatMessages.elements?
        .sorted { $0.timestamp > $1.timestamp } ?? []
    }
    
    public init(
      chatMessages: ContentState<[ChatMessage]> = .loading([]),
      chatInputState: ChatInput.State = .init()
    ) {
      self.chatMessages = chatMessages
      self.chatInputState = chatInputState
    }
  }
  
  // MARK: Actions
  
  @CasePathable
  public enum Action {
    case onAppear
    case chatInputResponse(Result<ApiResponse, any Error>)
    case fetchChatMessages
    case fetchChatMessagesResponse(Result<[ChatMessage], any Error>)
    
    case chatInput(ChatInput.Action)
    case alert(PresentationAction<Alert>)
    
    public enum Alert {
      case chat
    }
  }
  
  // MARK: Reducer

  @Dependency(\.date) var date
  @Dependency(\.apiService) var apiService
  @Dependency(\.idProvider) var idProvider
  @Dependency(\.mainQueue) var mainQueue
  @Dependency(\.uuid) var uuid
  @Dependency(\.userDefaultsClient) var userDefaultsClient
  
  public var body: some Reducer<State, Action> {
    Scope(state: \.chatInputState, action: \.chatInput) {
      ChatInput()
    }
    
    // Reducer responsible for handling logic from the chat feature.
    Reduce { state, action in
      switch action {
      case .alert:
        return .none
        
      case .onAppear:
        return .send(.fetchChatMessages)
        
      case .fetchChatMessages:
        state.chatMessages = .loading(state.chatMessages.elements ?? [])
        return .run { send in
          await send(
            .fetchChatMessagesResponse(
              Result {
                try await apiService.getChatMessages()
              }
            )
          )
        }
        
      case let .fetchChatMessagesResponse(.success(messages)):
        state.chatMessages = .results(messages)
        return .run { _ in
          await userDefaultsClient.setChatReadTimeInterval(date().timeIntervalSince1970)
        }
        
      case let .fetchChatMessagesResponse(.failure(error)):
        state.chatMessages = .error(
          .init(
            title: L10n.error,
            body: L10n.Social.Error.fetchMessages,
            error: .init(error: error)
          )
        )
        Logger.reducer.debug("FetchLocation failed: \(error)")
        return .none
        
      case .chatInputResponse(.success):
        state.chatInputState.isSending = false
        state.chatInputState.message.removeAll()
        return .send(.fetchChatMessages)
        
      case let .chatInputResponse(.failure(error)):
        state.chatInputState.isSending = false
        
        state.alert = AlertState(
          title: { TextState(L10n.error) },
          message: { TextState(L10n.Social.Error.sendMessage) }
        )
        
        Logger.reducer.debug("ChatInput Action failed with error: \(error.localizedDescription)")
        return .none
        
      case let .chatInput(chatInputAction):
        switch chatInputAction {
        case .onCommit:
          let message = ChatMessagePost(
            text: state.chatInputState.message,
            device: idProvider.id(),
            identifier: md5Uuid
          )
          
          state.chatInputState.isSending = true
          
          return .run { send in
            await send(
              .chatInputResponse(
                Result {
                  try await apiService.postChatMessage(message)
                }
              )
            )
          }
          
        default:
          return .none
        }
      }
    }
  }
}

// MARK: Logger

private extension Logger {
  /// Using your bundle identifier is a great way to ensure a unique identifier.
  private static var subsystem = "ChatFeature"
  
  /// Logs the view cycles like a view that appeared.
  static let reducer = Logger(
    subsystem: subsystem,
    category: "Reducer"
  )
}
