import ComposableArchitecture
import L10n
import Styleguide
import SwiftUI
import UIKit

public struct BasicInputView: View {
  private let placeholder: String
  @State private var store: StoreOf<ChatInput>
  @State private var contentSizeThatFits: CGSize = .zero
  
  public init(
    store: StoreOf<ChatInput>,
    placeholder: String = ""
  ) {
    self.store = store
    self.placeholder = placeholder
    _contentSizeThatFits = State(initialValue: .zero)
  }
  
  private var messageEditorHeight: CGFloat {
    min(
      contentSizeThatFits.height,
      UIScreen.main.bounds.height * 0.25
    )
  }
  
  private var messageEditorView: some View {
    MultilineTextField(
      attributedText: $store.internalAttributedMessage.sending(\.messageChanged),
      placeholder: placeholder,
      isEditing: $store.isEditing,
      textAttributes: .chat
    )
    .accessibilityLabel(Text(L10n.A11y.ChatInput.label))
    .accessibilityValue(store.message)
    .onPreferenceChange(ContentSizeThatFitsKey.self) {
      contentSizeThatFits = $0
    }
    .frame(height: messageEditorHeight)
  }
  
  private var sendButton: some View {
    Button(action: {
      store.send(.onCommit)
    }, label: {
      Circle().fill(
        withAnimation {
          store.isSendButtonDisabled ? Color(.border) : .blue
        }
      )
      .accessibleAnimation(.spring(duration: 0.13), value: store.isSendButtonDisabled)
      .accessibilityLabel(Text(L10n.Chat.send))
      .frame(width: 38, height: 38)
      .overlay(
        Group {
          if store.isSending {
            ProgressView().tint(.white)
          } else {
            Image(systemName: "paperplane.fill")
              .resizable()
              .foregroundColor(.white)
              .offset(x: -1, y: 1)
              .padding(.grid(2))
          }
        }
      )
    })
    .disabled(store.isSendButtonDisabled)
  }
  
  public var body: some View {
    VStack {
      HStack(alignment: .bottom) {
        messageEditorView
        sendButton
      }
      .padding(.grid(1))
      .background(Color.backgroundPrimary)
      .clipShape(RoundedRectangle(cornerRadius: 23))
      .overlay(
        RoundedRectangle(cornerRadius: 23)
          .stroke(Color.innerBorder, lineWidth: 1)
      )
    }
  }
}

// MARK: Implementation Details

public struct ContentSizeThatFitsKey: PreferenceKey {
  public static var defaultValue: CGSize = .zero
  
  public static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
    value = nextValue()
  }
}

struct TextAttributesKey: EnvironmentKey {
  static var defaultValue: TextAttributes = .init()
}

extension EnvironmentValues {
  var textAttributes: TextAttributes {
    get { self[TextAttributesKey.self] }
    set { self[TextAttributesKey.self] = newValue }
  }
}

struct TextAttributesModifier: ViewModifier {
  let textAttributes: TextAttributes
  
  func body(content: Content) -> some View {
    content.environment(\.textAttributes, textAttributes)
  }
}

extension View {
  func textAttributes(_ textAttributes: TextAttributes) -> some View {
    modifier(TextAttributesModifier(textAttributes: textAttributes))
  }
}
