import ComposableArchitecture
import Foundation
import L10n
import SharedModels
import Styleguide
import SwiftUI

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

fileprivate typealias S = ChatFeatureState
fileprivate typealias A = ChatFeatureAction

// MARK:- View
public struct ChatView: View {
  typealias V = ChatViewState
  
  struct ChatViewState: Equatable {
    public var identifiedChatMessages: [IdentifiedChatMessage]
    
    init(_ state: ChatFeatureState) {
      identifiedChatMessages = state.chatMessages
        .lazy
        .map { (key: String, value: ChatMessage) in
          IdentifiedChatMessage(
            id: key,
            message: value.decodedMessage ?? "",
            timestamp: value.timestamp
          )
        }
        .sorted { $0.timestamp > $1.timestamp }
    }
  }
  
  let store: Store<ChatFeatureState, ChatFeatureAction>
  @ObservedObject var viewStore: ViewStore<ChatViewState, ChatFeatureAction>
  
  public init(store: Store<ChatFeatureState, ChatFeatureAction>) {
    self.store = store
    self.viewStore = ViewStore(store.scope(state: ChatViewState.init))
  }
  public var body: some View {
    ZStack {
      Color(.backgroundPrimary)
        .ignoresSafeArea()

      if viewStore.identifiedChatMessages.isEmpty {
        EmptyStateView(
          emptyState: .init(
            icon: Images.chatEmptyPlaceholder,
            text: L10n.Chat.emptyMessageTitle,
            message: .init(
              string: L10n.Chat.noChatActivity
            )
          )
        )
      } else {
        withAnimation {
          List(viewStore.identifiedChatMessages) { chat in
            VStack(alignment: .leading, spacing: .grid(1)) {
              Text(chat.chatTime)
                .foregroundColor(Color(.textPrimary))
                .font(.meta)
              Text(chat.message)
                .foregroundColor(Color(.textSecondary))
                .font(.bodyOne)
            }
            .padding(.horizontal, .grid(4))
            .padding(.vertical, .grid(2))
          }
          .listRowBackground(Color(.backgroundPrimary))
          .listStyle(PlainListStyle())
        }
      }
    }
    .navigationBarTitleDisplayMode(.inline)
  }
}

// MARK: Preview
struct ChatView_Previews: PreviewProvider {
  static var previews: some View {
    ChatView(store: Store<ChatFeatureState, ChatFeatureAction>(
      initialState: ChatFeatureState(),
      reducer: chatReducer,
      environment: ChatEnvironment()
    )
    )
  }
}
