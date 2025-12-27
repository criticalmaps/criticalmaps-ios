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

  public var body: some View {
    VStack {
      HStack(alignment: .bottom) {
        MessageEditorView(
          store: $store,
          placeholder: placeholder,
          contentSizeThatFits: $contentSizeThatFits,
          messageEditorHeight: messageEditorHeight
        )

        SendButton(store: store)
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

// MARK: - Subviews

private struct MessageEditorView: View {
  @Binding var store: StoreOf<ChatInput>
  let placeholder: String
  @Binding var contentSizeThatFits: CGSize
  let messageEditorHeight: CGFloat

  var body: some View {
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
}

private struct SendButton: View {
  let store: StoreOf<ChatInput>

  var body: some View {
    Button(action: { store.send(.onCommit) }) {
      Circle()
        .fill(Color.brand500)
        .frame(width: 38, height: 38)
        .overlay(OverlayView(store: store))
        .accessibleAnimation(.spring(duration: 0.13), value: store.isSendButtonDisabled)
        .accessibilityLabel(Text(L10n.Chat.send))
    }
    .opacity(store.isSendButtonDisabled ? 0 : 1)
    .animation(.snappy.speed(2.5), value: store.isSendButtonDisabled)
  }
}

// MARK: - SubViews

private struct OverlayView: View {
  let store: StoreOf<ChatInput>
  
  var body: some View {
    if store.isSending {
      ProgressView()
        .tint(.textPrimaryLight)
    } else {
      Image(systemName: "paperplane.fill")
        .resizable()
        .foregroundColor(.textPrimaryLight)
        .offset(x: -1, y: 1)
        .padding(.grid(2))
    }
  }
}

// MARK: - Implementation Details

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
