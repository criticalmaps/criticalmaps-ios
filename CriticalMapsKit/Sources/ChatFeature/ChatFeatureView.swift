import ComposableArchitecture
import L10n
import SharedModels
import Styleguide
import SwiftUI

/// A list to show messages from the chat and send a message
public struct ChatView: View {
  public struct ViewState: Equatable {
    public var identifiedChatMessages: [IdentifiedChatMessage]
    
    public init(_ state: ChatFeature.State) {
      identifiedChatMessages = state.chatMessages.elements?
        .compactMap { (key: String, value: ChatMessage) in
          IdentifiedChatMessage(
            id: key,
            message: value.decodedMessage ?? "",
            timestamp: value.timestamp
          )
        }
        .sorted { $0.timestamp > $1.timestamp } ?? []
    }
  }
  
  let store: Store<ChatFeature.State, ChatFeature.Action>
  @ObservedObject var viewStore: ViewStore<ViewState, ChatFeature.Action>
  
  public init(store: Store<ChatFeature.State, ChatFeature.Action>) {
    self.store = store
    viewStore = ViewStore(store.scope(state: ViewState.init))
  }
  
  public var body: some View {
    VStack {
      ZStack(alignment: .bottom) {
        Color(.backgroundPrimary)
          .ignoresSafeArea()
          .accessibilityHidden(true)
        
        if viewStore.identifiedChatMessages.isEmpty {
          emptyState
            .accessibilitySortPriority(-1)
        } else {
          List(viewStore.identifiedChatMessages) { chat in
            ChatMessageView(chat)
              .padding(.horizontal, .grid(4))
              .padding(.vertical, .grid(2))
              .animation(nil, value: viewStore.identifiedChatMessages)
          }
          .listRowBackground(Color(.backgroundPrimary))
          .listStyle(PlainListStyle())
          .accessibleAnimation(.easeOut, value: viewStore.identifiedChatMessages)
        }
      }
      
      chatInput
    }
    .onAppear { viewStore.send(.onAppear) }
    .navigationBarTitleDisplayMode(.inline)
    .ignoresSafeArea(.container, edges: .bottom)
  }
  
  private var chatInput: some View {
    ZStack(alignment: .top) {
      BasicInputView(
        store: self.store.scope(
          state: \.chatInputState,
          action: ChatFeature.Action.chatInput
        ),
        placeholder: L10n.Chat.placeholder
      )
      .padding(.horizontal, .grid(3))
      .padding(.top, .grid(2))
      .padding(.bottom, .grid(7))
      
      Color(.border)
        .frame(height: 2)
    }
    .background(Color(.backgroundSecondary))
  }
  
  private var emptyState: some View {
    EmptyStateView(
      emptyState: .init(
        icon: Asset.chatEmpty.image,
        text: L10n.Chat.emptyMessageTitle,
        message: .init(
          string: L10n.Chat.noChatActivity
        )
      )
    )
  }
}

// MARK: Preview

struct ChatView_Previews: PreviewProvider {
  static var previews: some View {
    ChatView(
      store: Store<ChatFeature.State, ChatFeature.Action>(
        initialState: .init(
          chatMessages: .results(
            ["1": .init(message: "Hello World 🌐", timestamp: 1)])
        ),
        reducer: ChatFeature().debug()
      )
    )
  }
}
