import ComposableArchitecture
import L10n
import SharedModels
import Styleguide
import SwiftUI

/// A list to show messages from the chat and send a message
public struct ChatView: View {
  @State private var store: StoreOf<ChatFeature>
  
  public init(store: StoreOf<ChatFeature>) {
    self.store = store
  }
  
  public var body: some View {
    VStack {
      ZStack(alignment: .bottom) {
        Color(.backgroundPrimary)
          .ignoresSafeArea()
          .accessibilityHidden(true)
        
        if store.messages.isEmpty {
          emptyState
            .accessibilitySortPriority(-1)
        } else {
          List(store.messages) { chat in
            ChatMessageView(chat)
              .padding(.horizontal, .grid(4))
              .padding(.vertical, .grid(2))
              .animation(nil, value: store.messages)
          }
          .listRowBackground(Color.backgroundPrimary)
          .listStyle(.plain)
          .accessibleAnimation(.spring, value: store.messages)
        }
      }
      
      chatInput
    }
    .alert(store: store.scope(state: \.$alert, action: \.alert))
    .onAppear { store.send(.onAppear) }
    .navigationBarTitleDisplayMode(.inline)
    .ignoresSafeArea(.container, edges: .bottom)
  }
  
  private var chatInput: some View {
    ZStack(alignment: .top) {
      BasicInputView(
        store: store.scope(
          state: \.chatInputState,
          action: \.chatInput
        ),
        placeholder: L10n.Chat.placeholder
      )
      .padding(.horizontal, .grid(3))
      .padding(.top, .grid(2))
      .padding(.bottom, .grid(7))
      
      Color(.border)
        .frame(height: 2)
    }
    .background(Color.backgroundSecondary)
  }
  
  private var emptyState: some View {
    EmptyStateView(
      emptyState: .init(
        icon: Asset.chatEmpty.image,
        text: L10n.Chat.emptyMessageTitle,
        message: AttributedString(L10n.Chat.noChatActivity)
      )
    )
  }
}

// MARK: Preview

#Preview {
  ChatView(
    store: StoreOf<ChatFeature>(
      initialState: ChatFeature.State(),
      reducer: { ChatFeature()._printChanges() }
    )
  )
}
