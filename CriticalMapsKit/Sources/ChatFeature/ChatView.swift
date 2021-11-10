import ComposableArchitecture
import L10n
import SharedModels
import Styleguide
import SwiftUI

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
  
  @State var text: String = ""
  @State var isEditing = false
  
  let store: Store<ChatFeatureState, ChatFeatureAction>
  @ObservedObject var viewStore: ViewStore<ChatViewState, ChatFeatureAction>
  
  public init(store: Store<ChatFeatureState, ChatFeatureAction>) {
    self.store = store
    self.viewStore = ViewStore(store.scope(state: ChatViewState.init))
  }
  public var body: some View {
    
    VStack {
      ZStack(alignment: .bottom) {
        Color(.backgroundPrimary)
          .ignoresSafeArea()
        
        if viewStore.identifiedChatMessages.isEmpty {
          emptyState
        } else {
          withAnimation {
            List(viewStore.identifiedChatMessages) { chat in
              ChatMessageView(chat)
              .padding(.horizontal, .grid(4))
              .padding(.vertical, .grid(2))
            }
            .listRowBackground(Color(.backgroundPrimary))
            .listStyle(PlainListStyle())
          }
        }
      }
      
      chatInput
    }
    .navigationBarTitleDisplayMode(.inline)
    .ignoresSafeArea(.container, edges: .bottom)
  }
  
  private var chatInput: some View {
    ZStack(alignment: .top) {
      HStack(alignment: .center) {
        BasicInputView(
          message: $text,
          isEditing: $isEditing,
          placeholder: "Message...",
          onCommit: { _ in }
        )
      }
      .padding(.horizontal, .grid(3))
      .padding(.top, .grid(1))
      .padding(.bottom, 24)
      
      Color(.border)
        .frame(height: 2)
    }
    .background(Color(.backgroundSecondary))
  }
  
  private var emptyState: some View {
    EmptyStateView(
      emptyState: .init(
        icon: Images.chatEmptyPlaceholder,
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
    ChatView(store: Store<ChatFeatureState, ChatFeatureAction>(
      initialState: ChatFeatureState(),
      reducer: chatReducer,
      environment: ChatEnvironment()
    )
    )
  }
}
